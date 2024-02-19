import 'package:flutter/material.dart';
import 'package:media_player/config/routes/main_routes.dart';
import 'package:media_player/features/home/home.dart';
import 'package:media_player/features/player/music_player.dart';
import 'package:media_player/features/player/videos_player.dart';
import 'package:media_player/features/splash/splash_screen.dart';

/// Sebuah Map yang mengaitkan setiap rute yang didefinisikan dalam kelas [MainRoute] dengan fungsi pembuat widget (widget builder).
/// Setiap rute dihubungkan dengan widget yang sesuai untuk tampilan yang terkait dengan rute tersebut.
Map<String, Widget Function(BuildContext)> mainPages = {
  MainRoute.splash: (context) => const SplashScreen(),
  MainRoute.home: (context) => const Home(),
  MainRoute.musicPlayer: (context) => const MusicPlayer(),
  MainRoute.videoPlayer: (context) => const VideosPlayer(),
};
