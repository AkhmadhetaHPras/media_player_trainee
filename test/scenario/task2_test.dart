import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:media_player/data/music_model.dart';
import 'package:media_player/data/video_model.dart';
import 'package:media_player/features/home/components/cover_music_card.dart';
import 'package:media_player/features/home/components/cover_video_card.dart';
import 'package:media_player/shared_components/dot_divider.dart';
import 'package:media_player/utils/extension_function.dart';

void main() {
  testWidgets('Structur of cover music card widget is built correctly',
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
    final gestureDetector =
        tester.widget<GestureDetector>(find.byType(GestureDetector));
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
      matching: find.byWidgetPredicate((widget) =>
          widget is Positioned &&
          widget.bottom == -1 &&
          widget.child is ClipRRect),
    );
    expect(positioned, findsOneWidget);

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
    final textContainer = find.descendant(
      of: find.byType(BackdropFilter),
      matching: find.byWidgetPredicate((widget) =>
          widget is Container &&
          widget.alignment == Alignment.centerLeft &&
          widget.decoration is BoxDecoration &&
          widget.child is Column),
    );
    expect(textContainer, findsOneWidget);

    final textContainerDecoration =
        tester.widget<Container>(textContainer).decoration as BoxDecoration;
    expect(textContainerDecoration.gradient, isA<LinearGradient>());

    find.text(music.title!);
    find.text(music.artist!);
  });

  testWidgets('Cover music card render local source',
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

  testWidgets('Cover music card render network source',
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
          widget.child is CachedNetworkImage,
    );
    expect(imageContainer, findsOneWidget);
    final networkImage =
        tester.widget<CachedNetworkImage>(find.byType(CachedNetworkImage));
    expect(networkImage.imageUrl, music.coverPath);

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(networkImage.imageBuilder, isNotNull,
        reason:
            'CachedNetworkImage widget should have imageBuilder as specified');
  });

  testWidgets('Structure of cover video card widget is built correctly',
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

  testWidgets('Cover video card render local source',
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
      fail('Unexpected image type found | use Image.asset instead');
    }
  });

  testWidgets(
      'Cover video card render network source', (WidgetTester tester) async {});
}
