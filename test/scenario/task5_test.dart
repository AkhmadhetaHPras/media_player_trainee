import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:media_player/data/video_model.dart';
import 'package:media_player/features/home/components/cover_video_card.dart';
import 'package:media_player/features/home/home.dart';
import 'package:media_player/features/player/components/video_information.dart';
import 'package:media_player/features/player/videos_player.dart';
import 'package:mockito/mockito.dart';

Video? capturedVideo;

class MockNavigatorObserver extends Mock
    implements NavigatorObserver, WidgetsBindingObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    // print('pushed $route');
    if (route.settings.arguments is Video) {
      capturedVideo = route.settings.arguments as Video;
    }
  }
}

final routes = <String, WidgetBuilder>{
  '/video-player': (_) => const VideosPlayer(),
};

void main() {
  late MockNavigatorObserver mockNavigatorObserver;

  setUp(() {
    mockNavigatorObserver = MockNavigatorObserver();
    WidgetsBinding.instance.addObserver(mockNavigatorObserver);
    capturedVideo = null;
  });

  testWidgets('Video player display its informations',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: const Home(),
        routes: routes,
        navigatorObservers: [mockNavigatorObserver],
      ),
    );
    await tester.pump();
    final firstVideoFinder = find.byType(CoverVideoCard).first;

    await tester.tap(firstVideoFinder);
    await tester.pump();
    await tester.pump();

    if (capturedVideo != null) {
      // final Video video = capturedVideo!;

      final videoInformationFinder = find.byType(VideoInformation);
      expect(videoInformationFinder, findsOneWidget);
    } else {
      fail('Video object not passing to the video player page via arguments');
    }
  });

  tearDown(() {
    WidgetsBinding.instance.removeObserver(mockNavigatorObserver);
  });
}
