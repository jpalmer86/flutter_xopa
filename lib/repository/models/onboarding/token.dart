import 'package:xopa_app/repository/models/serializable.dart';

class Token extends Serializable<Token> {
    String userId;
    String token;

    Token({this.userId, this.token});

    @override
    Map<String, dynamic> toJson() {
      return {
        'user_id': userId,
        'token': token,
      };
    }

    @override
    Token fromJson(Map<String, dynamic> json) {
      userId = json['userId'];
      token = json['token'];
      return this;
    }

}