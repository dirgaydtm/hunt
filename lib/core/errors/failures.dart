import 'package:supabase_flutter/supabase_flutter.dart';

/// Converts backend exceptions into user-facing Indonesian messages.
String failureMessage(Object error) {
  if (error is AuthException) {
    return switch (error.code) {
      'invalid_credentials' => 'Email atau password salah.',
      'email_not_confirmed' => 'Email belum dikonfirmasi. Cek inbox kamu.',
      'user_already_exists' => 'Email sudah terdaftar.',
      'weak_password' => 'Password terlalu lemah.',
      'over_email_send_rate_limit' =>
        'Terlalu banyak percobaan. Coba lagi nanti.',
      _ => error.message,
    };
  }
  if (error is PostgrestException) {
    if (error.code == '42501') return 'Kamu tidak punya akses untuk aksi ini.';
    return 'Terjadi kesalahan pada server.';
  }
  if (error is StorageException) return 'Gagal mengunggah file.';
  return 'Terjadi kesalahan. Coba lagi.';
}
