import 'package:xopa_app/repository/models/interests/interest.dart';
import 'package:xopa_app/repository/models/serializable.dart';

class UsersInterest extends Serializable<UsersInterest> {
  String id;
  String name;
  bool seeking;
  String comment;

  UsersInterest({
    this.id,
    this.name,
    this.seeking,
    this.comment,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'seeking': seeking,
      'comment': comment,
    };
  }

  @override
  UsersInterest fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    seeking = json['seeking'];
    comment = json['comment'];
    return this;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  bool operator ==(other) {
    if(other is! Interest && other is! UsersInterest && other) return false;
    return id == other.id;
  }
}
