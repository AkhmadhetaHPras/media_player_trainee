import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:media_player_trainee/config/routes/main_routes.dart';
import 'package:media_player_trainee/config/themes/main_color.dart';
import 'package:media_player_trainee/config/themes/main_text_style.dart';
import 'package:media_player_trainee/utils/music_model.dart';

class CoverMusicCard extends StatelessWidget {
  const CoverMusicCard({
    super.key,
    required this.music,
  });

  final Music music;
  @override
  Widget build(BuildContext context) {
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
                          MainColor.black120911,
                          MainColor.black0D0D0D,
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
