import 'package:intl/intl.dart';

extension DateTimeX on DateTime {
  /// Konversi tanggal [DateTime] ke format string yang mencakup tanggal, bulan, dan tahun dalam format [dd MMMM yyyy].
  ///
  /// Contoh:
  /// ```dart
  /// DateFormat("yyyy-MM-dd").parse("2023-07-12").toFormatGeneralData();
  /// ```
  /// Output: 12 Juli 2023
  String toFormatGeneralData() {
    DateFormat dateFormat = DateFormat('dd MMMM yyyy');

    return dateFormat.format(this);
  }
}

extension IntX on int {
  /// Konversi angka [int] ke format string yang disesuaikan untuk nilai yang besar, dengan menggunakan
  /// notasi 'k' untuk ribuan dan 'm' untuk juta.
  ///
  /// Contoh:
  /// ```dart
  /// 1200..formatViewsCount();
  /// ```
  /// Output: 1.2 k
  String formatViewsCount() {
    if (this < 1000) {
      return toString();
    } else if (this < 1000000) {
      double kViews = this / 1000;
      return '${kViews.toStringAsFixed(kViews.truncateToDouble() == kViews ? 0 : 1)} k';
    } else {
      double mViews = this / 1000000;
      return '${mViews.toStringAsFixed(mViews.truncateToDouble() == mViews ? 0 : 1)} m';
    }
  }
}

extension StringTimeX on String {
  /// Memperluas fungsionalitas objek [String] yang menyimpan tanggal dalam format ["yyyy-MM-dd"].
  /// Fungsi ini mengonversi tanggal tersebut menjadi format string yang mencakup informasi waktu relatif terhadap waktu lokal saat ini, seperti "Today", "One week ago", atau "5 days ago".
  ///
  /// Contoh:
  /// ```dart
  ///  DateFormat("yyyy-MM-dd").format(DateTime.now()).toLocalTime();
  /// ```
  /// Output: Today
  String toLocalTime() {
    DateTime tempDate = DateFormat("yyyy-MM-dd").parse(this);
    final now = DateTime.now();
    Duration diff = now.difference(tempDate);

    if (diff.inDays > 7) {
      return tempDate.toFormatGeneralData();
    } else if (diff.inDays == 7) {
      return 'One week ago';
    } else if (diff.inDays >= 1 && diff.inDays <= 6) {
      return '${diff.inDays} days ago';
    } else {
      return 'Today';
    }
  }
}
