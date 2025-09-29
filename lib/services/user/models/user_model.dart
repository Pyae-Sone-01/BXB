class UserModel {
  int? id;
  String? name;
  String? email;
  String? phone;
  int? coins;
  bool? canUpdateAgent;
  String? agent;
  bool? updatedPin;

  UserModel(
      {this.id,
      this.name,
      this.email,
      this.phone,
      this.coins,
      this.canUpdateAgent,
      this.agent,
      this.updatedPin});

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    coins = json['coins'];
    canUpdateAgent = json['can_update_agent'];
    agent = json['agent'];
    updatedPin = json['updated_pin'];
  }
}
