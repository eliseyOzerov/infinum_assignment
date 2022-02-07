import 'dart:convert';

// I use VSCode extension called Dart Data Class Generator instead of json_serializable,
// because it's faster (CMD+. vs flutter pub run build_runner build), and because I'm kind of prejudiced against
// generated files after using MobX.
class ShowModel {
  final String id;
  final String title;
  final int likesCount;
  // We make the imageUrl non-final to be able to add the BASE_URL to the returned data since the API returns only a relative url. We
  // could also add the base url inside the ShowRow widget, but that might prove repetitive if we needed the image anywhere else.
  String imageUrl;

  String? type;
  String? description;

  ShowModel({
    required this.id,
    required this.title,
    required this.likesCount,
    required this.imageUrl,
    this.type,
    this.description,
  });

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'title': title,
      'likesCount': likesCount,
      'imageUrl': imageUrl,
      'type': type,
      'description': description,
    };
  }

  factory ShowModel.fromMap(Map<String, dynamic> map) {
    return ShowModel(
      id: map['_id'] ?? '',
      title: map['title'] ?? '',
      likesCount: map['likesCount']?.toInt() ?? 0,
      imageUrl: map['imageUrl'] ?? '',
      type: map['type'],
      description: map['description'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ShowModel.fromJson(String source) => ShowModel.fromMap(json.decode(source));
}
