import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:media_player_trainee/config/themes/main_color.dart';
import 'package:media_player_trainee/config/themes/main_text_style.dart';
import 'package:media_player_trainee/shared_components/custom_app_bar.dart';
import 'package:media_player_trainee/utils/debouncer.dart';
import 'package:media_player_trainee/utils/extension_function.dart';
import 'package:media_player_trainee/utils/video_model.dart';
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
  bool _isShowMore = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    video = ModalRoute.of(context)!.settings.arguments as Video;
    video.sourceType == "local"
        ? _controller = VideoPlayerController.asset(video.source!)
        : _controller = VideoPlayerController.networkUrl(Uri.parse(
            "https://github.com/AkhmadhetaHPras/host-assets/raw/main/media-trainee/flutter_future_builder_widget_of_the_week.mp4"));
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

  switchShowMore() {
    setState(() {
      _isShowMore = !_isShowMore;
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
          /// video player
          FutureBuilder(
            future: _initializeVideoPlayerFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
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
                                  child: Container(
                                    padding: const EdgeInsets.only(top: 20),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.bottomCenter,
                                        end: Alignment.topCenter,
                                        colors: [
                                          MainColor.black000000,
                                          MainColor.black000000
                                              .withOpacity(0.5),
                                          MainColor.black000000
                                              .withOpacity(0.2),
                                          Colors.transparent,
                                        ],
                                      ),
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                _position
                                                    .toString()
                                                    .split(".")[0],
                                                style: const TextStyle(
                                                  color: MainColor.whiteF2F0EB,
                                                ),
                                              ),
                                              Text(
                                                _duration
                                                    .toString()
                                                    .split(".")[0],
                                                style: const TextStyle(
                                                  color: MainColor.whiteF2F0EB,
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        VideoProgressIndicator(
                                          _controller,
                                          allowScrubbing: false,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          AnimatedOpacity(
                            duration: animDuration,
                            opacity: _isVisible ? 1 : 0,
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
          const SizedBox(height: 4),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                vertical: 12,
                horizontal: 8,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    video.title!,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: MainTextStyle.poppinsW600.copyWith(
                      fontSize: 18,
                      color: MainColor.whiteF2F0EB,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      children: [
                        CachedNetworkImage(
                          imageUrl: video.creatorPhoto ?? '',
                          progressIndicatorBuilder: (context, url, progress) =>
                              const Center(
                            child: CircularProgressIndicator(
                              color: MainColor.purple5A579C,
                            ),
                          ),
                          imageBuilder: (context, imageProvider) => Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image: imageProvider,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          video.creator!,
                          maxLines: 1,
                          style: MainTextStyle.poppinsW500.copyWith(
                            fontSize: 14,
                            color: MainColor.whiteFFFFFF,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "${video.viewsCount!.formatViewsCount()} x views",
                        style: MainTextStyle.poppinsW500.copyWith(
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
                        video.releaseDate!.toLocalTime(),
                        style: MainTextStyle.poppinsW500.copyWith(
                          fontSize: 13,
                          color: MainColor.whiteFFFFFF,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  if (_hasThreeLine(video.description) && _isShowMore) ...[
                    Text(
                      video.description!,
                      maxLines: 3,
                      style: MainTextStyle.poppinsW400.copyWith(
                        fontSize: 12,
                        color: MainColor.whiteFFFFFF,
                      ),
                    ),
                    InkWell(
                      onTap: switchShowMore,
                      child: Text(
                        '...other',
                        style: MainTextStyle.poppinsW400.copyWith(
                          fontSize: 12,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ] else ...[
                    Text(
                      video.description!,
                      style: MainTextStyle.poppinsW400.copyWith(
                        fontSize: 12,
                        color: MainColor.whiteFFFFFF,
                      ),
                    ),
                    const SizedBox(height: 12),
                    InkWell(
                      onTap: switchShowMore,
                      child: Text(
                        'Less',
                        style: MainTextStyle.poppinsW400.copyWith(
                          fontSize: 12,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ]
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool _hasThreeLine(String? deskripsi) {
    final span = TextSpan(
      text: deskripsi,
      style: MainTextStyle.poppinsW400.copyWith(
        fontSize: 12,
      ),
    );
    final tp = TextPainter(
      text: span,
      maxLines: 3,
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: MediaQuery.of(context).size.width - 16);
    return tp.didExceedMaxLines;
  }
}
