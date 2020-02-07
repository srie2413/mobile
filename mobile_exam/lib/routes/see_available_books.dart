
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile_exam/model/Book.dart';
import 'package:mobile_exam/rest/requests.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AvailableBooks extends StatefulWidget{


  @override
  State<StatefulWidget> createState() => AvailableBooksState();
}

class AvailableBooksState extends State<AvailableBooks>{

  Future<List<Book>> bookList;

  @override
  Widget build(BuildContext context) {
    if(bookList == null){
      updateListView();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Client Models'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: (){
            moveBack();
          },
        ),
      ),

      body: FutureBuilder<List<Book>>(
        future: getAvailableBooks(),
        builder: (BuildContext context, AsyncSnapshot<List<Book>> snapshot){
          if(!snapshot.hasData) return Center(child:CircularProgressIndicator());
          return ListView(
            children: snapshot.data
                .map((book) => ListTile(
              title: Text(book.title),
              subtitle: Text(book.pages.toString()),
              leading: CircleAvatar(
                backgroundColor: Colors.grey,
                child: Text(book.usedCount.toString()),
              ),
            onTap: (){
                borrow(book);
            },
            )).toList(),
          );
        },
      ),
    );


  }

  void updateListView(){
    setState(() {
      this.bookList = getAvailableBooks();
    });
  }

  void moveBack(){
    Navigator.pop(context);
  }

  void borrow(Book book) async {
    final prefs = await SharedPreferences.getInstance();
    borrowBook(book.id.toString(), prefs.getString('studentName'));
    updateListView();
  }
}