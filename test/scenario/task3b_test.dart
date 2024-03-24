import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:media_player/data/music_model.dart';
import 'package:media_player/features/home/components/cover_music_card.dart';
import 'package:media_player/features/home/home.dart';
import 'package:media_player/features/player/components/controll_button.dart';
import 'package:media_player/features/player/music_player.dart';
import 'package:mockito/mockito.dart';

final localMusic = Music(
  title: 'Night Changes',
  artist: 'One Direction',
  coverPath: 'assets/imgs/cover_one_direction_night_changes.jpeg',
  sourceType: 'local',
);

final networkMusic = Music(
  title: 'STAY',
  artist: 'The Kid LAROI, Justin Bieber',
  coverPath:
      'https://github.com/AkhmadhetaHPras/host-assets/blob/main/media-player/cover_justin_bieber_stay.jpeg?raw=true',
  sourceType: 'network',
);

Music? capturedMusic;
Duration musicDuration = const Duration(milliseconds: 240000);

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

class MockAudioPlayer extends Mock implements AudioPlayer {
  PlayerState mockState = PlayerState.stopped;
  double mockVolume = 1.0;
  Duration positionAfterSeek = const Duration();

  @override
  Future<void> play(Source source,
      {double? volume,
      double? balance,
      AudioContext? ctx,
      Duration? position,
      PlayerMode? mode}) async {
    // ignore: avoid_print
    // print('play called');
    mockState = PlayerState.playing;
  }

  @override
  Future<void> pause() async {
    mockState = PlayerState.paused;
  }

  @override
  Future<void> stop() async {
    mockState = PlayerState.stopped;
  }

  @override
  Future<void> setVolume(double volume) async {
    mockVolume = volume;
  }

  @override
  Future<void> setSource(Source source) async {
    // ignore: avoid_print
    // print('set source');
  }

  @override
  Future<Duration?> getDuration() async {
    return musicDuration;
  }

  @override
  Stream<Duration> get onPositionChanged => Stream.value(positionAfterSeek);

  @override
  Future<void> seek(Duration position) async {
    positionAfterSeek = position;
  }
}

final routes = <String, WidgetBuilder>{
  '/music-player': (_) => const MusicPlayer(),
};

void main() {
  late MockNavigatorObserver mockNavigatorObserver;

  setUp(() {
    mockNavigatorObserver = MockNavigatorObserver();
    capturedMusic = null;
  });

  testWidgets(
      'MusicPlayer can perform audio operations (initialize player, play, pause, and seek to second)',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: const Home(),
        routes: routes,
        navigatorObservers: [mockNavigatorObserver],
      ),
    );
    await tester.pump();
    expect(find.byType(Home), findsOneWidget);
    await tester.tap(find.byType(CoverMusicCard).first);
    await tester.pumpAndSettle();

    final musicPlayerFinder = find.byType(MusicPlayer);
    expect(musicPlayerFinder, findsOneWidget);

    /// [Initialize Player]
    final musicPlayer = tester.widget<StatefulWidget>(musicPlayerFinder);

    final musicPlayerElement = musicPlayer.createElement();
    final musicPlayerState = musicPlayerElement.state as MusicPlayerState;
    final mockPlayer = MockAudioPlayer();
    musicPlayerState.newPlayer = mockPlayer;

    expect(find.text(capturedMusic!.title!), findsOneWidget);
    expect(musicPlayerState.play, isFalse);
    expect(mockPlayer.mockState, PlayerState.stopped);
    musicPlayerState.music = capturedMusic!;
    await tester.pump();
    musicPlayerState.initPlayerState();
    await tester.pumpAndSettle();
    final capturedSource = capturedMusic!.sourceType == "local"
        ? AssetSource(
            capturedMusic!.source!.replaceFirst("assets/", ""),
          )
        : UrlSource(capturedMusic!.source!);
    expect(
      musicPlayerState.source.toString(),
      capturedSource.toString(),
    );
    expect(musicPlayerState.duration, await mockPlayer.getDuration());

    /// [Play]
    final icnButtonFinder = find.byType(ControllButton);
    expect(icnButtonFinder, findsOneWidget);
    final icnButton = tester.widget<ControllButton>(icnButtonFinder);
    expect(
        icnButton.onPressed.toString(), musicPlayerState.playPause.toString());

    await musicPlayerState.playPause();
    await tester.pumpAndSettle();
    expect(musicPlayerState.play, isTrue);
    expect(mockPlayer.mockVolume, 1);
    expect(mockPlayer.mockState, PlayerState.playing);

    /// [Seek to Second]
    final Slider slider = tester.widget<Slider>(find.byType(Slider).first);
    expect(
        slider.onChanged.toString(), musicPlayerState.seekToSecond.toString());

    musicPlayerState.seekToSecond(120);
    await tester.pump();
    expect(mockPlayer.positionAfterSeek, const Duration(seconds: 120));
    expect(musicPlayerState.play, isTrue);

    musicPlayerState.seekToSecond(musicDuration.inSeconds.toDouble());
    await tester.pump();
    expect(mockPlayer.positionAfterSeek, musicDuration);

    /// [Pause]
    await musicPlayerState.playPause();
    await tester.pumpAndSettle();
    expect(musicPlayerState.play, isFalse);
    expect(mockPlayer.mockState, PlayerState.paused);
  });
}
