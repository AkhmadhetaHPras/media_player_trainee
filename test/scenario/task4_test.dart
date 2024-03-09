import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:media_player/data/video_model.dart';
import 'package:media_player/features/player/components/loading_video_placeholder.dart';

void main() {
  final localSourceVideo = Video(
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
          widget.child is CachedNetworkImage),
    );

    expect(videoWrapperFinder, findsOneWidget);
    final networkImage =
        tester.widget<CachedNetworkImage>(find.byType(CachedNetworkImage));
    expect(networkImage.imageUrl, networkSourceVideo.coverPath);

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(networkImage.imageBuilder, isNotNull,
        reason:
            'CachedNetworkImage widget should have imageBuilder as specified');
  });

  testWidgets('Structur of VideoIndicator widget is built correctly',
      (WidgetTester tester) async {});

  testWidgets('Structur of VideoInformation widget is built correctly',
      (WidgetTester tester) async {});

  testWidgets('VideoInformation widget can handle show more action',
      (WidgetTester tester) async {});
}
