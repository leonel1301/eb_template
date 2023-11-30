class Anime {
  int id;
  final String title;
  final String imageUrl;
  final int year;
  final int episodes;
  final int members;
  Anime(
      {required this.id,
      required this.title,
      required this.imageUrl,
      required this.year,
      required this.episodes,
      required this.members});

  factory Anime.fromJson(Map<String, dynamic> json) {
    return Anime(
      id: json['mal_id'],
      title: json['title'],
      imageUrl: json['images']['jpg']['image_url'],
      year: json['year'] ?? 0,
      episodes: json['episodes'] ?? 0,
      members: json['members'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'imageUrl': imageUrl,
      'year': year,
      'episodes': episodes,
      'members': members,
    };
  }

  Anime.fromDatabaseMap(Map<String, dynamic> map)
      : id = map['id'],
        title = map['title'],
        imageUrl = map['imageUrl'],
        year = map['year'],
        episodes = map['episodes'],
        members = map['members'];

  Map<String, dynamic> toDatabaseMap() {
    return {
      'id': id,
      'title': title,
      'imageUrl': imageUrl,
      'year': year,
      'episodes': episodes,
      'members': members,
    };
  }
}
