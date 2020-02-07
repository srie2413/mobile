
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile_exam/routes/student_book_list.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Route1 extends StatefulWidget{

  @override
  State<StatefulWidget> createState() => Route1State();
}

class Route1State extends State {

  TextEditingController nameController = new TextEditingController();
  bool isNameSelected;
  String studentName;

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme
        .of(context)
        .textTheme
        .title;
    this.isNameSelected = false;
    getstudentName();

    if(studentName != null){
      this.isNameSelected = true;
    }

    return Scaffold(
        appBar: AppBar(
            title: Text('Client'),
            leading: IconButton(icon: Icon(
                Icons.arrow_back),
                onPressed: () {
                  moveBack();
                }
            )),
        body: Padding(
          padding: EdgeInsets.only(top: 5.0),
          child: Center(
              child: Column(
                children: <Widget>[
                  TextField(
                    controller: nameController,
                    style: textStyle,
                    decoration: InputDecoration(
                        labelText: 'Name',
                        labelStyle: textStyle,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0)
                        )
                    ),
                  ),
                  Center(
                    child: Row(
                      children: <Widget>[
                        RaisedButton(
                            color: Colors.blueGrey,
                            textColor: Colors.orangeAccent,
                            child: Text('Select'),
                            onPressed: isNameSelected ? null : saveIdLocally
                        ),
                        RaisedButton(
                            color: Colors.blueGrey,
                            textColor: Colors.orangeAccent,
                            child: Text('My Books'),
                            onPressed: isNameSelected ? showModelListView : null
                        ),
                      ],
                    ),
                  )
                ],
              )
          ),
        )
    );
  }

  void moveBack() {
    Navigator.pop(context);
  }

  void saveIdLocally() {
    setState(() {
      isNameSelected = true;
      var name = nameController.text;
      this.saveInPreferences(name);
    });
  }

  void showModelListView() async{
    await Navigator.push(context, MaterialPageRoute(
        builder:(context){
          return BookList(this.nameController.text);
        }
    ));
  }

  void saveInPreferences(String name) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('studentName', name);
  }

  void getstudentName() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      var result = prefs.getString('studentName');
      if(result != null){
        this.studentName = result;
        this.nameController.text = studentName.toString();
      }
    });

  }
}