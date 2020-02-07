import 'package:quiver/core.dart';

class Game {
  int id;
  String name;
  String status;
  String user;
  int size;
  int popularityScore;

  Game(this.name, this.status, this.user, this.size, this.popularityScore);

  Game.withId(this.id, this.name, this.status, this.user, this.size, this.popularityScore);

  Game.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        status = json['status'],
        user = json['user'],
        size = json['size'],
        popularityScore = json['popularityScore'];

  Map<String, dynamic> toMap(){
    var map = Map<String, dynamic>();
    map['id'] = id;
    map['name'] = name;
    map['status'] = status;
    map['user'] = user;
    map['size'] = size;
    map['popularityScore'] = popularityScore;
    return map;
  }

  Game.fromMap(Map<String, dynamic> map){
    this.id = map['id'];
    this.name = map['name'];
    this.status = map['status'];
    this.user = map['user'];
    this.size = map['size'];
    this.popularityScore = map['popularityScore'];
  }

  Game.fromDbMap(Map<String, dynamic> map){
    this.id = map['requestId'];
    this.name = map['requestName'];
    this.status = map['status'];
    this.user = map['user'];
    this.size = map['size'];
    this.popularityScore = map['popularityScore'];
  }

  @override
  String toString() {
    return "Game{id=$id,name=$name,status=$status,user=$user,size=$size,popularityScore=$popularityScore}";
  }

  bool operator ==(e) => (e is Game) && (e.id == id);
  int get hashCode => hash2(id.hashCode, name.hashCode);
}