import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:media_player_trainee/config/themes/main_color.dart';
import 'package:media_player_trainee/config/themes/main_text_style.dart';
import 'package:media_player_trainee/shared_components/dot_divider.dart';
import 'package:media_player_trainee/utils/extension_function.dart';
import 'package:media_player_trainee/utils/video_model.dart';

class VideoInformation extends StatefulWidget {
  const VideoInformation({
    super.key,
    required this.video,
  });

  final Video video;

  @override
  State<VideoInformation> createState() => _VideoInformationState();
}

class _VideoInformationState extends State<VideoInformation> {
  bool _isShowMore = true;

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

  switchShowMore() {
    setState(() {
      _isShowMore = !_isShowMore;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.video.title!,
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
                imageUrl: widget.video.creatorPhoto ?? '',
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
                widget.video.creator!,
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
              "${widget.video.viewsCount!.formatViewsCount()} x views",
              style: MainTextStyle.poppinsW500.copyWith(
                fontSize: 13,
                color: MainColor.whiteFFFFFF,
              ),
            ),
            const DotDivider(),
            Text(
              widget.video.releaseDate!.toLocalTime(),
              style: MainTextStyle.poppinsW500.copyWith(
                fontSize: 13,
                color: MainColor.whiteFFFFFF,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (_hasThreeLine(widget.video.description) && _isShowMore) ...[
          Text(
            widget.video.description!,
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
            widget.video.description!,
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
    );
  }
}
