import 'package:cinci_b/model/game.dart';
import 'package:cinci_b/pages/home_page.dart';
import 'package:cinci_b/persistence/main_service.dart';
import 'package:cinci_b/util/logger.dart';
import 'package:cinci_b/util/network_status.dart';
import 'package:cinci_b/util/toaster.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';

import '../loading_page.dart';
import 'games_page.dart';
import 'local_games_page.dart';

class UserPage extends StatefulWidget {

  String userName;

  UserPage({this.userName});

  @override
  State<StatefulWidget> createState() => _UserPageState();

}

class _UserPageState extends State<UserPage> {
  final Logger logger = Logger('UserPage');

  MainService service = MainService();

  List<Game> games;
  int networkStatus = NetworkStatus.LOADING;

  @override
  Widget build(BuildContext context) {
    if (games == null){
      games = [];
      _updateGames();
    }
    return Scaffold(
      appBar: AppBar(
        title: Text("User Menu"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.offline_pin),
            color: Colors.red,
            onPressed: (){
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LocalGamesPage())
              );
            },
          )
        ],
      ),
      body: Stack(
        children: <Widget>[
          (networkStatus == NetworkStatus.ONLINE) ?
          GamesPage() :
          (networkStatus == NetworkStatus.OFFLINE) ?
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Center(
                  child: Text(
                    "You are offline!",
                    style: TextStyle(
                        color: Colors.red,
                        fontSize: 48.0
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 30, 10, 30),
                  child: RaisedButton(
                      color: Colors.green,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text("Retry "),
                          Icon(Icons.refresh)
                        ],
                      ),
                      onPressed: _updateGames
//                        _updateParamObjects
                  ),
                ),
              )
            ],
          ) :
          Container(),
          (networkStatus == NetworkStatus.LOADING) ?
          LoadingPage("Loading") :
          Container(),
        ],
      ),
    );
  }

  void _updateGames() async {
    setState(() {
      networkStatus = NetworkStatus.LOADING;
    });
    var result = await service.getGames().then((_result){
      logger.debug("GOT RESPONSE");
      setState(() {
        networkStatus = NetworkStatus.ONLINE;
        this.games = _result;
      });
    }).catchError((err){
      logger.error("ERROR RETRIEVING GAMES: " + err.toString());
      Toaster.showToast("Error while updating GAMES!");
      setState(() {
        networkStatus = NetworkStatus.OFFLINE;
      });
    });
  }


}
