import 'dart:convert';
import 'dart:developer';

import 'package:flutter/services.dart';
import 'package:media_player_trainee/constants/assets_const.dart';
import 'package:media_player_trainee/data/music_model.dart';
import 'package:media_player_trainee/data/video_model.dart';

abstract class Repository {
  static List<Music> musics = [];
  static List<Video> videos = [];

  /// Memuat file JSON musik dari sumber data (musics.json).
  /// Data yang diperoleh kemudian dimasukkan ke dalam list [musics].
  static Future<void> getMusics() async {
    try {
      String jsonString = await rootBundle.loadString(AssetsConsts.musicJson);

      Map<String, dynamic> data = json.decode(jsonString);

      final MusicModel response = MusicModel.fromJson(data);
      if (response.status == 200) {
        for (var data in response.data!) {
          musics.add(data);
        }
      } else {
        log(response.error ?? "unknown");
      }
    } catch (e) {
      log(e.toString());
    }
  }

  /// Memuat file JSON musik dari sumber data (videos.json).
  /// Data yang diperoleh kemudian dimasukkan ke dalam list [videos].
  static Future<void> getVideos() async {
    try {
      String jsonString = await rootBundle.loadString(AssetsConsts.videoJson);

      Map<String, dynamic> data = json.decode(jsonString);

      final VideoModel response = VideoModel.fromJson(data);
      if (response.status == 200) {
        for (var data in response.data!) {
          videos.add(data);
        }
      } else {
        log(response.error ?? "unknown");
      }
    } catch (e) {
      log(e.toString());
    }
  }
}
