import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_exam_variant/database.dart';
import 'package:flutter_exam_variant/model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';
import 'serverCom.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.deepPurple,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int clientId;
  var modelController = new TextEditingController();
  var timeController = new TextEditingController();
  var costController = new TextEditingController();
  var idController = new TextEditingController();
  var statusController = new TextEditingController();
  DatabaseProvider dbProvider = new DatabaseProvider();
  ServerCom serverCom = new ServerCom();
  bool retrieved = false;


  Future<bool> checkConnection() async {
    var result = await Connectivity().checkConnectivity();
    if(result == ConnectivityResult.wifi) {
      return true;
    }
    return false;
  }
//----------------------------- CLIENT -----------------------------------------
  Future<List<Model>> retrieveItems() async{
    retrieved = true;
    List<Model> lis = await serverCom.getModelsForClient(clientId);
    for(Model m in lis){
      dbProvider.insertModel(m);
    }
    return lis;
  }

  Future<List<Model>> getItems() async {
    if(!retrieved){
      return retrieveItems();
    }
    else{
      if(await checkConnection()){
        return await serverCom.getModelsForClient(clientId);
      }
      else{
        return await dbProvider.getModelsForClient(clientId);
      }
    }
  }

  Widget buildList() {
    return FutureBuilder(
        builder: (builder, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          List<Model> items = snapshot.data;
          return new ListView.builder(
              itemBuilder: (context, index) {
                if (index < items.length) {
                  return buildItem(items[index]);
                } else {
                  return null;
                }
              }
          );
        },
        future: getItems()
    );
  }

  Widget buildItem(Model model) {
    return new ListTile(
      title: new Text(model.id.toString() + " " + model.model + " " + model.status + " " + model.time.toString() + " " + model.cost.toString(), style: TextStyle(fontWeight: FontWeight.bold))
    );
  }

  void retryClientModelScreen(){
    Navigator.of(context).pop();
    clientModelsScreen();
  }

  void clientModelsScreen() async{
    if(!retrieved && await checkConnection()==false) {
      Navigator.of(context).push(
          new MaterialPageRoute(
              builder: (context) {
                return new Scaffold(
                    appBar: new AppBar(
                        title: new Text("Models for client $clientId")
                    ),
                    body: Center(
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children:<Widget>
                            [
                              Text("Connect to the internet and try again"),
                              FlatButton(
                              onPressed: retryClientModelScreen,
                              child: Text('RETRY')
                    )]
                        )
                    )
                );
              }
          )
      );
    }
    else{
      Navigator.of(context).push(
          new MaterialPageRoute(
              builder: (context) {
                return new Scaffold(
                    appBar: new AppBar(
                        title: new Text("Models for client $clientId")
                    ),
                    body: buildList()
                );
              }
          )
      );
    }
  }

  void addModel(String model, String time, String cost) async{
    if(await checkConnection()) {
      serverCom.addModel(new Model(id: -1,
          model: model,
          status: 'ordered',
          client: clientId,
          time: int.parse(time),
          cost: int.parse(cost)));
      dbProvider.insertModel(new Model(id: -1,
          model: model,
          status: 'ordered',
          client: clientId,
          time: int.parse(time),
          cost: int.parse(cost)));
    }
    else{
      dbProvider.insertModel(new Model(id: -1,
          model: model,
          status: 'ordered',
          client: clientId,
          time: int.parse(time),
          cost: int.parse(cost)));
    }
    Navigator.of(context).pop();
    Navigator.of(context).push(
        new MaterialPageRoute(
            builder: (context) {
              return new Scaffold(
                appBar: new AppBar(
                    title: new Text("Model")
                ),
                body: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Your order:',
                      ),
                      Text(
                        '$model',
                      ),
                      Text(
                        '$time',
                      ),
                      Text(
                        '$cost',
                      ),
                      FlatButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text('BACK'),
                      ),
                    ],
                  ),
                ),
              );
            }
        )
    );
  }

  void addModelScreen() async{
    Navigator.of(context).push(
        new MaterialPageRoute(
            builder: (context) {
              return new Scaffold(
                appBar: new AppBar(
                    title: new Text("Add model")
                ),
                body: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Add a model',
                      ),
                      new TextField(autofocus: true,
                          controller: modelController,
                          decoration: new InputDecoration(
                              hintText: "Model",
                              contentPadding: const EdgeInsets.all(16.0))),
                      new TextField(autofocus: true,
                          controller: timeController,
                          decoration: new InputDecoration(
                              hintText: "Time",
                              contentPadding: const EdgeInsets.all(16.0))),
                      new TextField(autofocus: true,
                          controller: costController,
                          decoration: new InputDecoration(
                              hintText: "Cost",
                              contentPadding: const EdgeInsets.all(16.0))),
                      FlatButton(
                        onPressed: () => addModel(modelController.text.toString(),timeController.text.toString(),costController.text.toString()),
                        child: Text('ADD'),
                      ),
                    ],
                  ),
                ),
              );
            }
        )
    );
  }


  void prepareAddModels(){
    modelController.clear();
    timeController.clear();
    costController.clear();
    addModelScreen();
  }

  void clientScreen() async{
    Navigator.of(context).push(
        new MaterialPageRoute(
            builder: (context) {
              return new Scaffold(
                  appBar: new AppBar(
                      title: new Text("Client $clientId")
                  ),
                body: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Choose an action',
                      ),
                      FlatButton(
                        onPressed: prepareAddModels,
                        child: Text('Add model'),
                      ),
                      FlatButton(
                        onPressed: clientModelsScreen,
                        child: Text('View models'),
                      ),
                    ],
                  ),
                ),
              );
            }
        )
    );
  }


  int generateId(){
    var rng = new Random();
    return rng.nextInt(5);
  }

  void openClient() async{
    final prefs = await SharedPreferences.getInstance();
    clientId = await prefs.getInt('clientId') ?? generateId();
    prefs.setInt('clientId', clientId);
    clientScreen();
  }

