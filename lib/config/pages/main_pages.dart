import 'package:flutter/material.dart';
import 'package:media_player_trainee/config/routes/main_routes.dart';
import 'package:media_player_trainee/features/home/home.dart';
import 'package:media_player_trainee/features/player/music_player.dart';
import 'package:media_player_trainee/features/player/videos_player.dart';
import 'package:media_player_trainee/features/splash/splash_screen.dart';

Map<String, Widget Function(BuildContext)> mainPages = {
  MainRoute.splash: (context) => const SplashScreen(),
  MainRoute.home: (context) => const Home(),
  MainRoute.musicPlayer: (context) => const MusicPlayer(),
  MainRoute.videoPlayer: (context) => const VideosPlayer(),
};
