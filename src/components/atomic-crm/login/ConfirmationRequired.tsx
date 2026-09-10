import { useTranslate } from "ra-core";
import { Link } from "react-router";
import { Notification } from "@/components/admin/notification";
import { Button } from "@/components/ui/button";
import { useConfigurationContext } from "../root/ConfigurationContext";

export const ConfirmationRequired = () => {
  const translate = useTranslate();
  const { darkModeLogo: logo, title } = useConfigurationContext();

  return (
    <div className="h-screen p-8">
      <div className="flex items-center gap-4">
        <img
          src={logo}
          alt={title}
          width={24}
          className="filter brightness-0 dark:invert"
        />
        <h1 className="text-xl font-semibold">{title}</h1>
      </div>
      <div className="h-full text-center">
        <div className="max-w-sm mx-auto h-full flex flex-col justify-center gap-4">
          <h1 className="text-2xl font-bold mb-4">
            {translate("crm.auth.welcome_title", {
              _: "Welcome to Atomic CRM",
            })}
          </h1>
          <p className="text-base mb-4">
            {translate("crm.auth.confirmation_required", {
              _: "Please follow the link we just sent you by email to confirm your account.",
            })}
          </p>
          <p className="text-sm text-muted-foreground mb-2">
            {translate("crm.auth.confirmation_sign_in_hint", {
              _: "Didn't get the email? Sign in with the password you just created.",
            })}
          </p>
          <Button asChild className="w-full">
            <Link to="/login">
              {translate("ra.auth.sign_in", { _: "Sign in" })}
            </Link>
          </Button>
        </div>
      </div>
      <Notification />
    </div>
  );
};

ConfirmationRequired.path = "/sign-up/confirm";
