import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:media_player/data/music_model.dart';
import 'package:media_player/features/home/components/cover_music_card.dart';
import 'package:media_player/features/home/home.dart';
import 'package:media_player/features/player/components/music_cover_image.dart';
import 'package:media_player/features/player/components/time_display.dart';
import 'package:media_player/features/player/music_player.dart';
import 'package:mockito/mockito.dart';

Music? capturedMusic;

class MockNavigatorObserver extends Mock
    implements NavigatorObserver, WidgetsBindingObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    // print('pushed $route');
    if (route.settings.arguments is Music) {
      capturedMusic = route.settings.arguments as Music;
    }
  }
}

final routes = <String, WidgetBuilder>{
  '/music-player': (_) => const MusicPlayer(),
};

void main() {
  late MockNavigatorObserver mockNavigatorObserver;

  setUp(() {
    mockNavigatorObserver = MockNavigatorObserver();
    WidgetsBinding.instance.addObserver(mockNavigatorObserver);
    capturedMusic = null;
  });

  void timeDisplayCheck(Slider slider, Duration duration) {
    expect(find.byType(TimeDisplay), findsOneWidget,
        reason: 'Music player must have a TimeDisplay component');
    expect(
        find.text(
            const Duration().inSeconds.toDouble().toString().split(".")[0]),
        findsOneWidget,
        reason: 'Music player display music position');
    expect(find.text(duration.toString().split(".")[0]), findsOneWidget,
        reason: 'Music player display music duration');
  }

  testWidgets('Music player display music cover image and its informations',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: const Home(),
        routes: routes,
        navigatorObservers: [mockNavigatorObserver],
      ),
    );
    await tester.pump();
    await tester.tap(find.byType(CoverMusicCard).first);
    await tester.pumpAndSettle();

    if (capturedMusic != null) {
      final Music music = capturedMusic!;

      /// display music cover image and its informations
      final musicCoverImageFinder = find.byType(MusicCoverImage);
      final musicCoverImage =
          tester.widget<MusicCoverImage>(musicCoverImageFinder);
      expect(musicCoverImageFinder, findsOneWidget);
      expect(musicCoverImage.sourceType, music.sourceType);
      expect(musicCoverImage.cover, music.coverPath);

      expect(find.text(music.title!), findsOneWidget);
      expect(find.text(music.artist!), findsOneWidget);
      expect(find.text(music.albumName!), findsOneWidget);
      expect(find.text(music.releaseYear!), findsOneWidget);

      /// has a slider with time and duration according to the music source
      final sliderFinder = find.byType(Slider);
      final slider = tester.widget<Slider>(sliderFinder);

      expect(sliderFinder, findsOneWidget);
      expect(slider.value, 0.0);
      expect(slider.min, 0.0);

      AudioPlayer player = AudioPlayer();
      player
          .setSource(music.sourceType == "local"
              ? AssetSource(
                  music.source!.replaceFirst("assets/", ""),
                )
              : UrlSource(music.source!))
          .then((value) async {
        Duration duration = await player.getDuration() ?? const Duration();
        expect(slider.max, duration, reason: '');
        timeDisplayCheck(slider, duration);
      });
    } else {
      fail('Music object not passing to the music player page via arguments');
    }
  });

  tearDown(() {
    WidgetsBinding.instance.removeObserver(mockNavigatorObserver);
  });
}
