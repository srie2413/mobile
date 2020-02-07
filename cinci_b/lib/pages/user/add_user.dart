import 'dart:io';

import 'package:cinci_b/model/game.dart';
import 'package:cinci_b/pages/user/games_page.dart';
import 'package:cinci_b/pages/user/user_page.dart';
import 'package:cinci_b/persistence/main_service.dart';
import 'package:cinci_b/util/logger.dart';
import 'package:cinci_b/util/network_status.dart';
import 'package:cinci_b/util/toaster.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../loading_page.dart';

class AddUserPage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => _AddUserPageState();

}

class _AddUserPageState extends State<AddUserPage> {
  TextEditingController ctrlUser = new TextEditingController();
  String userName;

  Logger logger = Logger('AddUserPage');

  void getUser() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      var result = prefs.getString('user');
      if(result != null){
        this.userName = result;
        this.ctrlUser.text = userName.toString();
      }
    });

  }

  MainService service = MainService();

  int networkStatus = NetworkStatus.ONLINE;

  @override
  Widget build(BuildContext context) {
    getUser();
    return Scaffold(
      appBar: AppBar(
        title: Text("Enter username"),
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
                          controller: ctrlUser,
                          decoration: InputDecoration(
                            labelText: "User",
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
                    padding: const EdgeInsets.fromLTRB(4, 8, 4, 8),
                    child: RaisedButton(
                        color: Colors.lightBlueAccent,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "My games",
                              style: TextStyle(fontSize: 24),
                            ),
                          ],
                        ),
                        onPressed: (){
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => UserPage(userName: userName)),
                          );
                        }
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(4, 8, 4, 8),
                    child: RaisedButton(
                        color: Colors.lightGreenAccent,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "Save",
                              style: TextStyle(fontSize: 24),
                            ),
                            Icon(Icons.check, size: 24,)
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
          LoadingPage("Adding User") :
          Container()
        ],
      ),
    );
  }

  bool canSubmit(){
    // Check ctrl.text.length > 0
    return ctrlUser.text.length > 0;
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
    prefs.setString('user', ctrlUser.text);
    setState(() {
      networkStatus = NetworkStatus.ONLINE;
      userName = ctrlUser.text;
      logger.debug(userName);
    });
  }

}