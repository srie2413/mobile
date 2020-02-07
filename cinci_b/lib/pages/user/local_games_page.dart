import 'package:cinci_b/model/game.dart';
import 'package:cinci_b/persistence/database_helper.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

class LocalGamesPage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => _LocalGamesPageState();

}

class _LocalGamesPageState extends State<LocalGamesPage> {

  DatabaseHelper databaseHelper = DatabaseHelper();

  List<Game> localGames;

  @override
  Widget build(BuildContext context) {
    if (localGames == null){
      localGames = [];
      _updateLocalGames();
    }
    return Scaffold(
      appBar: AppBar(
        title: Text("Local games"),
      ),
      body: ListView.builder(
          itemCount: (localGames != null) ? localGames.length : 0,
          itemBuilder: (BuildContext ctx, int position){
            return ListTile(
              leading: Text(
                localGames[position].id.toString(),
                style: TextStyle(
                    color: Colors.grey
                ),
              ),
              title: Text(localGames[position].name),
            );
          }
      ),
    );
  }

  void _updateLocalGames(){
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((_){
      Future<List<Game>> localGamesFuture = databaseHelper.getGames();
      localGamesFuture.then((res){
        setState(() {
          this.localGames = res;
        });
      }).catchError((err){
        setState(() {
          this.localGames = [];
        });
      });
    });
  }
}