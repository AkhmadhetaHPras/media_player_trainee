import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:media_player_trainee/config/routes/main_routes.dart';
import 'package:media_player_trainee/config/themes/main_color.dart';
import 'package:media_player_trainee/constants/assets_const.dart';
import 'package:intl/date_symbol_data_local.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final Duration _animatedDuration = const Duration(milliseconds: 300);
  final List<bool> _visibilityList = [false, false, false, false];

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('id_ID');
    _startAnimation(0);
  }

  _startAnimation(int index) {
    if (index < _visibilityList.length) {
      doAfter(_animatedDuration, () {
        setState(() {
          _visibilityList[index] = true;
        });

        if (index == _visibilityList.length - 1) {
          Future.delayed(_animatedDuration * 2, () {
            Navigator.pop(context);
            Navigator.pushNamed(context, MainRoute.home);
          });
        } else {
          _startAnimation(index + 1);
        }
      });
    }
  }

  void doAfter(Duration duration, Function() action) {
    Timer(duration, action);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            AnimatedOpacity(
                opacity: _visibilityList[0] ? 1 : 0,
                duration: _animatedDuration,
                child: _circleComponent(context,
                    scale: 3, color: MainColor.grey989794)),
            Align(
              alignment: Alignment.center,
              child: AnimatedOpacity(
                opacity: _visibilityList[1] ? 1 : 0,
                duration: _animatedDuration,
                child: _circleComponent(
                  context,
                  scale: 1.7,
                  color: MainColor.greyB6B5B1,
                ),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: AnimatedOpacity(
                opacity: _visibilityList[2] ? 1 : 0,
                duration: _animatedDuration,
                child: _circleComponent(
                  context,
                  scale: 1.3,
                  color: MainColor.greyD4D2CE,
                ),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: AnimatedOpacity(
                opacity: _visibilityList[3] ? 1 : 0,
                duration: _animatedDuration,
                child: _circleComponent(
                  context,
                  scale: 0.8,
                  color: MainColor.black222222,
                ),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: AnimatedOpacity(
                opacity: _visibilityList[3] ? 1 : 0,
                duration: _animatedDuration,
                child: _circleComponent(
                  context,
                  scale: 0.8,
                  child: SvgPicture.asset(
                    AssetsConsts.logo,
                    colorFilter: const ColorFilter.mode(
                      MainColor.purple5A579C,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  ClipRRect _circleComponent(
    BuildContext context, {
    required double scale,
    Color? color,
    Widget? child,
  }) {
    return ClipRRect(
      child: Transform.scale(
        scale: scale,
        child: child ??
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color,
              ),
            ),
      ),
    );
  }
}
