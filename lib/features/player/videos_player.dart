import 'package:flutter/material.dart';
import 'package:media_player/config/themes/main_color.dart';
import 'package:media_player/data/video_model.dart';
import 'package:media_player/features/player/components/controll_button.dart';
import 'package:media_player/features/player/components/loading_video_placeholder.dart';
import 'package:media_player/features/player/components/video_information.dart';
import 'package:media_player/features/player/components/video_indicator.dart';
import 'package:media_player/shared_components/app_bar/back_button_app_bar_leading.dart';
import 'package:media_player/shared_components/app_bar/custom_app_bar.dart';
import 'package:media_player/utils/debouncer.dart';
import 'package:video_player/video_player.dart';

class VideosPlayer extends StatefulWidget {
  const VideosPlayer({super.key});

  @override
  State<VideosPlayer> createState() => VideosPlayerState();
}

@visibleForTesting
class VideosPlayerState extends State<VideosPlayer> {
  final Duration animDuration = const Duration(milliseconds: 300);
  late Video video;
  late VideoPlayerController controller;
  Duration duration = const Duration();
  Duration position = const Duration();
  late Future<void> initializeVideoPlayerFuture;
  bool isVisible = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    video = ModalRoute.of(context)!.settings.arguments as Video;

    initVideoController();
  }

  initVideoController() {
    video.sourceType == "local"
        ? controller = VideoPlayerController.asset(video.source!)
        : controller =
            VideoPlayerController.networkUrl(Uri.parse(video.source!));
    initializeVideoPlayerFuture = controller.initialize().then((value) {
      setState(() {
        duration = controller.value.duration;
      });
    });
    controller.setLooping(true);
    controller.setVolume(1.0);

    controller.addListener(
      () => setState(
        () => position = controller.value.position,
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  switchControllVisibility() {
    if (!isVisible) {
      onVisible();
      Debouncer(milliseconds: 2500).run(() {
        if (isVisible && controller.value.isPlaying == true) {
          offVisible();
        }
      });
    }
  }

  playPause() {
    if (isVisible) {
      if (controller.value.isPlaying) {
        controller.pause();
      } else {
        controller.play();
        offVisible();
      }
    }
  }

  offVisible() {
    setState(() {
      isVisible = false;
    });
  }

  onVisible() {
    setState(() {
      isVisible = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MainColor.black222222,
      appBar: const CustomAppBar(
        leading: BackButtonAppBarLeading(),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// video section
          FutureBuilder(
            future: initializeVideoPlayerFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                /// video player
                return Column(
                  children: [
                    GestureDetector(
                      onTap: switchControllVisibility,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          SizedBox(
                            width: double.infinity,
                            height: MediaQuery.sizeOf(context).width * 9 / 16,
                            child: Stack(
                              alignment: Alignment.bottomLeft,
                              children: [
                                VideoPlayer(controller),
                                AnimatedOpacity(
                                  duration: animDuration,
                                  opacity: isVisible ? 1 : 0,

                                  /// video progress indicator
                                  child: VideoIndicator(
                                    position: position,
                                    duration: duration,
                                    controller: controller,
                                    isVisible: isVisible,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          AnimatedOpacity(
                            duration: animDuration,
                            opacity: isVisible ? 1 : 0,
                            child: ControllButton(
                              icon: controller.value.isPlaying
                                  ? Icons.pause
                                  : Icons.play_arrow,
                              onPressed: playPause,
                              bgColor: MainColor.black000000.withOpacity(0.2),
                              splashR: 26,
                              icSize: 36,
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                );
              } else {
                /// placeholder on video load
                return LoadingVideoPlaceholder(
                  sourceType: video.sourceType!,
                  cover: video.coverPath!,
                );
              }
            },
          ),
          const SizedBox(height: 4),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                vertical: 12,
                horizontal: 8,
              ),

              /// video information
              child: VideoInformation(video: video),
            ),
          ),
        ],
      ),
    );
  }
}