//----------------------------- EMPLOYEE ---------------------------------------

  void editModel(String id, String status) async {
    if (await checkConnection()) {
      serverCom.editModel(int.parse(id), status);
    }
    Navigator.of(context).pop();
  }

  void editModelScreen() async{
    Navigator.of(context).push(
        new MaterialPageRoute(
            builder: (context) {
              return new Scaffold(
                appBar: new AppBar(
                    title: new Text("Edit order")
                ),
                body: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Edit an order',
                      ),
                      new TextField(autofocus: true,
                          controller: idController,
                          decoration: new InputDecoration(
                              hintText: "ID",
                              contentPadding: const EdgeInsets.all(16.0))),
                      new TextField(autofocus: true,
                          controller: statusController,
                          decoration: new InputDecoration(
                              hintText: "Status",
                              contentPadding: const EdgeInsets.all(16.0))),
                      FlatButton(
                        onPressed: () => editModel(idController.text.toString(), statusController.text.toString()),
                        child: Text('EDIT'),
                      ),
                    ],
                  ),
                ),
              );
            }
        )
    );
  }

  void prepareEditModels(){
    idController.clear();
    statusController.clear();
    editModelScreen();
  }

  void employeeScreen() async{
    Navigator.of(context).push(
        new MaterialPageRoute(
            builder: (context) {
              return new Scaffold(
                appBar: new AppBar(
                    title: new Text("Employee")
                ),
                body: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      FlatButton(
                        onPressed: prepareEditModels,
                        child: Text('Edit model'),
                      ),
                    ],
                  ),
                ),
              );
            }
        )
    );
  }

//----------------------------- MANAGER ----------------------------------------

  Future<List<Model>> getItemsManager() async {
    List<Model> lis = await serverCom.getAllModels();
    lis.sort((a,b) => b.cost.compareTo(a.cost));
    return lis;
  }

  Future<List<Model>> getFiveMostExpensive() async {
    List<Model> lis = await getItemsManager();
    List<Model> five = [];
    for(int i = 0; i < 5; i++){
      five.add(lis[i]);
    }
    return five;
  }

  Widget buildItemManager(Model model) {
    return new ListTile(
        title: new Text(model.model + " " + model.cost.toString(), style: TextStyle(fontWeight: FontWeight.bold))
    );
  }

  Widget buildListManager() {
    return FutureBuilder(
        builder: (builder, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          List<Model> items = snapshot.data;
          return new ListView.builder(
              itemBuilder: (context, index) {
                if (index < items.length) {
                  return buildItemManager(items[index]);
                } else {
                  return null;
                }
              }
          );
        },
        future: getItemsManager()
    );
  }

  Widget buildListFive() {
    return FutureBuilder(
        builder: (builder, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          List<Model> items = snapshot.data;
          return new ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                if (index < items.length) {
                  return buildItemManager(items[index]);
                } else {
                  return null;
                }
              }
          );
        },
        future: getFiveMostExpensive()
    );
  }

  void mostExpensive() async {
    if (await checkConnection() == true) {
      Navigator.of(context).push(
          new MaterialPageRoute(
              builder: (context) {
                return new Scaffold(
                    appBar: new AppBar(
                        title: new Text("Most expensive models")
                    ),
                    body: buildListManager()
                );
              }
          )
      );
    }
  }

  void managerScreen() async{
    Navigator.of(context).push(
        new MaterialPageRoute(
            builder: (context) {
              return new Scaffold(
                appBar: new AppBar(
                    title: new Text("Manager")
                ),
                body: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      buildListFive(),
                      FlatButton(
                        onPressed: mostExpensive,
                        child: Text('View all'),
                      ),
                    ],
                  ),
                ),
              );
            }
        )
    );
  }

  @override
  Widget build(BuildContext context){

    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Choose user type',
            ),
        FlatButton(
          onPressed: openClient,
          child: Text('Client'),
        ),
        FlatButton(
          onPressed: employeeScreen,
          child: Text('Employee'),
        ),
        FlatButton(
          onPressed: managerScreen,
          child: Text('Manager'),
            ),
        ],
        ),
      ),// This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
