import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:media_player_trainee/config/routes/main_routes.dart';
import 'package:media_player_trainee/config/themes/main_color.dart';
import 'package:media_player_trainee/config/themes/main_text_style.dart';
import 'package:media_player_trainee/features/shared_components/custom_app_bar.dart';
import 'package:media_player_trainee/utils/extension_function.dart';
import 'package:media_player_trainee/utils/music_model.dart';
import 'package:media_player_trainee/utils/repository.dart';
import 'package:media_player_trainee/utils/video_model.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => HomeState();
}

class HomeState extends State<Home> {
  List<Music> musics = [];
  List<Video> videos = [];

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async {
    await Repository.getMusics();
    await Repository.getVideos();
    setState(() {
      musics = Repository.musics;
      videos = Repository.videos;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MainColor.black222222,
      appBar: const CustomAppBar(),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _titleSection(title: "Music Collections"),
              SizedBox(
                height: 200,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: musics.length,
                  itemBuilder: (_, i) {
                    final item = musics[i];
                    return Padding(
                      padding: EdgeInsets.only(
                        left: i == 0 ? 15 : 0,
                        right: i == musics.length - 1 ? 15 : 0,
                      ),
                      child: _coverMusicCard(music: item),
                    );
                  },
                  separatorBuilder: (_, i) => const SizedBox(
                    width: 20,
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              _titleSection(title: "Videos"),
              ListView.separated(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: videos.length,
                itemBuilder: (_, i) => Padding(
                  padding: EdgeInsets.only(bottom: i == 4 ? 16 : 0),
                  child: _coverVideoCard(context, video: videos[i]),
                ),
                separatorBuilder: (context, index) => const SizedBox(
                  height: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _coverVideoCard(
    BuildContext context, {
    required Video video,
  }) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(
        context,
        MainRoute.videoPlayer,
        arguments: video,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
              width: double.infinity,
              height: MediaQuery.sizeOf(context).width * 9 / 16,
              child: video.sourceType == "local"
                  ? Image.asset(
                      video.coverPath!,
                    )
                  : CachedNetworkImage(
                      imageUrl: video.coverPath!,
                      progressIndicatorBuilder: (context, url, progress) =>
                          const Center(
                        child: CircularProgressIndicator(
                          color: MainColor.purple5A579C,
                        ),
                      ),
                      imageBuilder: (context, imageProvider) => Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    )),
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 8,
              horizontal: 24,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  video.title!,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: MainTextStyle.poppinsW700.copyWith(
                    fontSize: 15,
                    color: MainColor.whiteF2F0EB,
                  ),
                ),
                const SizedBox(
                  height: 4,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      video.creator!,
                      overflow: TextOverflow.ellipsis,
                      style: MainTextStyle.poppinsW400.copyWith(
                        fontSize: 12,
                        color: MainColor.whiteF2F0EB,
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
                      "${video.viewsCount!.formatViewsCount()} x views",
                      overflow: TextOverflow.ellipsis,
                      style: MainTextStyle.poppinsW400.copyWith(
                        fontSize: 12,
                        color: MainColor.whiteF2F0EB,
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
                      overflow: TextOverflow.ellipsis,
                      style: MainTextStyle.poppinsW400.copyWith(
                        fontSize: 12,
                        color: MainColor.whiteF2F0EB,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Padding _titleSection({
    required String title,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Text(
        title,
        style: MainTextStyle.poppinsW600.copyWith(
          fontSize: 20,
          color: MainColor.whiteF2F0EB,
        ),
      ),
    );
  }

  Widget _coverMusicCard({
    required Music music,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          MainRoute.musicPlayer,
          arguments: music,
        );
      },
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            width: 190,
            height: 200,
            decoration: ShapeDecoration(
              image: music.sourceType == "local"
                  ? DecorationImage(
                      image: AssetImage(
                        music.coverPath!,
                      ),
                      fit: BoxFit.cover,
                    )
                  : null,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(36),
              ),
            ),
            child: music.sourceType != "local"
                ? CachedNetworkImage(
                    imageUrl: music.coverPath!,
                    progressIndicatorBuilder: (context, url, progress) =>
                        const Center(
                      child: CircularProgressIndicator(
                        color: MainColor.purple5A579C,
                      ),
                    ),
                    imageBuilder: (context, imageProvider) => Container(
                      decoration: ShapeDecoration(
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.cover,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(36),
                        ),
                      ),
                    ),
                  )
                : null,
          ),
          Positioned(
            bottom: -1,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(36),
                bottomRight: Radius.circular(36),
              ),
              child: ClipRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                  child: Container(
                    alignment: Alignment.centerLeft,
                    width: 190,
                    height: 60,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment(0.00, -1.00),
                        end: Alignment(0, 1),
                        colors: [
                          Color(0x7F120911),
                          Color(0xFF0D0D0D),
                        ],
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24.0,
                        vertical: 8,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            music.title!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: MainTextStyle.poppinsW600.copyWith(
                              fontSize: 14,
                              color: MainColor.whiteF2F0EB,
                            ),
                          ),
                          const SizedBox(
                            height: 3,
                          ),
                          Text(
                            music.artist!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: MainTextStyle.poppinsW400.copyWith(
                              fontSize: 12,
                              letterSpacing: 0.4,
                              color: MainColor.whiteF2F0EB,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
