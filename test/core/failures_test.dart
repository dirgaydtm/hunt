import 'package:flutter_test/flutter_test.dart';
import 'package:hunt/core/errors/failures.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() {
  test('maps known auth error codes', () {
    expect(
      failureMessage(const AuthException('x', code: 'invalid_credentials')),
      'Email atau password salah.',
    );
    expect(
      failureMessage(const AuthException('x', code: 'user_already_exists')),
      'Email sudah terdaftar.',
    );
  });

  test('falls back to the auth message for unknown codes', () {
    expect(failureMessage(const AuthException('Boom')), 'Boom');
  });

  test('maps RLS denial and other database errors', () {
    expect(
      failureMessage(const PostgrestException(message: 'x', code: '42501')),
      'Kamu tidak punya akses untuk aksi ini.',
    );
    expect(
      failureMessage(const PostgrestException(message: 'x', code: '23505')),
      'Terjadi kesalahan pada server.',
    );
  });

  test('generic fallback', () {
    expect(failureMessage(Exception()), 'Terjadi kesalahan. Coba lagi.');
  });
}
