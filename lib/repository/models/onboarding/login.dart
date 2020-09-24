import 'package:xopa_app/repository/models/serializable.dart';

class Login extends Serializable<Login> {
    String username;
    String password;

    Login({this.username, this.password});

    @override
    Map<String, dynamic> toJson() {
      return {
        'username': username,
        'password': password,
      };
    }

    @override
    Login fromJson(Map<String, dynamic> json) {
      username = json['username'];
      password = json['password'];
      return this;
    }

}