import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:media_player_trainee/config/themes/main_color.dart';
import 'package:media_player_trainee/config/themes/main_text_style.dart';
import 'package:media_player_trainee/features/shared_components/custom_app_bar.dart';
import 'package:media_player_trainee/utils/music_model.dart';

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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    music = ModalRoute.of(context)!.settings.arguments as Music;
    setState(() {
      _duration = Duration(seconds: music.duration!);
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
            child: Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  image: music.sourceType == "local"
                      ? DecorationImage(
                          image: AssetImage(
                            music.coverPath!,
                          ),
                          fit: BoxFit.cover,
                        )
                      : null),
              child: music.sourceType != "local"
                  ? CachedNetworkImage(
                      imageUrl: music.coverPath!,
                      progressIndicatorBuilder: (context, url, progress) =>
                          Center(
                        child: CircularProgressIndicator(
                          color: MainColor.purple5A579C,
                          value: progress.progress,
                        ),
                      ),
                      imageBuilder: (context, imageProvider) => Container(
                        width: double.infinity,
                        height: 200,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    )
                  : null,
            ),
          ),
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
          const SizedBox(
            height: 12,
          ),
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
              }),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 18,
            ),
            child: Row(
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
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                splashRadius: 25,
                icon: Icon(
                  play ? Icons.pause : Icons.play_arrow,
                  color: Colors.white,
                ),
                onPressed: playPause,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
