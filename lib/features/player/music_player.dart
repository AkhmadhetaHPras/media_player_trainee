import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:media_player_trainee/config/themes/main_color.dart';
import 'package:media_player_trainee/config/themes/main_text_style.dart';
import 'package:media_player_trainee/data/music_model.dart';
import 'package:media_player_trainee/features/player/components/music_cover_image.dart';
import 'package:media_player_trainee/features/player/components/time_display.dart';
import 'package:media_player_trainee/shared_components/custom_app_bar.dart';

class MusicPlayer extends StatefulWidget {
  const MusicPlayer({super.key});

  @override
  State<MusicPlayer> createState() => _MusicPlayerState();
}

class _MusicPlayerState extends State<MusicPlayer> {
  AudioPlayer newPlayer = AudioPlayer();

  bool play = false;
  Duration _duration = const Duration();
  Duration _position = const Duration();

  @override
  void initState() {
    super.initState();
    initPlayer();
  }

  @override
  void dispose() {
    super.dispose();
    newPlayer.stop();
  }

  late Music music;
  late Source source;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    music = ModalRoute.of(context)!.settings.arguments as Music;
    setState(() {
      source = music.sourceType == "local"
          ? AssetSource(
              music.source!.replaceFirst("assets/", ""),
            )
          : UrlSource(music.source!);
    });
    newPlayer.setSource(source).then((value) {
      setState(() async {
        _duration = await newPlayer.getDuration() ?? const Duration();
      });
    });
  }

  void initPlayer() async {
    newPlayer.onDurationChanged.listen((dur) {
      setState(() {
        _duration = dur;
      });
    });
    newPlayer.onPositionChanged.listen((pos) {
      setState(() {
        _position = pos;
      });
    });
  }

  playAudio() {
    newPlayer.setVolume(1.0);
    newPlayer.play(
      music.sourceType == "local"
          ? AssetSource(
              music.source!.replaceFirst("assets/", ""),
            )
          : UrlSource(music.source!),
      mode: PlayerMode.mediaPlayer,
    );
    setState(() {
      play = true;
    });
  }

  pauseAudio() {
    newPlayer.pause();
    setState(() {
      play = false;
    });
  }

  playPause() {
    if (play == false) {
      playAudio();
    } else {
      pauseAudio();
    }
  }

  void seekToSecond(int second) {
    Duration newDuration = Duration(seconds: second);

    newPlayer.seek(newDuration);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MainColor.black222222,
      appBar: CustomAppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_sharp,
            size: 18,
            color: MainColor.whiteFFFFFF,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
          splashRadius: 18,
        ),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 18,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 15,
              horizontal: 18,
            ),

            /// music cover image
            child: MusicCoverImage(
              sourceType: music.sourceType!,
              cover: music.coverPath!,
            ),
          ),

          /// music information
          Text(
            music.title!,
            style: MainTextStyle.poppinsW600.copyWith(
              fontSize: 18,
              color: MainColor.whiteF2F0EB,
            ),
          ),
          Text(
            music.artist!,
            style: MainTextStyle.poppinsW400.copyWith(
              fontSize: 12,
              color: MainColor.whiteF2F0EB,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                music.albumName!,
                style: MainTextStyle.poppinsW400.copyWith(
                  fontSize: 13,
                  color: MainColor.whiteFFFFFF,
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 6),
                child: Icon(
                  Icons.circle,
                  size: 6,
                  color: MainColor.whiteF2F0EB,
                ),
              ),
              Text(
                music.releaseYear!,
                style: MainTextStyle.poppinsW400.copyWith(
                  fontSize: 13,
                  color: MainColor.whiteFFFFFF,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),

          /// music indicator
          Slider(
            value: _position.inSeconds.toDouble(),
            min: 0.0,
            max: _duration.inSeconds.toDouble(),
            thumbColor: MainColor.purple5A579C,
            activeColor: MainColor.purple5A579C,
            onChanged: (double value) {
              setState(() {
                seekToSecond(value.toInt());
                value = value;
              });
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 18,
            ),
            child: TimeDisplay(
              position: _position,
              duration: _duration,
            ),
          ),

          /// controll button
          Material(
            color: MainColor.whiteF2F0EB,
            shape: const OvalBorder(),
            child: IconButton(
              splashRadius: 25,
              iconSize: 32,
              icon: Icon(
                play ? Icons.pause : Icons.play_arrow,
                color: MainColor.purple5A579C,
              ),
              onPressed: playPause,
            ),
          ),
        ],
      ),
    );
  }
}
