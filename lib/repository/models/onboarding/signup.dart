import 'package:xopa_app/repository/models/serializable.dart';

class Signup extends Serializable<Signup> {
  String name;
  String email;
  String username;
  String password;

  Signup({
    this.name,
    this.email,
    this.username,
    this.password,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'username': username,
      'password': password,
    };
  }

  @override
  Signup fromJson(Map<String, dynamic> json) {
    name = json['name'];
    email = json['email'];
    username = json['username'];
    password = json['password'];
    return this;
  }
}
