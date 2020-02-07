import 'package:cinci_b/model/game.dart';
import 'package:cinci_b/persistence/main_service.dart';
import 'package:cinci_b/util/network_status.dart';
import 'package:cinci_b/util/toaster.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../loading_page.dart';

class AddGamePage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => _AddGamePageState();

}

class _AddGamePageState extends State<AddGamePage> {



  final TextEditingController ctrlName = TextEditingController();
  final TextEditingController ctrlStatus = TextEditingController();
  final TextEditingController ctrlSize = TextEditingController();
  final TextEditingController ctrlPopularityScore = TextEditingController();

  MainService service = MainService();

  int networkStatus = NetworkStatus.ONLINE;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add a new game"),
      ),
      body: Stack(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Expanded(
                  flex: 4,
                  child: ListView(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 5, bottom: 5),
                        child: TextField(
                          controller: ctrlName,
                          decoration: InputDecoration(
                            labelText: "Name",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 5, bottom: 5),
                        child: TextField(
                          controller: ctrlStatus,
                          decoration: InputDecoration(
                            labelText: "Status",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 5, bottom: 5),
                        child: TextField(
                          controller: ctrlSize,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: "Size",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 5, bottom: 5),
                        child: TextField(
                          controller: ctrlPopularityScore,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: "Popularity Score",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(8, 16, 8, 16),
                    child: RaisedButton(
                        color: Colors.lightGreenAccent,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "Save",
                              style: TextStyle(fontSize: 48),
                            ),
                            Icon(Icons.check, size: 48,)
                          ],
                        ),
                        onPressed: _save
                    ),
                  ),
                )
              ],
            ),
          ),
          (networkStatus == NetworkStatus.ADDING) ?
          LoadingPage("Adding game") :
          Container()
        ],
      ),
    );
  }

  bool canSubmit(){
    // Check ctrl.text.length > 0
    return ctrlName.text.length > 0 && ctrlSize.text.length > 0 &&
        ctrlPopularityScore.text.length > 0 && ctrlStatus.text.length > 0;
  }

  void _save() async {
    if (!canSubmit()){
      Toaster.showToast("Please enter all fields!");
      return;
    }
    setState(() {
      networkStatus = NetworkStatus.ADDING;
    });

    String user;
    final prefs = await SharedPreferences.getInstance();
    user = await prefs.getString('user');

    Game game = Game(ctrlName.text, ctrlStatus.text, user,
        int.parse(ctrlSize.text), int.parse(ctrlPopularityScore.text));

    await service.addGame(game).then((result){
      setState(() {
        networkStatus = NetworkStatus.ONLINE;
      });
      if (result){
        Navigator.pop(context, true);
      } else {
        Navigator.pop(context, false);
      }
    }).catchError((err){
      Toaster.showToast("Error while adding game!");
      setState(() {
        networkStatus = NetworkStatus.OFFLINE;
      });
    });
  }

}