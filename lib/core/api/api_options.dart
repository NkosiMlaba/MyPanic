/// Compile-time config — pass via --dart-define.
///
/// Example:
/// flutter run -d EPHUT21114025983 \
///   --dart-define=SUPABASE_URL=https://xxx.supabase.co \
///   --dart-define=SUPABASE_ANON_KEY=eyJ... \
///   --dart-define=MYPANIC_API_BASE_URL=http://10.0.2.2:5000
///
/// Note: 10.0.2.2 is how Android emulators reach localhost. For a real device
/// on the same WiFi, use the dev machine's LAN IP (e.g. http://192.168.1.50:5000).
class ApiOptions {
  static const supabaseUrl = String.fromEnvironment('SUPABASE_URL');
  static const supabaseAnonKey = String.fromEnvironment('SUPABASE_ANON_KEY');
  static const apiBaseUrl = String.fromEnvironment('MYPANIC_API_BASE_URL');

  static void assertConfigured() {
    if (supabaseUrl.isEmpty || supabaseAnonKey.isEmpty || apiBaseUrl.isEmpty) {
      throw StateError(
        'Missing --dart-define values. Need SUPABASE_URL, SUPABASE_ANON_KEY, '
        'MYPANIC_API_BASE_URL. See ApiOptions docs.',
      );
    }
  }
}
