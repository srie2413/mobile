import 'package:cinci_b/model/game.dart';
import 'package:cinci_b/pages/home_page.dart';
import 'package:cinci_b/pages/selection/selection_page.dart';
import 'package:cinci_b/persistence/main_service.dart';
import 'package:cinci_b/util/logger.dart';
import 'package:cinci_b/util/network_status.dart';
import 'package:cinci_b/util/toaster.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';

import '../loading_page.dart';

class PreSelectionPage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => _PreSelectionPageState();

}

class _PreSelectionPageState extends State<PreSelectionPage> {
  final Logger logger = Logger('PreselectionPage');

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
        title: Text("Selection Page"),
        actions: <Widget>[
        ],
      ),
      body: Stack(
        children: <Widget>[
          (networkStatus == NetworkStatus.ONLINE) ?
          SelectionPage() :
          (networkStatus == NetworkStatus.OFFLINE) ?
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Center(
                  child: Text(
                    "This section isn't available offline!",
                    style: TextStyle(
                        color: Colors.red,
                        fontSize: 48.0
                    ),
                  ),
                ),
              ),
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
    var result = await service.getSelections().then((_result){
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
