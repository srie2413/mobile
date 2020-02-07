
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile_exam/model/Book.dart';

class StudentAddBook extends StatefulWidget{

  final String studentName;

  StudentAddBook(this.studentName);

  @override
  State<StatefulWidget> createState() => StudentAddBookState(this.studentName);
}

class StudentAddBookState extends State<StudentAddBook>{

  Book book = new Book("", "", "", 0, 0);
  String studentName;

  StudentAddBookState(this.studentName);

  var titleController = TextEditingController();
  var statusController = TextEditingController();
  var pagesController = TextEditingController();
  var usedCountController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    TextStyle textStyle = Theme
        .of(context)
        .textTheme
        .title;

    return WillPopScope(
      onWillPop: (){
        this.book = null;
        this.moveBack();
        return null;
      },

      child: Scaffold(
        appBar: AppBar(
          title: Text('Add Book'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: (){
              this.book = null;
              this.moveBack();
            },
          ),
        ),
        body: Center(
          child: Padding(
            padding: EdgeInsets.only(top: 10.0),
            child: Column(
              children: <Widget>[
                TextField(
                  controller: titleController,
                  style: textStyle,
                  decoration: InputDecoration(
                      labelText: 'Title',
                      labelStyle: textStyle,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0)
                      )
                  ),
                ),
                TextField(
                  controller: statusController,
                  style: textStyle,
                  decoration: InputDecoration(
                      labelText: 'Status',
                      labelStyle: textStyle,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0)
                      )
                  ),
                ),
                TextField(
                  controller: pagesController,
                  style: textStyle,
                  decoration: InputDecoration(
                      labelText: 'Pages',
                      labelStyle: textStyle,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0)
                      )
                  ),
                ),
                TextField(
                  controller: usedCountController,
                  style: textStyle,
                  decoration: InputDecoration(
                      labelText: 'Used Count',
                      labelStyle: textStyle,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0)
                      )
                  ),
                ),
                RaisedButton(
                  child: Text('Add'),
                  onPressed: (){
                    this.book.title = titleController.text;
                    this.book.status = statusController.text;
                    this.book.pages = int.parse(pagesController.text);
                    this.book.usedCount = int.parse(usedCountController.text);
                    this.book.studentName = this.studentName;
                    this.moveBack();
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void moveBack(){
    Navigator.pop(context, this.book);
  }
}