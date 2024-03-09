import 'package:flutter/material.dart';
import 'package:media_player/config/themes/main_color.dart';
import 'package:media_player/data/video_model.dart';
import 'package:media_player/features/player/components/loading_video_placeholder.dart';
import 'package:media_player/features/player/components/video_information.dart';
import 'package:media_player/features/player/components/video_indicator.dart';
import 'package:media_player/shared_components/custom_app_bar.dart';
import 'package:media_player/utils/debouncer.dart';
import 'package:video_player/video_player.dart';

class VideosPlayer extends StatefulWidget {
  const VideosPlayer({super.key});

  @override
  State<VideosPlayer> createState() => _VideosPlayerState();
}

class _VideosPlayerState extends State<VideosPlayer> {
  final Duration animDuration = const Duration(milliseconds: 300);
  late Video video;
  late VideoPlayerController _controller;
  Duration _duration = const Duration();
  Duration _position = const Duration();
  late Future<void> _initializeVideoPlayerFuture;
  bool _isVisible = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    video = ModalRoute.of(context)!.settings.arguments as Video;
    video.sourceType == "local"
        ? _controller = VideoPlayerController.asset(video.source!)
        : _controller =
            VideoPlayerController.networkUrl(Uri.parse(video.source!));
    _initializeVideoPlayerFuture = _controller.initialize().then((value) {
      setState(() {
        _duration = _controller.value.duration;
      });
    });
    _controller.setLooping(true);
    _controller.setVolume(1.0);

    _controller.addListener(
      () => setState(
        () => _position = _controller.value.position,
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  offVisible() {
    setState(() {
      _isVisible = false;
    });
  }

  onVisible() {
    setState(() {
      _isVisible = true;
    });
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// video section
          FutureBuilder(
            future: _initializeVideoPlayerFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                /// video player
                return Column(
                  children: [
                    GestureDetector(
                      onTap: () async {
                        if (!_isVisible) {
                          onVisible();
                          Debouncer(milliseconds: 2000).run(() {
                            if (_isVisible &&
                                _controller.value.isPlaying == true) {
                              offVisible();
                            }
                          });
                        }
                      },
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          AspectRatio(
                            aspectRatio: _controller.value.aspectRatio,
                            child: Stack(
                              alignment: Alignment.bottomLeft,
                              children: [
                                VideoPlayer(_controller),
                                AnimatedOpacity(
                                  duration: animDuration,
                                  opacity: _isVisible ? 1 : 0,

                                  /// video progress indicator
                                  child: VideoIndicator(
                                    position: _position,
                                    duration: _duration,
                                    controller: _controller,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          AnimatedOpacity(
                            duration: animDuration,
                            opacity: _isVisible ? 1 : 0,

                            /// video button control
                            child: Material(
                              color: MainColor.black000000.withOpacity(0.2),
                              shape: const OvalBorder(),
                              child: IconButton(
                                iconSize: 36,
                                splashRadius: 26,
                                onPressed: () {
                                  setState(() {
                                    if (_isVisible) {
                                      if (_controller.value.isPlaying) {
                                        _controller.pause();
                                      } else {
                                        _controller.play();
                                        offVisible();
                                      }
                                    }
                                  });
                                },
                                icon: Icon(
                                  _controller.value.isPlaying
                                      ? Icons.pause
                                      : Icons.play_arrow,
                                ),
                              ),
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
