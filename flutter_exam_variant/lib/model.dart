class Model {
  int id;
  String model;
  String status;
  int client;
  int time;
  int cost;

  Model({ this.id, this.model, this.status, this.client, this.time, this.cost });

  factory Model.fromMap(Map<String, dynamic> json) => new Model(
    id: json["id"],
    model: json["model"],
    status: json["status"],
    client: json["client"],
    time: json["time"],
    cost: json["cost"]
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "model": model,
    "status": status,
    "client": client,
    "time": time,
    "cost": cost
  };

  Map<String, dynamic> toMapNoId() => {
    "model": model,
    "status": status,
    "client": client,
    "time": time,
    "cost": cost
  };
}