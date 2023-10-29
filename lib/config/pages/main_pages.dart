import 'package:flutter/material.dart';
import 'package:media_player_trainee/config/routes/main_routes.dart';
import 'package:media_player_trainee/features/pages/home.dart';
import 'package:media_player_trainee/features/pages/splash_screen.dart';

Map<String, Widget Function(BuildContext)> mainPages = {
  MainRoute.splash: (context) => const SplashScreen(),
  MainRoute.home: (context) => const Home(),
};
