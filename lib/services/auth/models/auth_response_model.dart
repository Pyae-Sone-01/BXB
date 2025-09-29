import 'package:bxb/services/user/models/user_model.dart';

class AuthResponseModel {
  String? token;
  UserModel? user;

  AuthResponseModel({this.token, this.user});

  AuthResponseModel.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    user = json['user'] != null ? UserModel.fromJson(json['user']) : null;
  }
}
