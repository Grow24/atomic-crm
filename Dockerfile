# Zeabur Git deploy requires a Dockerfile.
# Same idea as local `make prod-start`: Vite build, then `serve` the dist folder.
# Docs: https://zeabur.com/docs/en-US/deploy/methods/dockerfile

FROM node:22-alpine AS builder

WORKDIR /app

COPY package.json package-lock.json ./
RUN npm ci --ignore-scripts

COPY . .

# Vite bakes these into the JS bundle at build time. Set the same names
# as Zeabur Variables so the cloud app talks to hosted Supabase.
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

RUN if [ -z "$VITE_SUPABASE_URL" ] || [ -z "$VITE_SB_PUBLISHABLE_KEY" ]; then \
      echo "Missing VITE_SUPABASE_URL or VITE_SB_PUBLISHABLE_KEY. Add them in Zeabur Variables, then Redeploy." >&2; \
      exit 1; \
    fi

RUN npm run build

FROM node:22-alpine

WORKDIR /app
RUN npm install -g serve@14
COPY --from=builder /app/dist ./dist

ENV PORT=8080 \
    HOST=0.0.0.0 \
    NODE_ENV=production

EXPOSE 8080

# `-s` keeps React Router working (same as opening /contacts, /login).
CMD ["sh", "-c", "serve -s dist -l tcp://0.0.0.0:${PORT}"]
