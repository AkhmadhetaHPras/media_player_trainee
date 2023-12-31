// To parse this JSON data, do
//
//     final musicModel = musicModelFromJson(jsonString);

import 'dart:convert';

MusicModel musicModelFromJson(String str) =>
    MusicModel.fromJson(json.decode(str));

String musicModelToJson(MusicModel data) => json.encode(data.toJson());

class MusicModel {
  int? status;
  List<Music>? data;
  String? error;

  MusicModel({
    this.status,
    this.data,
    this.error,
  });

  factory MusicModel.fromJson(Map<String, dynamic> json) => MusicModel(
        status: json["status"],
        data: json["data"] == null
            ? []
            : List<Music>.from(json["data"]!.map((x) => Music.fromJson(x))),
        error: json["error"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
        "error": error,
      };
}

class Music {
  String? title;
  String? artist;
  String? albumName;
  String? releaseYear;
  String? sourceType;
  String? source;
  // int? duration;
  String? coverPath;

  Music({
    this.title,
    this.artist,
    this.albumName,
    this.releaseYear,
    this.sourceType,
    this.source,
    // this.duration,
    this.coverPath,
  });

  factory Music.fromJson(Map<String, dynamic> json) => Music(
        title: json["title"],
        artist: json["artist"],
        albumName: json["album_name"],
        releaseYear: json["release_year"],
        sourceType: json["source_type"],
        source: json["source"],
        // duration: json["duration"],
        coverPath: json["cover_path"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "artist": artist,
        "album_name": albumName,
        "release_year": releaseYear,
        "source_type": sourceType,
        "source": source,
        // "duration": duration,
        "cover_path": coverPath,
      };
}
