import 'package:xopa_app/repository/models/serializable.dart';

class UserAndInterest extends Serializable<UserAndInterest> {
  String userId;
  String name;
  String profilePicture;
  bool seeking;
  String comment;

  UserAndInterest({
    this.userId,
    this.name,
    this.profilePicture,
    this.seeking,
    this.comment,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'name': name,
      'profile_picture': profilePicture,
      'seeking': seeking,
      'comment': comment,
    };
  }

  @override
  UserAndInterest fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    name = json['name'];
    profilePicture = json['profile_picture'];
    seeking = json['seeking'];
    comment = json['comment'];
    return this;
  }
}
