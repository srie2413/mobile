import 'dart:convert';
import 'package:cinci_b/model/game.dart';
import 'package:cinci_b/util/logger.dart';
import 'package:cinci_b/util/network_status.dart';
import 'package:connectivity/connectivity.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class MainService{

  final String url = "http://${NetworkStatus.NETWORK_IP}:${NetworkStatus.PORT}";
  static const Duration DEFAULT_DURATION = Duration(seconds: 2);

  Logger logger = Logger('MainService');

  bool isConnected;

  MainService();

  Future<bool> checkConnection() async {
    var connectivityResult = await (Connectivity().checkConnectivity());

    if (connectivityResult == ConnectivityResult.wifi) {
      if(!isConnected){
        isConnected = true;
//        synchronize();
      }
      return true;
    }

    isConnected = false;
    return false;
  }

  Future<List<Game>> getSelections() async {

    logger.debug("getSelections()");
    var path = url + "/ready";
    final response = await http.get(path).timeout(DEFAULT_DURATION);
    if (response.statusCode == 200){
      logger.debug("Got games: " + response.body);
      var games = jsonDecode(response.body).map<Game>((r) => Game.fromMap(r)).toList();
      return games;
    } else {
      return [];
    }
  }


  Future<List<Game>> getGames() async {

    var user = "";

    final prefs = await SharedPreferences.getInstance();
    user = prefs.getString('user');

    logger.debug("getGames()");
    var path = url + "/games/$user";
    final response = await http.get(path).timeout(DEFAULT_DURATION);
    if (response.statusCode == 200){
      logger.debug("Got games: " + response.body);
      var games = jsonDecode(response.body).map<Game>((r) => Game.fromMap(r)).toList();
      return games;
    } else {
      return [];
    }
  }

  Future<List<Game>> getTopGames() async {
    logger.debug("getTopGames()");
    var path = url + "/allGames";
    final response = await http.get(path).timeout(DEFAULT_DURATION);
    if (response.statusCode == 200){
      logger.debug("Got top games: " + response.body);
      var games = jsonDecode(response.body).map<Game>((r) => Game.fromMap(r)).toList();
      return games;
    } else {
      return [];
    }
  }

  Future<List<Game>> getFulfilledRequests() async {
    logger.debug("getFulfilledRequests()");
    var path = url + "/closed";
    final response = await http.get(path).timeout(DEFAULT_DURATION);
    if (response.statusCode == 200){
      logger.debug("Got fulfilled requests: " + response.body);
      var requests = jsonDecode(response.body).map<Game>((r) => Game.fromMap(r)).toList();
      return requests;
    } else{
      return [];
    }
  }

//  Future<List<String>> getAllParamObjects() async {
//    logger.debug("getAllParamObjects()");
//    var path = url + "/paramObjects";
//    final response = await http.get(path).timeout(DEFAULT_DURATION);
//    if (response.statusCode == 200) {
//      List<String> paramObjects = (jsonDecode(response.body).map<String>((g) =>
//          g.toString())).toList();
//      return paramObjects;
//    } else {
//      throw Exception("Bad request");
//    }
//  }

  Future<bool> addGame(Game game) async {
    logger.debug("addGame($game)");
    var path = url + "/game";
    final response = await http.post(path,
        headers: {"Content-type": "application/json"},
        body: jsonEncode(game.toMap())
    ).timeout(DEFAULT_DURATION);
    if (response.statusCode == 200){
      return true;
    } else {
      return false;
    }
  }

  Future<bool> deleteRequest(int requestId) async {
    logger.debug("deleteRequest($requestId)");
    var path = url + "/request/$requestId";
    final response = await http.delete(path).timeout(DEFAULT_DURATION);
    if (response.statusCode == 200) {
      logger.error("Deleted request: " + requestId.toString());
      return true;
    }
    else{
      logger.error("Wrong request: status=" + response.statusCode.toString());
      return false;
    }
  }

  Future<bool> borrowGame(int gameId) async {

    var user = "";

    final prefs = await SharedPreferences.getInstance();
    user = prefs.getString('user');

    logger.debug("borrowGame($gameId)");
    var path = url + "/book/$user";
    var o = {"id": gameId};

    final response = await http.post(path,
        headers: {"Content-type": "application/json"},
        body: jsonEncode(o)).timeout(DEFAULT_DURATION);
    if (response.statusCode == 200)
      return true;
    else
      return false;
  }

}