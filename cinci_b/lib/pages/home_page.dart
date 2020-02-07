import 'package:cinci_b/pages/selection/selection_page.dart';
import 'package:cinci_b/pages/selection/to_selection_page.dart';
import 'package:cinci_b/pages/status/top_page.dart';
import 'package:cinci_b/pages/user/add_user.dart';
import 'package:cinci_b/pages/user/user_page.dart';
import 'package:cinci_b/util/network_status.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {

  final TextStyle style = TextStyle(
      fontSize: 36.0,
      color: Colors.blueAccent,
      fontWeight: FontWeight.bold
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: RaisedButton(
                  color: Colors.deepOrangeAccent,
                  child: Text(
                    "User",
                    style: style,
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0)
                  ),
                  onPressed: (){
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AddUserPage())
                    );
                  }
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: RaisedButton(
                  color: Colors.deepPurpleAccent,
                  child: Text(
                    "Selection",
                    style: style,
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0)
                  ),
                  onPressed: () async {
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => PreSelectionPage())
                    );

                  }
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: RaisedButton(
                  color: Colors.greenAccent,
                  child: Text(
                    "Status",
                    style: style,
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0)
                  ),
                  onPressed: () async {
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => TopPage())
                    );

                  }
              ),
            ),
          )
        ],
      ),
    );
  }

}