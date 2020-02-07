
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile_exam/routes/see_available_books.dart';

class Route2 extends StatefulWidget{

  @override
  State<StatefulWidget> createState() => Route2State();
}

class Route2State extends State{

  @override
  Widget build(BuildContext context){

    return Scaffold(
      appBar: AppBar(
        title: Text('Route2'),
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: (){
              moveBack();
            },
        ),
      ),
      body: Center(
          child: Column(
            children: <Widget>[
              RaisedButton(
                  color: Colors.blueGrey,
                  textColor: Colors.orangeAccent,
                  child: Text('Get Available'),
                  onPressed: (){
                    moveToAvailable();
                  }
              )
            ],
          )
      )
    );
  }

  void moveBack(){
    Navigator.pop(context);
  }

  void moveToAvailable() async {
    await Navigator.push(context, MaterialPageRoute(
        builder:(context){
          return AvailableBooks();
        }
    ));
  }
}