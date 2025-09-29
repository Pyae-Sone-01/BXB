class LeagueModel {
  int? id;
  String? name;

  LeagueModel({this.id, this.name});

  LeagueModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }
}
