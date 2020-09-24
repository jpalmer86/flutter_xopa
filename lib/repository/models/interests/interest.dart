import 'package:xopa_app/repository/models/interests/users_interest.dart';
import 'package:xopa_app/repository/models/serializable.dart';

class Interest extends Serializable<Interest> {
  String id;
  String name;
  int count;

  Interest({this.id, this.name, this.count});

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'count': count,
    };
  }

  @override
  Interest fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    count = json['count'] ?? 0;
    return this;
  }

  UsersInterest toUserInterest() {
    return UsersInterest(
      id: id,
      name: name,
      seeking: false,
      comment: '',
    );
  }

  @override
  bool operator ==(other) {
    if(other is! Interest && other is! UsersInterest) return false;
    return id == other?.id;
  }

  @override
  int get hashCode => id.hashCode;
}
