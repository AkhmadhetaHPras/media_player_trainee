import 'package:flutter_test/flutter_test.dart';
import 'package:media_player_trainee/data/repository.dart';

// abstract class RepositoryTest {
void runRepoTests() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Repository', () {
    test('Get Musics - Musics list is not empty', () async {
      await Repository.getMusics();
      expect(Repository.musics.isNotEmpty, true);
    });

    test('Get Videos - Videos list is not empty', () async {
      await Repository.getVideos();
      expect(Repository.videos.isNotEmpty, true);
    });
  });
}
// }
