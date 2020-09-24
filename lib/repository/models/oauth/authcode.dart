import 'package:xopa_app/repository/models/serializable.dart';

class AuthCode extends Serializable<AuthCode> {
  String authCode;

  AuthCode(this.authCode);

  @override
  Map<String, dynamic> toJson() {
    return {
      'code': authCode,
    };
  }

  @override
  AuthCode fromJson(Map<String, dynamic> json) {
    authCode = json['code'];
    return this;
  }
}
