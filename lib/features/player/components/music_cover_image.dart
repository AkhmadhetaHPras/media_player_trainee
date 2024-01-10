import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:media_player_trainee/config/themes/main_color.dart';

class MusicCoverImage extends StatelessWidget {
  const MusicCoverImage({
    super.key,
    required this.sourceType,
    required this.cover,
  });

  final String sourceType;
  final String cover;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          image: sourceType == "local"
              ? DecorationImage(
                  image: AssetImage(
                    cover,
                  ),
                  fit: BoxFit.cover,
                )
              : null),
      child: sourceType != "local"
          ? CachedNetworkImage(
              imageUrl: cover,
              progressIndicatorBuilder: (context, url, progress) => Center(
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
    );
  }
}
