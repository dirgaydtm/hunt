-- The role guard must only apply to API users. As security definer it ran
-- as the owner and auth.uid() was null in the SQL editor, so even the
-- documented "make first admin" update was silently reverted.
-- Direct database access (SQL editor, postgres, service_role) already has
-- full control, so it is not restricted here.
create or replace function public.protect_profile_role()
returns trigger
language plpgsql
security invoker
set search_path = ''
as $$
begin
  if current_user in ('authenticated', 'anon') then
    if new.role is distinct from old.role and not public.is_admin() then
      new.role := old.role;
    end if;
    new.email := old.email;
  end if;
  new.updated_at := now();
  return new;
end;
$$;
