import 'package:flutter/material.dart';
import 'package:media_player_trainee/config/themes/main_color.dart';

class TimeDisplay extends StatelessWidget {
  const TimeDisplay({
    super.key,
    required Duration position,
    required Duration duration,
  })  : _position = position,
        _duration = duration;

  final Duration _position;
  final Duration _duration;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          _position.toString().split(".")[0],
          style: const TextStyle(
            color: MainColor.whiteF2F0EB,
          ),
        ),
        Text(
          _duration.toString().split(".")[0],
          style: const TextStyle(
            color: MainColor.whiteF2F0EB,
          ),
        )
      ],
    );
  }
}
