import 'package:eb_template/models/anime_model.dart';
import 'package:eb_template/persistence/database/anime_database.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

class AnimeRepository {
  AnimeHubDatabaseContext databaseContext = AnimeHubDatabaseContext();

  Future insert(Anime anime) async {
    Database db = await databaseContext.openDb();
    db.insert(databaseContext.tableName, anime.toDatabaseMap());

    final prefs = await SharedPreferences.getInstance();
    int totalEpisodes = prefs.getInt('totalEpisodes') ?? 0;
    int totalMembers = prefs.getInt('totalMembers') ?? 0;
    prefs.setInt('totalEpisodes', totalEpisodes + anime.episodes);
    prefs.setInt('totalMembers', totalMembers + anime.members);
  }

  Future delete(Anime anime) async {
    Database db = await databaseContext.openDb();
    db.delete(databaseContext.tableName,
        where: "id=?", whereArgs: [anime.id]);

    final prefs = await SharedPreferences.getInstance();
    int totalEpisodes = prefs.getInt('totalEpisodes') ?? 0;
    int totalMembers = prefs.getInt('totalMembers') ?? 0;
    prefs.setInt('totalEpisodes', totalEpisodes - anime.episodes);
    prefs.setInt('totalMembers', totalMembers - anime.members);
  }

  Future<bool> existById(int id) async {
    Database db = await databaseContext.openDb();

    final characters = await db
        .query(databaseContext.tableName, where: "id=?", whereArgs: [id]);

    return characters.isNotEmpty;
  }

  Future<List<Anime>> getAll() async {
    Database db = await databaseContext.openDb();
    final characters = await db.query(databaseContext.tableName);
    return characters
        .map((character) => Anime.fromDatabaseMap(character))
        .toList();
  }
}