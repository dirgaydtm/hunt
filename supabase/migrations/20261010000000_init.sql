-- =========================================================
-- Hunt: initial schema
-- =========================================================

create type public.opportunity_category as enum ('beasiswa', 'lomba', 'magang');
create type public.user_role as enum ('user', 'admin');

-- ---------------------------------------------------------
-- profiles
-- ---------------------------------------------------------
create table public.profiles (
  id uuid primary key references auth.users (id) on delete cascade,
  email text not null,
  name text not null default '',
  university text,
  major text,
  graduation_year int,
  avatar_path text,
  role public.user_role not null default 'user',
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create or replace function public.is_admin()
returns boolean
language sql
stable
security definer
set search_path = ''
as $$
  select exists (
    select 1 from public.profiles
    where id = (select auth.uid()) and role = 'admin'
  );
$$;

create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
begin
  insert into public.profiles (id, email, name)
  values (
    new.id,
    new.email,
    coalesce(
      new.raw_user_meta_data ->> 'name',
      new.raw_user_meta_data ->> 'full_name',
      split_part(new.email, '@', 1)
    )
  );
  return new;
end;
$$;

create trigger on_auth_user_created
  after insert on auth.users
  for each row execute function public.handle_new_user();

-- Only admins may change role; everyone else keeps the old value.
create or replace function public.protect_profile_role()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
begin
  if new.role is distinct from old.role and not public.is_admin() then
    new.role := old.role;
  end if;
  new.email := old.email;
  new.updated_at := now();
  return new;
end;
$$;

create trigger profiles_protect_role
  before update on public.profiles
  for each row execute function public.protect_profile_role();

-- ---------------------------------------------------------
-- opportunities
-- ---------------------------------------------------------
create table public.opportunities (
  id uuid primary key default gen_random_uuid(),
  title text not null,
  organizer text not null,
  category public.opportunity_category not null,
  location text,
  description text,
  requirements text[] not null default '{}',
  documents text[] not null default '{}',
  terms text[] not null default '{}',
  start_date date,
  end_date date,
  event_date date,
  registration_url text,
  image_path text,
  is_recommended boolean not null default false,
  is_published boolean not null default true,
  created_by uuid references public.profiles (id) on delete set null,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint opportunities_date_range check (
    start_date is null or end_date is null or start_date <= end_date
  )
);

create index opportunities_end_date_idx on public.opportunities (end_date);
create index opportunities_event_date_idx on public.opportunities (event_date);
create index opportunities_category_idx on public.opportunities (category);

create or replace function public.touch_updated_at()
returns trigger
language plpgsql
set search_path = ''
as $$
begin
  new.updated_at := now();
  return new;
end;
$$;

create trigger opportunities_touch
  before update on public.opportunities
  for each row execute function public.touch_updated_at();

-- ---------------------------------------------------------
-- bookmarks
-- ---------------------------------------------------------
create table public.bookmarks (
  user_id uuid not null references public.profiles (id) on delete cascade,
  opportunity_id uuid not null references public.opportunities (id) on delete cascade,
  created_at timestamptz not null default now(),
  primary key (user_id, opportunity_id)
);

create index bookmarks_opportunity_idx on public.bookmarks (opportunity_id);

-- ---------------------------------------------------------
-- notifications
-- ---------------------------------------------------------
create table public.notifications (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.profiles (id) on delete cascade,
  opportunity_id uuid references public.opportunities (id) on delete cascade,
  kind text not null default 'announcement', -- 'announcement' | 'deadline'
  title text not null,
  body text not null default '',
  read_at timestamptz,
  created_at timestamptz not null default now()
);

create index notifications_user_idx on public.notifications (user_id, created_at desc);
-- one deadline reminder per user per opportunity
create unique index notifications_deadline_unique
  on public.notifications (user_id, opportunity_id)
  where kind = 'deadline';

-- =========================================================
-- Row Level Security
-- =========================================================
alter table public.profiles enable row level security;
alter table public.opportunities enable row level security;
alter table public.bookmarks enable row level security;
alter table public.notifications enable row level security;

-- profiles
create policy "profiles: read own or admin"
  on public.profiles for select to authenticated
  using (id = (select auth.uid()) or public.is_admin());

create policy "profiles: update own or admin"
  on public.profiles for update to authenticated
  using (id = (select auth.uid()) or public.is_admin())
  with check (id = (select auth.uid()) or public.is_admin());

-- opportunities
create policy "opportunities: read published or admin"
  on public.opportunities for select to authenticated
  using (is_published or public.is_admin());

create policy "opportunities: admin insert"
  on public.opportunities for insert to authenticated
  with check (public.is_admin());

create policy "opportunities: admin update"
  on public.opportunities for update to authenticated
  using (public.is_admin()) with check (public.is_admin());

create policy "opportunities: admin delete"
  on public.opportunities for delete to authenticated
  using (public.is_admin());

-- bookmarks
create policy "bookmarks: read own"
  on public.bookmarks for select to authenticated
  using (user_id = (select auth.uid()));

create policy "bookmarks: insert own"
  on public.bookmarks for insert to authenticated
  with check (user_id = (select auth.uid()));

create policy "bookmarks: delete own"
  on public.bookmarks for delete to authenticated
  using (user_id = (select auth.uid()));

-- notifications (inserts happen via security definer functions only)
create policy "notifications: read own"
  on public.notifications for select to authenticated
  using (user_id = (select auth.uid()));

create policy "notifications: update own"
  on public.notifications for update to authenticated
  using (user_id = (select auth.uid()))
  with check (user_id = (select auth.uid()));

create policy "notifications: delete own"
  on public.notifications for delete to authenticated
  using (user_id = (select auth.uid()));

-- =========================================================
-- Storage
-- =========================================================
insert into storage.buckets (id, name, public)
values ('opportunity-images', 'opportunity-images', true),
       ('avatars', 'avatars', true)
on conflict (id) do nothing;

create policy "opportunity-images: admin write"
  on storage.objects for insert to authenticated
  with check (bucket_id = 'opportunity-images' and public.is_admin());

create policy "opportunity-images: admin update"
  on storage.objects for update to authenticated
  using (bucket_id = 'opportunity-images' and public.is_admin());

create policy "opportunity-images: admin delete"
  on storage.objects for delete to authenticated
  using (bucket_id = 'opportunity-images' and public.is_admin());

create policy "avatars: owner write"
  on storage.objects for insert to authenticated
  with check (
    bucket_id = 'avatars'
    and (storage.foldername(name))[1] = (select auth.uid())::text
  );

create policy "avatars: owner update"
  on storage.objects for update to authenticated
  using (
    bucket_id = 'avatars'
    and (storage.foldername(name))[1] = (select auth.uid())::text
  );

create policy "avatars: owner delete"
  on storage.objects for delete to authenticated
  using (
    bucket_id = 'avatars'
    and (storage.foldername(name))[1] = (select auth.uid())::text
  );
