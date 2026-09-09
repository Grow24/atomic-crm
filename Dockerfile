# Zeabur Git deploy requires a Dockerfile (auto-detect is not available
# for this Git source). Multi-stage: Vite build, then nginx for the SPA.
# Docs: https://zeabur.com/docs/en-US/deploy/methods/dockerfile

FROM node:22-alpine AS builder

WORKDIR /app

COPY package.json package-lock.json ./
RUN npm ci --ignore-scripts

COPY . .

# Vite bakes these into the bundle at build time. Zeabur injects matching
# service Variables as ARGs on multi-stage builds.
ARG VITE_SUPABASE_URL
ARG VITE_SB_PUBLISHABLE_KEY
ARG VITE_IS_DEMO=false
ARG VITE_ATTACHMENTS_BUCKET=attachments
ARG VITE_INBOUND_EMAIL=""
ENV VITE_SUPABASE_URL=$VITE_SUPABASE_URL \
    VITE_SB_PUBLISHABLE_KEY=$VITE_SB_PUBLISHABLE_KEY \
    VITE_IS_DEMO=$VITE_IS_DEMO \
    VITE_ATTACHMENTS_BUCKET=$VITE_ATTACHMENTS_BUCKET \
    VITE_INBOUND_EMAIL=$VITE_INBOUND_EMAIL \
    CI=true

RUN npm run build

FROM nginx:alpine

COPY nginx.conf /etc/nginx/conf.d/configfile.template
COPY --from=builder /app/dist /usr/share/nginx/html

ENV PORT=8080 \
    HOST=0.0.0.0

EXPOSE 8080

CMD sh -c "envsubst '\$PORT' < /etc/nginx/conf.d/configfile.template > /etc/nginx/conf.d/default.conf && nginx -g 'daemon off;'"
