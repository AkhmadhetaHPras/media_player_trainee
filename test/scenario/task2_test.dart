import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:media_player/config/themes/main_color.dart';
import 'package:media_player/data/music_model.dart';
import 'package:media_player/data/video_model.dart';
import 'package:media_player/features/home/components/cover_music_card.dart';
import 'package:media_player/features/home/components/cover_video_card.dart';
import 'package:media_player/features/home/components/title_section.dart';
import 'package:media_player/features/home/home.dart';
import 'package:media_player/shared_components/dot_divider.dart';
import 'package:media_player/utils/extension_function.dart';

void main() {
  testWidgets('Structur of CoverMusicCard widget is built correctly',
      (WidgetTester tester) async {
    // Create a mock Music object for testing
    final music = Music(
      title: 'Night Changes',
      artist: 'One Direction',
      coverPath: 'assets/imgs/cover_one_direction_night_changes.jpeg',
      sourceType: 'local',
    );

    // Build the widget
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: CoverMusicCard(music: music),
      ),
    ));
    // Find the widget in the test environment
    final coverMusicCard = find.byType(CoverMusicCard);
    expect(coverMusicCard, findsOneWidget);

    // Verify the structure of the widget
    final gestureDetectorFinder = find.byType(GestureDetector);
    expect(gestureDetectorFinder, findsOneWidget);
    final gestureDetector =
        tester.widget<GestureDetector>(gestureDetectorFinder);
    expect(gestureDetector.child, isA<Stack>());

    final stack = gestureDetector.child as Stack;
    expect(stack.alignment, Alignment.bottomCenter);
    expect(stack.children.length, 2);

    // Check for the container
    final imageContainer = find.descendant(
      of: find.byType(Stack),
      matching: find.byWidgetPredicate((widget) {
        // ignore: sized_box_for_whitespace
        final mockContainer = Container(
          width: 190,
          height: 200,
        );

        return widget is Container &&
            widget.decoration is ShapeDecoration &&
            widget.constraints == mockContainer.constraints;
      }),
    );
    expect(imageContainer, findsOneWidget);

    // Check for the positioned
    final positioned = find.descendant(
      of: find.byType(Stack),
      matching: find.byWidgetPredicate(
        (widget) =>
            widget is Positioned &&
            widget.bottom == -1 &&
            widget.child is ClipRRect,
      ),
    );
    expect(positioned, findsOneWidget);

    final clipRRectFinder = find.descendant(
      of: find.byType(Positioned),
      matching: find.byType(ClipRRect),
    );
    expect(clipRRectFinder, findsOneWidget);
    final clipRRect = tester.widget<ClipRRect>(clipRRectFinder);
    expect(
      (clipRRect.borderRadius as BorderRadius).bottomLeft,
      const Radius.circular(36),
    );
    expect(
      (clipRRect.borderRadius as BorderRadius).bottomRight,
      const Radius.circular(36),
    );

    // Check for the BackdropFilter
    final backdropFilter = find.descendant(
      of: find.byType(ClipRect),
      matching: find.byWidgetPredicate((widget) =>
          widget is BackdropFilter &&
          widget.filter == ImageFilter.blur(sigmaX: 5, sigmaY: 5) &&
          widget.child is Container),
    );
    expect(backdropFilter, findsOneWidget);

    // Check for the text container
    final textContainerFinder = find.descendant(
      of: find.byType(BackdropFilter),
      matching: find.byWidgetPredicate((widget) =>
          widget is Container &&
          widget.alignment == Alignment.centerLeft &&
          widget.decoration is BoxDecoration &&
          widget.child is Column),
    );
    expect(textContainerFinder, findsOneWidget);
    final textContainer = tester.widget<Container>(textContainerFinder);
    expect((textContainer.padding as EdgeInsets).horizontal, 48);
    expect((textContainer.padding as EdgeInsets).vertical, 16);

    final textContainerDecoration = textContainer.decoration as BoxDecoration;
    expect(textContainerDecoration.gradient, isA<LinearGradient>());
    final linearGradient = textContainerDecoration.gradient as LinearGradient;

    expect(linearGradient.begin, const Alignment(0.00, -1.00));
    expect(linearGradient.end, const Alignment(0, 1));
    expect(linearGradient.colors, [
      MainColor.black120911,
      MainColor.black0D0D0D,
    ]);

    find.text(music.title!);
    find.text(music.artist!);
  });

  testWidgets('CoverMusicCard render local source',
      (WidgetTester tester) async {
    // Create a mock Music object for testing
    final music = Music(
      title: 'Night Changes',
      artist: 'One Direction',
      coverPath: 'assets/imgs/cover_one_direction_night_changes.jpeg',
      sourceType: 'local',
    );

    // Build the widget
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: CoverMusicCard(music: music),
      ),
    ));

    final imageContainer = find.byWidgetPredicate(
      (widget) =>
          widget is Container &&
          widget.decoration is ShapeDecoration &&
          widget.child == null,
    );
    expect(imageContainer, findsOneWidget);

    final decoration =
        tester.widget<Container>(imageContainer).decoration as ShapeDecoration;
    expect(decoration.image, isA<DecorationImage>());
    expect(decoration.image?.image, AssetImage(music.coverPath!));
    expect(decoration.image?.fit, BoxFit.cover);
    expect(decoration.shape, isA<RoundedRectangleBorder>());
  });

  testWidgets('CoverMusicCard render network source',
      (WidgetTester tester) async {
    // Create a mock Music object for testing
    final music = Music(
      title: 'STAY',
      artist: 'The Kid LAROI, Justin Bieber',
      coverPath:
          'https://github.com/AkhmadhetaHPras/host-assets/blob/main/media-player/cover_justin_bieber_stay.jpeg?raw=true',
      sourceType: 'network',
    );

    // Build the widget
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: CoverMusicCard(music: music),
      ),
    ));

    // check if container child is CachedNetworkImage when music sourceType is network
    final imageContainer = find.byWidgetPredicate(
      (widget) =>
          widget is Container &&
          widget.decoration is ShapeDecoration &&
          widget.child is ClipRRect,
    );
    expect(imageContainer, findsOneWidget);

    final clipRRect =
        tester.widget<Container>(imageContainer).child as ClipRRect;
    expect(clipRRect.borderRadius, BorderRadius.circular(36));
    expect(clipRRect.child, isA<CachedNetworkImage>());

    final networkImage = clipRRect.child as CachedNetworkImage;
    expect(networkImage.imageUrl, music.coverPath);

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(networkImage.fit, BoxFit.cover);
  });

  testWidgets('Structure of coverVideoCard widget is built correctly',
      (WidgetTester tester) async {
    // Create a mock Music object for testing
    final video = Video(
      title: "Aquaman And The Lost Kingdom | Trailer",
      creator: "DC",
      releaseDate: "2023-09-14",
      sourceType: "local",
      source: "assets/videos/aquaman_and_the_lost_kingdom_trailer.mp4",
      coverPath: "assets/imgs/cover_aquaman_and_the_lost_kingdom_trailer.jpeg",
      viewsCount: 1082000,
    );

    // Build the widget
    await tester.pumpWidget(MediaQuery(
      data: const MediaQueryData(size: Size(480, 800)),
      child: MaterialApp(
        home: Scaffold(
          body: CoverVideoCard(video: video),
        ),
      ),
    ));
    // Find the widget in the test environment
    final coverVideoCard = find.byType(CoverVideoCard);
    expect(coverVideoCard, findsOneWidget);

    // Verify the structure of the widget
    final gestureDetector =
        tester.widget<GestureDetector>(find.byType(GestureDetector));
    expect(gestureDetector.child, isA<Column>());
    final column = gestureDetector.child as Column;
    expect(column.crossAxisAlignment, CrossAxisAlignment.start);

    final imageWrapper = find.descendant(
      of: find.byKey(const Key('column_card_wrapper')),
      matching: find.byWidgetPredicate(
        (widget) =>
            widget is SizedBox &&
            widget.width == double.infinity &&
            widget.height == 270,
      ),
    );
    expect(imageWrapper, findsOneWidget);

    final infoWrapper = find.descendant(
      of: find.byKey(const Key('column_card_wrapper')),
      matching: find.byWidgetPredicate(
        (widget) => widget is Padding && widget.child is Column,
      ),
    );
    expect(infoWrapper, findsOneWidget);

    final columnInfoWrapper =
        tester.widget<Padding>(infoWrapper).child as Column;
    expect(columnInfoWrapper.crossAxisAlignment, CrossAxisAlignment.start);

    // assert video title
    final videoTitleFinder = find.descendant(
      of: infoWrapper,
      matching: find.text(video.title!),
    );
    final videoTitle = tester.widget<Text>(videoTitleFinder);
    expect(videoTitleFinder, findsOneWidget);

    expect(videoTitle.maxLines, 2);
    expect(videoTitle.overflow, TextOverflow.ellipsis);
    expect(videoTitle.style, isNotNull);

    // assert other video data
    final expectedString = [
      video.creator!,
      "${video.viewsCount!.formatViewsCount()} x views",
      video.releaseDate!.toLocalTime()
    ];
    for (var text in expectedString) {
      final videoDataFinder = find.descendant(
        of: infoWrapper,
        matching: find.text(text),
      );
      final videoDataText = tester.widget<Text>(videoDataFinder);
      expect(videoDataFinder, findsOneWidget);
      expect(videoDataText.overflow, TextOverflow.ellipsis);
      expect(videoDataText.style, isNotNull);
    }

    expect(find.descendant(of: infoWrapper, matching: find.byType(DotDivider)),
        findsAtLeastNWidgets(2));
  });

  testWidgets('CoverVideoCard render local source',
      (WidgetTester tester) async {
    final video = Video(
      title: "Aquaman And The Lost Kingdom | Trailer",
      creator: "DC",
      releaseDate: "2023-09-14",
      sourceType: "local",
      source: "assets/videos/aquaman_and_the_lost_kingdom_trailer.mp4",
      coverPath: "assets/imgs/cover_aquaman_and_the_lost_kingdom_trailer.jpeg",
      viewsCount: 1082000,
    );

    // Build the widget
    await tester.pumpWidget(MediaQuery(
      data: const MediaQueryData(size: Size(480, 800)),
      child: MaterialApp(
        home: Scaffold(
          body: CoverVideoCard(video: video),
        ),
      ),
    ));

    final imageWrapper = find.descendant(
      of: find.byKey(const Key('column_card_wrapper')),
      matching: find.byWidgetPredicate(
        (widget) =>
            widget is SizedBox &&
            widget.width == double.infinity &&
            widget.height == 270 &&
            widget.child is Image,
      ),
    );
    expect(imageWrapper, findsOneWidget);

    final image = (tester.widget<SizedBox>(imageWrapper).child as Image).image;
    if (image is AssetImage) {
      expect(image.assetName, video.coverPath!);
    } else if (image is ExactAssetImage) {
      expect(image.assetName, video.coverPath!);
    } else {
      fail('Unexpected asset image widget found | use Image.asset instead');
    }
  });

  testWidgets('CoverVideoCard render network source',
      (WidgetTester tester) async {
    final video = Video(
      title: "FutureBuilder (Widget of the Week)",
      creator: "Flutter",
      releaseDate: "2018-01-23",
      sourceType: "network",
      source:
          "https://github.com/AkhmadhetaHPras/host-assets/raw/main/media-player/flutter_future_builder_widget_of_the_week.mp4",
      coverPath:
          "https://github.com/AkhmadhetaHPras/host-assets/blob/main/media-player/cover_flutter_future_builder_widget_of_the_week.jpeg?raw=true",
      viewsCount: 80912801,
    );

    // Build the widget
    await tester.pumpWidget(MediaQuery(
      data: const MediaQueryData(size: Size(480, 800)),
      child: MaterialApp(
        home: Scaffold(
          body: CoverVideoCard(video: video),
        ),
      ),
    ));

    final imageWrapper = find.descendant(
      of: find.byKey(const Key('column_card_wrapper')),
      matching: find.byWidgetPredicate(
        (widget) =>
            widget is SizedBox &&
            widget.width == double.infinity &&
            widget.height == 270 &&
            widget.child is ClipRRect,
      ),
    );
    expect(imageWrapper, findsOneWidget);

    // here
    final clipRRect = tester.widget<SizedBox>(imageWrapper).child as ClipRRect;
    expect(clipRRect.child, isA<CachedNetworkImage>());

    final networkImage = clipRRect.child as CachedNetworkImage;
    expect(networkImage.imageUrl, video.coverPath);

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(networkImage.fit, BoxFit.cover);
  });

  /// HOME TEST
  testWidgets('Home display music and video list', (WidgetTester tester) async {
    // Build the widget
    await tester.pumpWidget(const MaterialApp(
      home: Scaffold(
        body: Home(),
      ),
    ));

    final musicTitle = find.byWidgetPredicate((widget) =>
        widget is TitleSection && widget.title == 'Music Collections');
    expect(musicTitle, findsOneWidget);
    expect(find.text('Music Collections'), findsOneWidget);

    final listWrapper = find.byWidgetPredicate(
      (widget) =>
          widget is SizedBox &&
          widget.height! >= 200 &&
          widget.child is ListView &&
          widget.child?.key == const Key('music_list_view'),
    );
    expect(listWrapper, findsOneWidget,
        reason:
            'Music list view must be wrapped in a Sizedbox that has a certain height');

    final musicListFinder = find.byKey(const Key('music_list_view'));
    expect(musicListFinder, findsOneWidget);
    final musicList = tester.widget<ListView>(musicListFinder);
    expect(musicList.scrollDirection, Axis.horizontal);

    final videoTitle = find.byWidgetPredicate(
        (widget) => widget is TitleSection && widget.title == 'Videos');
    expect(videoTitle, findsOneWidget);
    expect(find.text('Videos'), findsOneWidget);

    final videoListFinder = find.byKey(const Key('video_list_view'));
    expect(videoListFinder, findsOneWidget);
    final videoList = tester.widget<ListView>(videoListFinder);
    expect(videoList.physics, const NeverScrollableScrollPhysics());
    expect(videoList.shrinkWrap, true);

    await tester.pump();
    expect(find.byType(CoverMusicCard), findsWidgets);
    expect(find.byType(CoverVideoCard), findsWidgets);
  });
}
