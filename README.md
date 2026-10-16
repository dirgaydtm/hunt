# Hunt

A Flutter app for students hunting scholarships, competitions, and internships.

* **One feed.** Beasiswa, Lomba, and Magang in one place, with search and filters for category, location, and registration dates.
* **No missed deadlines.** Bookmark an opportunity and get a reminder three days before it closes.
* **Admin panel.** Post opportunities, broadcast announcements, and decide who else can manage them.

Runs on [Supabase](https://supabase.com) (Auth, Postgres with RLS, Storage, Realtime). The app itself is in Indonesian.

## Setup

1. Create a project on [supabase.com](https://supabase.com) and grab the Project URL and publishable key.

2. Push the schema and sample data:

   ```bash
   supabase link --project-ref <ref>
   supabase db push --include-seed
   ```

   No CLI? Run `supabase/migrations/*.sql` in order, then `supabase/seed.sql`, in the SQL Editor.

3. In Auth > URL Configuration, add `io.supabase.hunt://login-callback`. Google login and email confirmation need it. Google login also needs a Client ID and Secret in Auth > Providers > Google.

4. Add your keys:

   ```bash
   cp .env.example .env
   ```

   Fill in `SUPABASE_URL` and `SUPABASE_ANON_KEY`. Use the publishable or anon key, never `service_role`.

5. Run it:

   ```bash
   flutter pub get
   flutter run
   ```

## Usage

Sign up in the app, then make yourself an admin from the SQL Editor:

```sql
update profiles set role = 'admin' where email = 'you@example.com';
```

The admin panel shows up on your profile page.

Deadline reminders go out every day at 00:00 UTC through `pg_cron`. To send them right away:

```sql
select generate_deadline_reminders();
```

## Structure

```
lib/
├── main.dart          # starts Supabase and SharedPreferences
├── app/               # MaterialApp, router, login and admin guards
├── core/              # theme, shared widgets, opportunity data, utils
└── features/
    ├── splash/
    ├── onboarding/
    ├── auth/
    ├── home/          # home, search, opportunity detail
    ├── calendar/
    ├── bookmark/
    ├── notifications/
    ├── profile/
    └── admin/

supabase/
├── migrations/        # schema, RLS, storage, notifications
└── seed.sql           # sample data
```

## Testing

```bash
flutter analyze
flutter test
```
