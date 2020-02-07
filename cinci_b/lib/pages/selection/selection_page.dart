
import 'package:cinci_b/model/game.dart';
import 'package:cinci_b/persistence/database_helper.dart';
import 'package:cinci_b/persistence/main_service.dart';
import 'package:cinci_b/util/logger.dart';
import 'package:cinci_b/util/network_status.dart';
import 'package:cinci_b/util/toaster.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:sqflite/sqflite.dart';

import '../loading_page.dart';

class SelectionPage extends StatefulWidget{

  @override
  State<StatefulWidget> createState() => _SelectionPageState();

}

class _SelectionPageState extends State<SelectionPage> {
  Logger logger = Logger('SelectionPage');

  DatabaseHelper databaseHelper = DatabaseHelper();
  MainService service = MainService();

  List<Game> selections;
  int networkStatus = NetworkStatus.ONLINE;

  @override
  Widget build(BuildContext context) {
    if (selections == null){
      selections = [];
      _updateSelections();
    }
    return Scaffold(
      body: Stack(
        children: <Widget>[
          ListView.builder(
              itemCount: (selections != null) ? selections.length : 0,
              itemBuilder: (BuildContext ctx, int position){
                return ListTile(
                  title: Text(selections[position].name),
                  subtitle: Row(
                    children: <Widget>[
                      Text("Size: " + selections[position].size.toString()),
                      SizedBox(width: 10,),
                      Text("Popularity score: " + selections[position].popularityScore.toString())
                    ],
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.check_circle),
                    onPressed: () => _borrow(selections[position]),
                  ),
                );
              }
          ),
          (networkStatus == NetworkStatus.LOADING) ?
          LoadingPage("Loading") :
          Container()
        ],
      ),
    );
  }

//  void _updateRequests(){
//    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
//    dbFuture.then((_){
//      Future<List<Request>> requestsFuture = databaseHelper.getRequests();
//      requestsFuture.then((res){
//        setState(() {
//          requests = res;
//        });
//      });
//    }).catchError((err){
//      setState(() {
//        requests = [];
//      });
//    });
//  }

  void _updateSelections(){
    service.getSelections().then((_result){
      setState(() {
        this.selections = _result;
      });
    }).catchError((err){
      logger.debug("Could not get selections");
      Toaster.showToast("Could not get selections");
    });
  }

  void _borrow(Game game) async {
    setState(() {
      networkStatus = NetworkStatus.LOADING;
    });
    var result = await service.borrowGame(game.id).then((_res){
      setState(() {
        networkStatus = NetworkStatus.ONLINE;
        //this.selections.remove(game);
      });
      final Future<Database> dbFuture = databaseHelper.initializeDatabase();
      dbFuture.then((_){
        databaseHelper.addGame(game);
      }).catchError((err){
        Toaster.showToast("Could not save into DB");
      });
    }).catchError((err){
      Toaster.showToast("Error while borrowing the game!");
      setState(() {
        networkStatus = NetworkStatus.OFFLINE;
      });
    });
  }

}