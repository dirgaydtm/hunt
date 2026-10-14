# Hunt

Aplikasi Flutter untuk mencari peluang mahasiswa: **Beasiswa**, **Lomba**, dan **Magang**. Backend memakai [Supabase](https://supabase.com) (Auth, Postgres + RLS, Storage, Realtime).

## Fitur

**Pengguna**
- Onboarding (sekali tampil), login/daftar email, Google OAuth, lupa & reset kata sandi
- Home: rekomendasi, kategori, pengingat deadline terdekat
- Pencarian + filter kategori, lokasi, dan rentang tanggal
- Detail peluang: syarat/berkas/ketentuan, buka link pendaftaran, share
- Kalender event per bulan, filter kategori dan tanggal
- Bookmark (toggle dari kartu maupun detail)
- Notifikasi in-app realtime: pengingat deadline bookmark (H-3) dan pengumuman admin
- Profil: edit data diri dan foto

**Admin** (role `admin`, menu di halaman profil)
- CRUD peluang (termasuk draft), upload gambar, tandai rekomendasi
- Broadcast notifikasi ke semua pengguna
- Kelola pengguna: beri/cabut akses admin

## Setup

1. **Buat project** di [supabase.com](https://supabase.com). Catat *Project URL* dan *publishable key* (atau anon key lama).
2. **Jalankan skema database**, pilih salah satu:
   - Supabase CLI: `supabase link --project-ref <ref>` lalu `supabase db push --include-seed`
   - Manual: buka SQL Editor, jalankan isi `supabase/migrations/*.sql` berurutan, lalu `supabase/seed.sql`
3. **Auth → URL Configuration**: tambahkan redirect URL `io.supabase.hunt://login-callback` (dipakai Google OAuth, konfirmasi email, dan reset password).
4. *(Opsional)* **Auth → Providers → Google**: isi Client ID/Secret dari Google Cloud Console.
5. **Konfigurasi app**: salin `.env.example` menjadi `.env` lalu isi `SUPABASE_URL` dan `SUPABASE_ANON_KEY`. `.env` tidak di-commit.
6. **Jalankan**:
   ```bash
   flutter pub get
   flutter run
   ```
7. **Admin pertama**: daftar akun lewat app, lalu jalankan di SQL Editor:
   ```sql
   update profiles set role = 'admin' where email = 'kamu@contoh.com';
   ```

Pengingat deadline dijadwalkan harian via `pg_cron` (00:00 UTC). Untuk mencoba manual: `select generate_deadline_reminders();`

## Testing

```bash
flutter analyze
flutter test
```

## Struktur

```
lib/
├── main.dart                 # init Supabase + SharedPreferences
├── app/
│   ├── app.dart              # MaterialApp.router
│   └── config/
│       ├── app_router.dart   # go_router + guard login/admin
│       └── auth_redirect.dart
├── core/
│   ├── config/env.dart       # baca .env (flutter_dotenv)
│   ├── errors/failures.dart  # exception → pesan Indonesia
│   ├── preferences/
│   ├── supabase/
│   ├── theme/
│   └── utils/
├── features/
│   ├── onboarding/
│   ├── auth/
│   ├── home/                 # home, search, detail
│   ├── calendar/
│   ├── bookmark/
│   ├── notifications/
│   ├── profile/
│   └── admin/
│       ├── data/{services,repositories}
│       └── presentation/{providers,pages,widgets}
└── shared/
    ├── constants/            # daftar lokasi
    ├── data/                 # OpportunityService/Repository + providers
    ├── models/               # OpportunityModel
    └── widgets/

supabase/
├── migrations/               # skema, RLS, storage, notifikasi
└── seed.sql                  # data contoh
```
