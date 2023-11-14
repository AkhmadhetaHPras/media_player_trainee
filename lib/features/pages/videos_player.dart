import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:media_player_trainee/config/themes/main_color.dart';
import 'package:media_player_trainee/features/shared_components/custom_app_bar.dart';
import 'package:media_player_trainee/utils/video_model.dart';
import 'package:video_player/video_player.dart';

class VideosPlayer extends StatefulWidget {
  const VideosPlayer({super.key});

  @override
  State<VideosPlayer> createState() => _VideosPlayerState();
}

class _VideosPlayerState extends State<VideosPlayer> {
  late Video video;
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    video = ModalRoute.of(context)!.settings.arguments as Video;
    video.sourceType == "local"
        ? _controller = VideoPlayerController.asset(video.source!)
        : _controller = VideoPlayerController.networkUrl(Uri.parse(
            "https://github.com/AkhmadhetaHPras/host-assets/raw/main/media-trainee/flutter_future_builder_widget_of_the_week.mp4"));
    _initializeVideoPlayerFuture = _controller.initialize();
    _controller.setLooping(true);
    _controller.setVolume(1.0);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
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
          FutureBuilder(
            future: _initializeVideoPlayerFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return Column(
                  children: [
                    AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,
                      child: VideoPlayer(_controller),
                    ),
                    VideoProgressIndicator(
                      _controller,
                      allowScrubbing: false,
                    )
                  ],
                );
              } else {
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: double.infinity,
                      height: MediaQuery.sizeOf(context).width * (9 / 16),
                      decoration: BoxDecoration(
                        image: video.sourceType == "local"
                            ? DecorationImage(
                                image: AssetImage(
                                  video.coverPath!,
                                ),
                                fit: BoxFit.cover,
                              )
                            : null,
                      ),
                      child: video.sourceType != "local"
                          ? CachedNetworkImage(
                              imageUrl: video.coverPath!,
                              progressIndicatorBuilder:
                                  (context, url, progress) => const Center(
                                child: CircularProgressIndicator(
                                  color: MainColor.purple5A579C,
                                ),
                              ),
                              imageBuilder: (context, imageProvider) =>
                                  Container(
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: imageProvider,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            )
                          : null,
                    ),
                    const CircularProgressIndicator(),
                  ],
                );
              }
            },
          ),
          const SizedBox(
            height: 16,
          ),
          IconButton(
            onPressed: () {
              setState(() {
                if (_controller.value.isPlaying) {
                  _controller.pause();
                } else {
                  _controller.play();
                }
              });
            },
            icon: Icon(
              _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
            ),
          )
        ],
      ),
    );
  }
}
