import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Values from the `.env` asset (see `.env.example`).
abstract final class Env {
  static Future<void> load() => dotenv.load(fileName: '.env');

  static String get supabaseUrl => dotenv.env['SUPABASE_URL'] ?? '';

  /// Publishable key (`sb_publishable_...`) or legacy anon key.
  static String get supabaseAnonKey =>
      dotenv.env['SUPABASE_ANON_KEY'] ??
      dotenv.env['SUPABASE_PUBLISHABLE_KEY'] ??
      '';
}
