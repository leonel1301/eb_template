import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class AnimeHubDatabaseContext {
  final int version = 1;
  final String databaseName = 'anime.db';
  final String tableName = 'favorite_animes';
  late Database _database;

  Future<Database> openDb() async {
    _database = await openDatabase(
      join(await getDatabasesPath(), databaseName),
      version: version,
      onCreate: (database, version) {
        String initialQuery = 'create table $tableName ('
            'id integer primary key,'
            'title varchar(255),'
            'imageUrl varchar(255),'
            'year integer,'
            'episodes integer,'
            'members integer'
            ')';
        database.execute(initialQuery);
      },
    );
    return _database;
  }
}