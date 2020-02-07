import 'dart:convert';

import 'package:http/http.dart' as http;
import 'model.dart';

class ServerCom {
  String post = "http://192.168.100.4:2901/model";
  String postProcess = "http://192.168.100.4:2901/process";
  String get = "http://192.168.100.4:2901/models/";
  String getAll = "http://192.168.100.4:2901/all/";

  Future<bool> updateModel(Model model) async {
    Map<String, String> headers = {"Content-type": "application/json"};
    Map<String, dynamic> myJson = model.toMapNoId();

    try {
      final response = await http.put(
          post + model.id.toString(), headers: headers,
          body: json.encode(myJson));
      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<bool> addModel(Model model) async {
    Map<String, String> headers = {"Content-type": "application/json"};
    Map<String, dynamic> myJson = model.toMapNoId();

    try {
      final response = await http.post(
          post,
          headers: headers,
          body: json.encode(myJson));
      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<bool> editModel(int id, String status) async {
    Map<String, String> headers = {"Content-type": "application/json"};
    Map<String, dynamic> myJson = {"id":id, "status":status};

    try {
      final response = await http.post(
          postProcess,
          headers: headers,
          body: json.encode(myJson));
      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<List<Model>> getAllModels() async {
    Map<String, String> headers = {"Content-type": "application/json"};
    List<Model> lis = new List();
    try {
      final response = await http.get(
          getAll,
          headers: headers
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        List<dynamic> values=new List<dynamic>();
        values = json.decode(response.body);
        if(values.length>0) {
          for (int i = 0; i < values.length; i++) {
            if (values[i] != null) {
              Map<String, dynamic> map = values[i];
              lis.add(Model.fromMap(map));
            }
          }
        }
        return lis;
      } else {
        return lis;
      }
    } catch (e) {
      return lis;
    }
  }

  Future<List<Model>> getModelsForClient(int clientId) async {
    Map<String, String> headers = {"Content-type": "application/json"};
    List<Model> lis = new List();
    try {
      final response = await http.get(
        get+clientId.toString(),
        headers: headers
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        List<dynamic> values=new List<dynamic>();
        values = json.decode(response.body);
        if(values.length>0) {
          for (int i = 0; i < values.length; i++) {
            if (values[i] != null) {
              Map<String, dynamic> map = values[i];
              lis.add(Model.fromMap(map));
            }
          }
        }
        return lis;
      } else {
        return lis;
      }
    } catch (e) {
      return lis;
    }
  }

  Future<bool> sendData(List<Model> models) async {
    Map<String, String> headers = {"Content-type": "application/json"};
    for(Model model in models) {
      Map<String, dynamic> myJson = model.toMap();
      try {
        final response = await http.post(
            get, headers: headers,
            body: json.encode(myJson));
        if (response.statusCode == 200 || response.statusCode == 201) {
          continue;
        } else {
          return false;
        }
      } catch (e) {
        return false;
      }
    }
    return true;
  }
}