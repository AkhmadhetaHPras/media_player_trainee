import 'package:flutter/material.dart';
import 'package:media_player_trainee/config/routes/main_routes.dart';
import 'package:media_player_trainee/main.dart';

Map<String, Widget Function(BuildContext)> mainPages = {
  MainRoute.home: (context) => const MyHomePage(),
};
