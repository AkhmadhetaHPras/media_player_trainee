import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:media_player/config/themes/main_color.dart';

class LoadingVideoPlaceholder extends StatelessWidget {
  const LoadingVideoPlaceholder({
    super.key,
    required this.sourceType,
    required this.cover,
  });

  final String sourceType;
  final String cover;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: double.infinity,
          height: MediaQuery.sizeOf(context).width * (9 / 16),
          child: sourceType == "local"
              ? Image.asset(
                  cover,
                  fit: BoxFit.cover,
                )
              : CachedNetworkImage(
                  imageUrl: cover,
                  imageBuilder: (context, imageProvider) => Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
        ),
        const CircularProgressIndicator(
          color: MainColor.purple5A579C,
        ),
      ],
    );
  }
}
