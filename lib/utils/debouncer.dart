import 'dart:async';

import 'package:flutter/material.dart';

/// Kelas untuk menangani kasus debouncing dalam pengembangan aplikasi Flutter.
/// Debouncing digunakan untuk menunda atau menunda eksekusi suatu tindakan hingga waktu tertentu setelah tindakan tersebut terakhir kali dipicu.
/// Dalam konteks ini, Debouncer dapat digunakan untuk menunda eksekusi suatu tindakan (callback) hingga waktu tertentu setelah tindakan tersebut terakhir kali dipicu.
class Debouncer {
  final int milliseconds;
  VoidCallback? action;
  Timer? _timer;

  Debouncer({required this.milliseconds});

  run(VoidCallback action) {
    if (_timer != null) {
      _timer?.cancel();
    }
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}
