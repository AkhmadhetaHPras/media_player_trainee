import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Kelas abstrak yang menyediakan gaya teks (text styles) menggunakan jenis font tertentu dengan berbagai ketebalan (font weight) yang mungkin digunakan dalam tata letak dan tampilan aplikasi.
/// Setiap anggota kelas adalah objek TextStyle yang dapat langsung digunakan dalam pembuatan teks pada widget Flutter.
abstract class MainTextStyle {
  static final poppinsW300 = GoogleFonts.poppins(fontWeight: FontWeight.w300);
  static final poppinsW400 = GoogleFonts.poppins(fontWeight: FontWeight.w400);
  static final poppinsW500 = GoogleFonts.poppins(fontWeight: FontWeight.w500);
  static final poppinsW600 = GoogleFonts.poppins(fontWeight: FontWeight.w600);
  static final poppinsW700 = GoogleFonts.poppins(fontWeight: FontWeight.w700);
  static final poppinsW800 = GoogleFonts.poppins(fontWeight: FontWeight.w800);
}
