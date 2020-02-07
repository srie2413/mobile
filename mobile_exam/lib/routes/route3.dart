
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile_exam/model/Book.dart';
import 'package:mobile_exam/rest/requests.dart';

class Route3 extends StatefulWidget{

  @override
  State<StatefulWidget> createState() => Route3State();
}

class Route3State extends State{

  Future<List<Book>> sortedBooks;
  @override
  Widget build(BuildContext context){
    if(sortedBooks == null){
      this.updateListView();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Route 3'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: (){
            moveBack();
          },
        ),
      ),
      body: FutureBuilder<List<Book>>(
        future: getSortedBooks(),
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
            )).toList(),
          );
        },
      ),
    );
  }

  void updateListView() {
    setState(() {
      this.sortedBooks = getSortedBooks();
    });
  }

  void moveBack(){
    Navigator.pop(context);
  }
}