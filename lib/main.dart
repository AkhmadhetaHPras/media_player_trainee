import 'package:flutter/material.dart';
import 'package:media_player_trainee/config/pages/main_pages.dart';
import 'package:media_player_trainee/config/routes/main_routes.dart';
import 'package:media_player_trainee/config/themes/main_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Media Player Trainee',
      theme: mainTheme,
      home: const MyHomePage(),
      initialRoute: MainRoute.home,
      routes: mainPages,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
