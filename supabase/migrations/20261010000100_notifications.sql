-- =========================================================
-- Notifications: deadline reminders + admin broadcast
-- =========================================================

-- Creates one reminder per bookmarked opportunity whose deadline is
-- within the next 3 days. Safe to run repeatedly.
create or replace function public.generate_deadline_reminders()
returns int
language plpgsql
security definer
set search_path = ''
as $$
declare
  inserted int;
begin
  insert into public.notifications (user_id, opportunity_id, kind, title, body)
  select
    b.user_id,
    o.id,
    'deadline',
    'Deadline segera: ' || o.title,
    case
      when o.end_date = current_date then 'Pendaftaran ditutup hari ini.'
      else 'Pendaftaran ditutup ' || (o.end_date - current_date) || ' hari lagi.'
    end
  from public.bookmarks b
  join public.opportunities o on o.id = b.opportunity_id
  where o.is_published
    and o.end_date between current_date and current_date + 3
  on conflict (user_id, opportunity_id) where kind = 'deadline' do nothing;

  get diagnostics inserted = row_count;
  return inserted;
end;
$$;

revoke execute on function public.generate_deadline_reminders() from public, anon, authenticated;

-- Admin-only: send an announcement to every user.
create or replace function public.broadcast_notification(
  p_title text,
  p_body text,
  p_opportunity_id uuid default null
)
returns int
language plpgsql
security definer
set search_path = ''
as $$
declare
  inserted int;
begin
  if not public.is_admin() then
    raise exception 'forbidden' using errcode = '42501';
  end if;

  insert into public.notifications (user_id, opportunity_id, kind, title, body)
  select id, p_opportunity_id, 'announcement', p_title, coalesce(p_body, '')
  from public.profiles;

  get diagnostics inserted = row_count;
  return inserted;
end;
$$;

revoke execute on function public.broadcast_notification(text, text, uuid) from public, anon;
grant execute on function public.broadcast_notification(text, text, uuid) to authenticated;

-- Realtime for the unread badge
alter publication supabase_realtime add table public.notifications;

-- Daily schedule (07:00 WIB = 00:00 UTC)
create extension if not exists pg_cron with schema pg_catalog;
select cron.schedule(
  'deadline-reminders',
  '0 0 * * *',
  $$ select public.generate_deadline_reminders(); $$
);
