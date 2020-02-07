import 'dart:convert';

import 'package:cinci_b/model/game.dart';
import 'package:cinci_b/pages/user/add_game.dart';
import 'package:cinci_b/persistence/database_helper.dart';
import 'package:cinci_b/persistence/main_service.dart';
import 'package:cinci_b/util/logger.dart';
import 'package:cinci_b/util/network_status.dart';
import 'package:cinci_b/util/toaster.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:web_socket_channel/io.dart';

import '../loading_page.dart';

class GamesPage extends StatefulWidget{

  @override
  State<StatefulWidget> createState() => _GamesPageState();

}

class _GamesPageState extends State<GamesPage> {
  Logger logger = Logger('GamesPage');


  DatabaseHelper databaseHelper = DatabaseHelper();
  MainService service = MainService();

  final webSocket = IOWebSocketChannel.connect(
      'ws://${NetworkStatus.NETWORK_IP}:${NetworkStatus.PORT}');

  List<Game> games;
  int networkStatus = NetworkStatus.ONLINE;

  @override
  Widget build(BuildContext context) {
    if (games == null){
      games = [];
      _updateGames();
    }
    return Scaffold(
      body: Stack(
        children: <Widget>[
      Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
        Expanded(
        flex: 4,
        child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
        decoration: BoxDecoration(
        border: Border.all(color: Colors.redAccent, width: 5.0),
        borderRadius: BorderRadius.circular(15.0)
          ),
            child: ListView.builder(
              itemCount: (games != null) ? games.length : 0,
              itemBuilder: (BuildContext ctx, int position){
                return ListTile(
                  title: Text(games[position].name),
                  subtitle: Row(
                    children: <Widget>[
                      Text("Status: " + games[position].status),
                      SizedBox(width: 10,),
                      Text("Size: " + games[position].size.toString())
                    ],
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.check_circle),
                    onPressed: () => _borrow(games[position]),
                  ),
                );
              }
          ),
        ),
        ),
        ),
      Expanded(
        flex: 0,
        child: StreamBuilder(
                  stream: webSocket.stream,
                  builder: (context, snapshot) {
                    if (snapshot.hasData){
                      Map userMap = jsonDecode(snapshot.data);
                      var game = Game.fromJson(userMap);
                      Toaster.showToast("New product added:" + game.toString());
                    }
                    return Container();
                  }
                  ),
      ),
        ],
      ),
          (networkStatus == NetworkStatus.LOADING) ?
          LoadingPage("Loading") :
          Container()
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
          onPressed: () async {
            bool waiter = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddGamePage())
            );
            if (waiter != null && waiter){
              Toaster.showToast("Added!");
              _updateGames();
            } else {
              Toaster.showToast("Error while adding!");
            }
          }
      ),
    );
  }

  void _updateGames(){
    service.getGames().then((_result){
      setState(() {
        this.games = _result;
      });
    }).catchError((err){
      logger.debug("Could not get games");
      Toaster.showToast("Could not get games");
    });
  }

  void _borrow(Game game) async {
    setState(() {
      networkStatus = NetworkStatus.LOADING;
    });
    var result = await service.borrowGame(game.id).then((_res){
      setState(() {
        networkStatus = NetworkStatus.ONLINE;
        this.games.remove(game);
      });
      final Future<Database> dbFuture = databaseHelper.initializeDatabase();
      dbFuture.then((_){
        databaseHelper.addGame(game);
      }).catchError((err){
        Toaster.showToast("Could not save into DB");
      });
    }).catchError((err){
      Toaster.showToast("Error while fulfilling request!");
      setState(() {
        networkStatus = NetworkStatus.OFFLINE;
      });
    });
  }

  @override
  void dispose() {
    webSocket.sink.close();
    super.dispose();
  }

}