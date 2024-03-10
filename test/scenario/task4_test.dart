import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:media_player/config/themes/main_color.dart';
import 'package:media_player/config/themes/main_text_style.dart';
import 'package:media_player/data/video_model.dart';
import 'package:media_player/features/player/components/loading_video_placeholder.dart';
import 'package:media_player/features/player/components/time_display.dart';
import 'package:media_player/features/player/components/video_indicator.dart';
import 'package:media_player/features/player/components/video_information.dart';
import 'package:media_player/shared_components/dot_divider.dart';
import 'package:media_player/utils/extension_function.dart';
import 'package:video_player/video_player.dart';

void main() {
  Video localSourceVideo = Video(
    title: "Aquaman And The Lost Kingdom | Trailer",
    creator: "DC",
    creatorPhoto:
        "https://upload.wikimedia.org/wikipedia/commons/7/7d/DC_Comics_Logo.jpg",
    description:
        "Director James Wan and Aquaman himself, Jason Momoa—along with Patrick Wilson, Amber Heard, Yahya Abdul-Mateen II and Nicole Kidman—return in the sequel to the highest-grossing DC film of all time: “Aquaman and the Lost Kingdom.”\nHaving failed to defeat Aquaman the first time, Black Manta, still driven by the need to avenge his father's death, will stop at nothing to take Aquaman down once and for all. This time Black Manta is more formidable than ever before, wielding the power of the mythic Black Trident, which unleashes an ancient and malevolent force. To defeat him, Aquaman will turn to his imprisoned brother Orm, the former King of Atlantis, to forge an unlikely alliance. Together, they must set aside their differences in order to protect their kingdom and save Aquaman's family, and the world, from irreversible destruction.",
    releaseDate: "2023-09-14",
    sourceType: "local",
    source: "assets/videos/aquaman_and_the_lost_kingdom_trailer.mp4",
    coverPath: "assets/imgs/cover_aquaman_and_the_lost_kingdom_trailer.jpeg",
    viewsCount: 1082000,
  );

  void checkWhenCanShowMore(
    WidgetTester tester,
    Finder inkWellFinder,
    Finder columnFinder,
    bool afterLess,
  ) {
    final reasonClue = afterLess
        ? 'Hitting Less Button does not restore the widget or state:'
        : '';
    expect(
      inkWellFinder,
      findsOneWidget,
      reason:
          '$reasonClue InkWell widget not found within Column in VideoInformation Widget',
    );
    final inkWell = tester.widget<InkWell>(inkWellFinder);
    expect(
      (inkWell.child as Text).data,
      '...other',
      reason:
          "$reasonClue InkWell child not a Text widget with '...other' text data",
    );

    final descriptionFinder = find.descendant(
      of: columnFinder,
      matching: find.byWidgetPredicate(
        (widget) =>
            widget is Text && widget.data == localSourceVideo.description,
      ),
    );
    expect(
      descriptionFinder,
      findsOneWidget,
      reason:
          "$reasonClue Text widget that containing video description not found within Column in VideoInformation Widget",
    );
    final description = tester.widget<Text>(descriptionFinder);
    expect(
      description.maxLines,
      3,
      reason:
          "$reasonClue maxLines property of Text widget that containing video description is not 3",
    );
  }

  void checkWhenCanLess(
    WidgetTester tester,
    Finder inkWellFinder,
    Finder columnFinder,
  ) {
    final inkWell = tester.widget<InkWell>(inkWellFinder);
    expect((inkWell.child as Text).data, 'Less');

    final descriptionFinder = find.descendant(
      of: columnFinder,
      matching: find.byWidgetPredicate(
        (widget) =>
            widget is Text && widget.data == localSourceVideo.description,
      ),
    );
    expect(descriptionFinder, findsOneWidget);
    final description = tester.widget<Text>(descriptionFinder);
    expect(description.maxLines, null);
  }

  testWidgets('Structur of LoadingVideoPlaceholder widget is built correctly',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(size: Size(480, 800)),
        child: MaterialApp(
          home: Scaffold(
            body: LoadingVideoPlaceholder(
              sourceType: localSourceVideo.sourceType!,
              cover: localSourceVideo.coverPath!,
            ),
          ),
        ),
      ),
    );

    final loadingVideoPlaceholder = find.byType(LoadingVideoPlaceholder);
    expect(loadingVideoPlaceholder, findsOneWidget);

    final stackFinder = find.byType(Stack).first;
    final stackWidget = tester.widget<Stack>(stackFinder);

    expect(stackFinder, findsOneWidget);
    expect(stackWidget.alignment, Alignment.center);

    final videoWrapperFinder = find.descendant(
      of: stackFinder,
      matching: find.byWidgetPredicate((widget) =>
          widget is SizedBox &&
          widget.width == double.infinity &&
          widget.height == 270),
    );

    expect(videoWrapperFinder, findsOneWidget);
    expect(stackWidget.children.last, isA<CircularProgressIndicator>());
    expect(
      (stackWidget.children.last as CircularProgressIndicator).color,
      MainColor.purple5A579C,
    );
  });

  testWidgets('LoadingVideoPlaceholder render local source',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(size: Size(480, 800)),
        child: MaterialApp(
          home: Scaffold(
            body: LoadingVideoPlaceholder(
              sourceType: localSourceVideo.sourceType!,
              cover: localSourceVideo.coverPath!,
            ),
          ),
        ),
      ),
    );

    final stackFinder = find.byType(Stack).first;
    final videoWrapperFinder = find.descendant(
      of: stackFinder,
      matching: find.byWidgetPredicate((widget) =>
          widget is SizedBox &&
          widget.width == double.infinity &&
          widget.height == 270 &&
          widget.child is Image),
    );

    expect(videoWrapperFinder, findsOneWidget);
    final image =
        (tester.widget<SizedBox>(videoWrapperFinder).child as Image).image;
    if (image is AssetImage) {
      expect(image.assetName, localSourceVideo.coverPath!);
    } else if (image is ExactAssetImage) {
      expect(image.assetName, localSourceVideo.coverPath!);
    } else {
      fail('Unexpected asset image widget found | use Image.asset instead');
    }
  });

  testWidgets('LoadingVideoPlaceholder render network source',
      (WidgetTester tester) async {
    final networkSourceVideo = Video(
      title: "FutureBuilder (Widget of the Week)",
      creator: "Flutter",
      creatorPhoto:
          "https://logowik.com/content/uploads/images/flutter5786.jpg",
      description:
          "Have a Future and need some widgets to display its values? Try FutureBuilder! Add a Future and a build method, and you'll create widgets based on the Future state and update them as it changes.",
      releaseDate: "2018-01-23",
      sourceType: "network",
      source:
          "https://github.com/AkhmadhetaHPras/host-assets/raw/main/media-player/flutter_future_builder_widget_of_the_week.mp4",
      coverPath:
          "https://github.com/AkhmadhetaHPras/host-assets/blob/main/media-player/cover_flutter_future_builder_widget_of_the_week.jpeg?raw=true",
      viewsCount: 80912801,
    );

    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(size: Size(480, 800)),
        child: MaterialApp(
          home: Scaffold(
            body: LoadingVideoPlaceholder(
              sourceType: networkSourceVideo.sourceType!,
              cover: networkSourceVideo.coverPath!,
            ),
          ),
        ),
      ),
    );

    final stackFinder = find.byType(Stack).first;
    final videoWrapperFinder = find.descendant(
      of: stackFinder,
      matching: find.byWidgetPredicate((widget) =>
          widget is SizedBox &&
          widget.width == double.infinity &&
          widget.height == 270 &&
          widget.child is ClipRRect),
    );

    expect(videoWrapperFinder, findsOneWidget);

    final clipRRect =
        tester.widget<SizedBox>(videoWrapperFinder).child as ClipRRect;

    expect(clipRRect.child, isA<CachedNetworkImage>());

    final networkImage = clipRRect.child as CachedNetworkImage;
    expect(networkImage.imageUrl, networkSourceVideo.coverPath);

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(networkImage.fit, BoxFit.cover);
  });

  testWidgets('Structur of VideoIndicator widget is built correctly',
      (WidgetTester tester) async {
    Duration position = const Duration();
    Duration duration = const Duration(seconds: 197);
    VideoPlayerController controller = VideoPlayerController.asset(
      'assets/videos/aquaman_and_the_lost_kingdom_trailer.mp4',
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: VideoIndicator(
            position: position,
            duration: duration,
            controller: controller,
          ),
        ),
      ),
    );

    final containerFinder = find.byType(Container).first;
    expect(containerFinder, findsOneWidget);
    final container = tester.widget<Container>(containerFinder);

    expect((container.padding as EdgeInsets).top, 20.0);
    expect(container.decoration, isA<BoxDecoration>());
    expect((container.decoration as BoxDecoration).gradient,
        isA<LinearGradient>());
    expect(container.child, isA<Column>());

    final linearGradient =
        (container.decoration as BoxDecoration).gradient as LinearGradient;
    expect(linearGradient.begin, Alignment.bottomCenter);
    expect(linearGradient.end, Alignment.topCenter);

    final colors = [
      MainColor.black000000,
      MainColor.black000000.withOpacity(0.5),
      MainColor.black000000.withOpacity(0.2),
      Colors.transparent,
    ];
    expect(linearGradient.colors, colors);

    final columnFinder = find.byType(Column);
    expect(columnFinder, findsOneWidget);
    final column = container.child as Column;
    expect(column.mainAxisSize, MainAxisSize.min);

    final timeDisplayFinder = find.descendant(
      of: columnFinder,
      matching: find.byWidgetPredicate((widget) =>
          widget is Padding &&
          (widget.padding as EdgeInsets).horizontal == 16 &&
          widget.child is TimeDisplay),
    );
    expect(timeDisplayFinder, findsOneWidget);
    expect(find.byType(TimeDisplay), findsOneWidget,
        reason: 'VideosPlayer must have a TimeDisplay component');
    expect(
      find.text(position.toString().split(".")[0]),
      findsOneWidget,
      reason: 'VideosPlayer display video position',
    );
    expect(find.text(duration.toString().split(".")[0]), findsOneWidget,
        reason: 'VideosPlayer display video duration');

    final videoProgressFinder = find.descendant(
      of: columnFinder,
      matching: find.byType(VideoProgressIndicator),
    );
    expect(videoProgressFinder, findsOneWidget);
  });

  testWidgets('Structur of VideoInformation widget is built correctly',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(size: Size(480, 800)),
        child: MaterialApp(
          home: Scaffold(
            body: VideoInformation(
              video: localSourceVideo,
            ),
          ),
        ),
      ),
    );

    final columnFinder = find.byType(Column);
    expect(columnFinder, findsOneWidget);
    final column = tester.widget<Column>(columnFinder);
    expect(column.crossAxisAlignment, CrossAxisAlignment.start);

    final titleFinder = find.byWidgetPredicate(
        (widget) => widget is Text && widget.data == localSourceVideo.title);
    expect(titleFinder, findsOneWidget);
    final title = tester.widget<Text>(titleFinder);
    expect(title.maxLines, 3);
    expect(title.overflow, TextOverflow.ellipsis);
    expect(
      title.style,
      MainTextStyle.poppinsW600.copyWith(
        fontSize: 18,
        color: MainColor.whiteF2F0EB,
      ),
    );

    final paddingChannelWrapperFinder = find.descendant(
      of: columnFinder,
      matching: find.byWidgetPredicate(
        (widget) =>
            widget is Padding &&
            (widget.padding as EdgeInsets).vertical == 16 &&
            widget.child is Row,
      ),
    );
    expect(paddingChannelWrapperFinder, findsOneWidget);
    final rowChannelWrapperFinder = find.descendant(
      of: paddingChannelWrapperFinder,
      matching: find.byType(Row),
    );
    expect(rowChannelWrapperFinder, findsOneWidget);

    final sizedboxWrapperChannelImageFinder = find.descendant(
      of: rowChannelWrapperFinder,
      matching: find.byWidgetPredicate(
        (widget) =>
            widget is SizedBox &&
            widget.height == 36 &&
            widget.width == 36 &&
            widget.child is ClipRRect,
      ),
    );
    expect(sizedboxWrapperChannelImageFinder, findsOneWidget);

    final channelImageFinder = find.descendant(
      of: sizedboxWrapperChannelImageFinder,
      matching: find.byType(CachedNetworkImage),
    );
    expect(channelImageFinder, findsOneWidget);
    final channelImage = tester.widget<CachedNetworkImage>(channelImageFinder);
    expect(channelImage.imageUrl, localSourceVideo.creatorPhoto);
    expect(channelImage.fit, BoxFit.cover);

    final channelImageLoader = find.byType(CircularProgressIndicator);
    expect(channelImageLoader, findsOneWidget);
    expect(
      tester.widget<CircularProgressIndicator>(channelImageLoader).color,
      MainColor.purple5A579C,
    );

    final channelNameFinder = find.descendant(
      of: rowChannelWrapperFinder,
      matching: find.byType(Text),
    );
    expect(channelNameFinder, findsOneWidget);
    final channelName = tester.widget<Text>(channelNameFinder);
    expect(channelName.data, localSourceVideo.creator);
    expect(
      channelName.style,
      MainTextStyle.poppinsW500.copyWith(
        fontSize: 14,
        color: MainColor.whiteFFFFFF,
      ),
    );

    final rowDetailsWrapperFinder = find.descendant(
      of: columnFinder,
      matching: find.byWidgetPredicate(
        (widget) =>
            widget is Row &&
            widget.children.first is Text &&
            widget.children[1] is DotDivider &&
            widget.children.last is Text,
      ),
    );
    expect(rowDetailsWrapperFinder, findsOneWidget);

    final viewsFinder = find.descendant(
      of: rowDetailsWrapperFinder,
      matching: find.byWidgetPredicate((widget) =>
          widget is Text &&
          widget.data ==
              "${localSourceVideo.viewsCount!.formatViewsCount()} x views"),
    );
    expect(viewsFinder, findsOneWidget);
    final viewsCount = tester.widget<Text>(viewsFinder);
    expect(
      viewsCount.style,
      MainTextStyle.poppinsW500.copyWith(
        fontSize: 13,
        color: MainColor.whiteFFFFFF,
      ),
    );

    final releaseFinder = find.descendant(
      of: rowDetailsWrapperFinder,
      matching: find.byWidgetPredicate(
        (widget) =>
            widget is Text &&
            widget.data == localSourceVideo.releaseDate!.toLocalTime(),
      ),
    );
    expect(releaseFinder, findsOneWidget);
    final releaseDate = tester.widget<Text>(releaseFinder);
    expect(
      releaseDate.style,
      MainTextStyle.poppinsW500.copyWith(
        fontSize: 13,
        color: MainColor.whiteFFFFFF,
      ),
    );

    final descriptionFinder = find.descendant(
      of: columnFinder,
      matching: find.byWidgetPredicate(
        (widget) =>
            widget is Text && widget.data == localSourceVideo.description,
      ),
    );
    expect(descriptionFinder, findsOneWidget);
    final description = tester.widget<Text>(descriptionFinder);
    expect(
      description.style,
      MainTextStyle.poppinsW400.copyWith(
        fontSize: 12,
        color: MainColor.whiteFFFFFF,
      ),
    );

    final inkWellFinder = find.descendant(
      of: columnFinder,
      matching: find.byType(InkWell),
    );
    expect(inkWellFinder, findsOneWidget);
    final inkWell = tester.widget<InkWell>(inkWellFinder);
    expect(inkWell.child, isA<Text>());
    expect(
      (inkWell.child as Text).style,
      MainTextStyle.poppinsW400.copyWith(
        fontSize: 12,
        color: Colors.blue,
      ),
    );

    expect(description.maxLines, 3);
    expect((inkWell.child as Text).data, '...other');
  });

  testWidgets('VideoInformation widget can handle show more action',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(size: Size(480, 800)),
        child: MaterialApp(
          home: Scaffold(
            body: VideoInformation(
              video: localSourceVideo,
            ),
          ),
        ),
      ),
    );

    final columnFinder = find.byType(Column);
    expect(columnFinder, findsOneWidget);
    Finder inkWellFinder = find.descendant(
      of: columnFinder,
      matching: find.byType(InkWell),
    );
    checkWhenCanShowMore(tester, inkWellFinder, columnFinder, false);

    await tester.tap(inkWellFinder);
    await tester.pump();

    inkWellFinder = find.descendant(
      of: columnFinder,
      matching: find.byType(InkWell),
    );

    checkWhenCanLess(tester, inkWellFinder, columnFinder);

    await tester.tap(inkWellFinder);
    await tester.pump();

    inkWellFinder = find.descendant(
      of: columnFinder,
      matching: find.byType(InkWell),
    );
    checkWhenCanShowMore(tester, inkWellFinder, columnFinder, true);
  });
}
