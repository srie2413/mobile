

import 'dart:convert';
import 'dart:developer';

import 'package:connectivity/connectivity.dart';
import 'package:mobile_exam/model/Book.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

String url = "http://172.30.118.252:2501/";
bool isConnected = false;

Future<List<Book>> getBooksByStudentName(String studentName) async {

  final prefs = await SharedPreferences.getInstance();
  await checkConnection();
  var models = prefs.getString('localBooks');

  if(!isConnected && models != null){
    List<dynamic> savedModels = jsonDecode(models);
    List<Book> toReturn = savedModels.map((dynamic item) => Book.fromJson(item)).toList();
    return toReturn;
  }

  while(await checkConnection()){
    http.Response response = await http.get(url + 'books/$studentName');
    if(response.statusCode == 200){
      prefs.setString('localBooks', response.body);
      log('books saved locally');
      List<dynamic> body = jsonDecode(response.body);
      List<Book> models = body.map((dynamic item) => Book.fromJson(item)).toList();
      print('books retreived');
      return models;
    }
    else{
      throw "Cannot get posts";
    }
  }
}

Future<bool> addBook(Book book) async {
  var body = jsonEncode(book.toJson());
  final prefs = await SharedPreferences.getInstance();

  var headers = {
    'Content-type' : 'application/json',
    'Accept': 'application/json',
  };

  if(await checkConnection()){
    http.Response response = await http.post( url + "book", body: body, headers: headers);
    if(response.statusCode == 200){
      log('book added');
      return true;
    }
  }
  else{
    String books = prefs.getString('localBooks');
    books += body;
    prefs.setString('localBooks', books);
  }



  return false;
}

Future<List<Book>> getAvailableBooks() async {
  http.Response response = await http.get(url + 'available');
  if(response.statusCode == 200){
    List<dynamic> body = jsonDecode(response.body);
    List<Book> models = body.map((dynamic item) => Book.fromJson(item)).toList();
    log('get available books');
    return models;
  }
  else{
    throw "Cannot get posts";
  }
}

Future<bool> borrowBook(String bookId, String studentName) async {
  var json = {
    "id" : bookId,
    "student" : studentName
  };

  var headers = {
    'Content-type' : 'application/json',
    'Accept': 'application/json',
  };

  var body = jsonEncode(json);
  http.Response response = await http.post(url + 'borrow', body: body, headers: headers);
  if(response.statusCode == 200){
    return true;
  }

  return false;
}

Future<List<Book>> getSortedBooks() async {

  http.Response response = await http.get(url + 'all');
  if(response.statusCode == 200){
    List<dynamic> body = jsonDecode(response.body);
    List<Book> models = body.map((dynamic item) => Book.fromJson(item)).toList();
    models.sort((a,b) => b.usedCount.compareTo(a.usedCount));
    log('retreived sorted books');
    return models;
  }
  else{
    throw "Cannot get posts";
  }
}

Future<bool> checkConnection() async {
  var connectivityResult = await (Connectivity().checkConnectivity());

  if (connectivityResult == ConnectivityResult.wifi) {
    if(!isConnected){
      isConnected = true;
//        synchronize();
    }
    return true;
  }

  isConnected = false;
  return false;
}