import { test, expect } from "./fixtures";

test("login page links to the signup form", async ({ page, createSales }) => {
  await createSales({
    first_name: "Ada",
    last_name: "Lovelace",
    email: "ada@example.com",
    password: "password",
    administrator: true,
  });

  await page.goto("/#/login");

  await expect(page.getByRole("heading", { name: "Sign in" })).toBeVisible();

  await page.getByRole("link", { name: "Sign up" }).click();

  await expect(
    page.getByRole("button", { name: "Create account" }),
  ).toBeVisible();
  await expect(page.getByLabel("First name")).toBeVisible();
});
