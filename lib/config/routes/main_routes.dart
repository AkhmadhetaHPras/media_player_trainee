/// Kelas abstrak yang menyediakan konstanta string untuk berbagai rute (routes) dalam aplikasi.
/// Rute-rute ini dapat digunakan sebagai identifikasi unik untuk navigasi antar layar atau tampilan dalam aplikasi.
///
/// Contoh Penggunaan
/// ```dart
/// Navigator.pushNamed(context, MainRoute.splash);
/// ```
abstract class MainRoute {
  static const String splash = '/';
  static const String home = '/home';
  static const String musicPlayer = '/music-player';
  static const String videoPlayer = '/video-player';
}
