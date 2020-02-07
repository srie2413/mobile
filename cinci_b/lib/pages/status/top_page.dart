import 'package:cinci_b/model/game.dart';
import 'package:cinci_b/persistence/main_service.dart';
import 'package:cinci_b/util/network_status.dart';
import 'package:cinci_b/util/toaster.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';

import '../loading_page.dart';

class TopPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _TopPageState();

}

class _TopPageState extends State<TopPage> {
  MainService service = MainService();

  List<Game> topGames;
//  List<String> paramObjects;

  var networkStatus = NetworkStatus.ONLINE;

  @override
  Widget build(BuildContext context) {
    if (topGames == null){
      topGames = [];
      updateTopGames();
    }
//    if (paramObjects == null){
//      paramObjects = [];
//      updateParamObjects();
//    }
    return Scaffold(
      appBar: AppBar(
        title: Text("Top 10 games"),
      ),
      body: Stack(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Center(
                  child: Text("TOP Requests"),
                ),
              ),
              Expanded(
                flex: 4,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.blueAccent, width: 5.0),
                        borderRadius: BorderRadius.circular(15.0)
                    ),
                    child: ListView.builder(
                        itemCount: topGames.length,
                        itemBuilder: (BuildContext ctx, int position){
                          return ListTile(
                            title: Text(topGames[position].name),
                            subtitle: Row(
                              children: <Widget>[
                                Text("Size: " + topGames[position].size.toString()),
                                SizedBox(width: 10,),
                                Text("Status: " + topGames[position].status),
                              ],
                            ),
                            trailing: Text(
                              "Score: " + topGames[position].popularityScore.toString(),
                              style: TextStyle(color: Colors.grey),
                            ),
                          );
                        }
                    ),
                  ),
                ),
              ),
            ],
          ),
          (networkStatus == NetworkStatus.LOADING) ?
          LoadingPage("Loading") :
          (networkStatus == NetworkStatus.DELETING) ?
          LoadingPage("Deleting") :
          Container()
        ],
      )
    );
  }

  updateTopGames(){
    setState(() {
      networkStatus = NetworkStatus.LOADING;
    });
    service.getTopGames().then((_result){
      setState(() {
        networkStatus = NetworkStatus.ONLINE;
        _result.sort((r1, r2) => _compareByPopularityScore(r1, r2));
        int start = 0;
        int end = (10 < _result.length) ? 10 : (_result.length);
        _result = _result.sublist(start, end);
        print(_result);
        this.topGames = _result;
      });
    }).catchError((err){
      Toaster.showToast("Error while updating top games!");
      setState(() {
        networkStatus = NetworkStatus.OFFLINE;
      });
    });
  }

  _compareByPopularityScore(Game r1, Game r2){
    return r2.popularityScore - r1.popularityScore;
  }


}