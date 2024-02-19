import 'package:flutter/material.dart';
import 'package:media_player/config/themes/main_color.dart';

/// Objek [ThemeData] yang mendefinisikan tema visual untuk aplikasi.
/// Tema ini mencakup berbagai properti seperti warna utama, skema warna, ikon, dan pengaturan lainnya yang memengaruhi tampilan dan perilaku visual dari widget-widget dalam aplikasi.
final ThemeData mainTheme = ThemeData(
  primaryColor: MainColor.purple5A579C,
  brightness: Brightness.light,
  colorScheme: ColorScheme.fromSwatch(
    accentColor: MainColor.purple5A579C,
    cardColor: MainColor.whiteFFFFFF,
    errorColor: MainColor.redDC3545,
  ),
  iconTheme: const IconThemeData(
    color: MainColor.purple5A579C,
    size: 24,
  ),
  textSelectionTheme: const TextSelectionThemeData(
    cursorColor: MainColor.black000000,
  ),
);
