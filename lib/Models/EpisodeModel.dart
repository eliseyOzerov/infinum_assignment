import 'dart:convert';

class EpisodeModel {
  final String id;
  final String title;
  final String description;
  final String episodeNumber;
  final String season;

  String imageUrl;

  EpisodeModel({
    required this.id,
    required this.title,
    required this.description,
    required this.episodeNumber,
    required this.season,
    required this.imageUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'title': title,
      'description': description,
      'episodeNumber': episodeNumber,
      'season': season,
      'imageUrl': imageUrl,
    };
  }

  factory EpisodeModel.fromMap(Map<String, dynamic> map) {
    return EpisodeModel(
      id: map['_id'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      episodeNumber: map['episodeNumber'] ?? '',
      season: map['season'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory EpisodeModel.fromJson(String source) => EpisodeModel.fromMap(json.decode(source));
}
