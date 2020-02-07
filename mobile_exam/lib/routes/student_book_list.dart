
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile_exam/model/Book.dart';
import 'package:mobile_exam/rest/requests.dart';
import 'package:mobile_exam/routes/student_add_book.dart';

class BookList extends StatefulWidget{

  final String studentName;

  BookList(this.studentName);

  @override
  State<StatefulWidget> createState() => BookListState(this.studentName);
}

class BookListState extends State<BookList>{

  Future<List<Book>> bookList;
  final String studentName;
  
  BookListState(this.studentName);
  
  @override
  Widget build(BuildContext context) {
    if(BookList == null){
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
        future: getBooksByStudentName(this.studentName),
        builder: (BuildContext context, AsyncSnapshot<List<Book>> snapshot){
          if(!snapshot.hasData) return Center(child:CircularProgressIndicator());
          return ListView(
            children: snapshot.data
                .map((book) => ListTile(
                title: Text(book.title),
                subtitle: Text(book.status),
                leading: CircleAvatar(
                  backgroundColor: Colors.grey,
                  child: Text(book.title[0]),
                ),
            )).toList(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: (){
          goToAddModel();
        },
      ),
    );


  }

  void updateListView(){
    setState(() {
      this.bookList = getBooksByStudentName(this.studentName);
    });
  }

  void goToAddModel() async {
    Book toBeAdded = await Navigator.push(context, MaterialPageRoute(builder: (context){
      return StudentAddBook(this.studentName);
    })) as Book;

    if(toBeAdded == null) return;

    addBook(toBeAdded);
    this.updateListView();
  }

  void moveBack(){
    Navigator.pop(context);
  }
}