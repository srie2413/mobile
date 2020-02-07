import 'package:cinci_b/model/game.dart';
import 'package:cinci_b/util/logger.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  final Logger logger = Logger('DatabaseHelper');

  static DatabaseHelper _databaseHelper;
  static Database _database;

  String tableName = 'game_table';

  String colId = 'id';
  String colGameId = 'gameId';
  String colGameName = 'gameName';
  String colGameStatus = 'gameStatus';
  String colGameUser = 'gameUser';
  String colGameSize = 'gameSize';
  String colGamePopularityScore = 'gamePopularityScore';

  DatabaseHelper._createInstance();

  factory DatabaseHelper(){
    if (_databaseHelper == null)
      _databaseHelper = DatabaseHelper._createInstance();
    return _databaseHelper;
  }

  Future<Database> get database async {
    if (_database == null)
      _database = await initializeDatabase();
    return _database;
  }

  Future<Database> initializeDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'mobile_exam_database.db';

    var myDatabase = await openDatabase(path, version: 1, onCreate: _createDB);
    return myDatabase;
  }

  void _createDB(Database db, int newVersion) async {
    await db.execute('CREATE TABLE $tableName('
        ' $colId integer primary key autoincrement,'
        ' $colGameId integer,'
        ' $colGameName text,'
        ' $colGameStatus text,'
        ' $colGameUser text,'
        ' $colGameSize integer,'
        ' $colGamePopularityScore integer'
        ')');
  }

  Future<List<Map<String, dynamic>>> _getGames() async {
    Database db = await this.database;
    var result = await db.query(tableName);
    return result;
  }

  Future<List<Game>> getGames() async {
    logger.debug("getGames()");
    var gamesList = await _getGames();
    int count = gamesList.length;

    List<Game> games = [];
    for (int i = 0; i < count; i++){
      games.add(Game.fromDbMap(gamesList[i]));
    }
    return games;
  }

  Future<int> addGame(Game game) async {
    logger.debug("addGame($game)");
    Database db = await this.database;
    var result = await db.rawInsert('INSERT INTO $tableName'
        '($colGameId, $colGameName, $colGameStatus, $colGameUser, $colGameSize, $colGamePopularityScore)'
        ' values (${game.id}, "${game.name}", "${game.status}", "${game.user}", ${game.size}, ${game.popularityScore})');
    return result;
  }

  Future<int> removeGame(int gameId) async {
    logger.debug("removeGame($gameId)");
    Database db = await this.database;
    var result = await db.rawDelete('DELETE FROM $tableName where $colGameId = $gameId');
    return result;
  }

  Future<List<Map<String, dynamic>>> _isFulfilledAux(int requestId) async {
    Database db = await this.database;
    var result = db.query(tableName, where: '$colGameId = $requestId');
    return result;
  }

  Future<bool> isFulfilled(int requestId) async {
    print("isFulfilled($requestId)");
    var result = await _isFulfilledAux(requestId);
    int count = result.length;
    return (count > 0);
  }

}