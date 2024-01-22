/// Kelas abstrak yang menyediakan konstanta string untuk berbagai aset dalam aplikasi, seperti gambar [SVG], [PNG], [JSON], dan lainnya.
/// Setiap konstanta string merujuk pada lokasi relatif dari aset tersebut di dalam struktur direktori aplikasi.
abstract class AssetsConsts {
  /// [svg]
  static const String logo = "assets/svgs/logo.svg";
  static const String logoName = "assets/svgs/logo_name.svg";

  /// [json]
  static const String musicJson = "assets/response/musics.json";
  static const String videoJson = "assets/response/videos.json";
}
