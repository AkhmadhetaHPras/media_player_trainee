import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:media_player_trainee/config/routes/main_routes.dart';
import 'package:media_player_trainee/config/themes/main_color.dart';
import 'package:media_player_trainee/config/themes/main_text_style.dart';
import 'package:media_player_trainee/utils/extension_function.dart';
import 'package:media_player_trainee/utils/video_model.dart';

class CoverVideoCard extends StatelessWidget {
  const CoverVideoCard({
    super.key,
    required this.video,
  });

  final Video video;

  @override
  Widget build(BuildContext context) {
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
}
