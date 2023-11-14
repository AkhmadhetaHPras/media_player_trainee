import 'package:flutter/material.dart';
import 'package:media_player_trainee/config/routes/main_routes.dart';
import 'package:media_player_trainee/features/pages/home.dart';
import 'package:media_player_trainee/features/pages/music_player.dart';
import 'package:media_player_trainee/features/pages/splash_screen.dart';
import 'package:media_player_trainee/features/pages/videos_player.dart';

Map<String, Widget Function(BuildContext)> mainPages = {
  MainRoute.splash: (context) => const SplashScreen(),
  MainRoute.home: (context) => const Home(),
  MainRoute.musicPlayer: (context) => const MusicPlayer(),
  MainRoute.videoPlayer: (context) => const VideosPlayer(),
};
