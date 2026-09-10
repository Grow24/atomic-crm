import { test, expect } from "./fixtures";

test("confirmation page lets the user sign in without waiting for email", async ({
  page,
}) => {
  await page.goto("/#/sign-up/confirm");

  await expect(
    page.getByText(
      "Please follow the link we just sent you by email to confirm your account.",
    ),
  ).toBeVisible();
  await expect(
    page.getByText(
      "Didn't get the email? Sign in with the password you just created.",
    ),
  ).toBeVisible();

  await page.getByRole("link", { name: "Sign in" }).click();

  await expect(page.getByRole("heading", { name: "Sign in" })).toBeVisible();
});
