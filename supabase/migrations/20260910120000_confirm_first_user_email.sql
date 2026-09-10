CREATE OR REPLACE FUNCTION public.confirm_first_user_email()
 RETURNS trigger
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO ''
AS $function$
begin
  -- First signup cannot wait on SMTP. Confirm immediately so setup can finish.
  if new.email_confirmed_at is null
     and not exists (select 1 from public.sales limit 1) then
    new.email_confirmed_at = now();
  end if;
  return new;
end;
$function$;

grant all on function public.confirm_first_user_email() to anon;
grant all on function public.confirm_first_user_email() to authenticated;
grant all on function public.confirm_first_user_email() to service_role;

create or replace trigger on_auth_user_created_confirm_first
    before insert on auth.users
    for each row execute function public.confirm_first_user_email();

-- Unblock an already-created first admin who never received a confirmation email.
update auth.users as u
set email_confirmed_at = now()
from public.sales as s
where s.user_id = u.id
  and s.administrator = true
  and u.email_confirmed_at is null;
