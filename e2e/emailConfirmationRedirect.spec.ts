import { test, expect } from "./fixtures";

test("email confirmation hash is forwarded to the auth callback", async ({
  page,
}) => {
  await page.goto(
    "/#access_token=test-token&refresh_token=test-refresh&type=signup",
  );

  await expect(page).toHaveURL(/#\/auth-callback/);
});
