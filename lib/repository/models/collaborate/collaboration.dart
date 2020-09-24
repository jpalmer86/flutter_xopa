import 'dart:convert';

import 'package:xopa_app/repository/models/portfolio/portfolio.dart';
import 'package:xopa_app/repository/models/serializable.dart';

class Collaboration extends Serializable<Collaboration> {
  String id;
  String name;
  List<Portfolio> users;
  String conversationId;

  Collaboration({
    this.id,
    this.name,
    this.users,
    this.conversationId,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'users': jsonEncode(users?.map((user) => user.toJson())?.toList()),
      'conversation_id': conversationId,
    };
  }

  @override
  Collaboration fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    users = jsonDecodeList(() => Portfolio(), json['users']);
    conversationId = json['conversation_id'];
    return this;
  }
}
