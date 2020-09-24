import 'package:xopa_app/repository/models/serializable.dart';

class Conversation extends Serializable<Conversation> {
    String id;
    String name;
    List<String> profilePictures;
    String latestTimestamp;
    String latestMessage;


    Conversation({this.id, this.name});

    @override
    Map<String, dynamic> toJson() {
      return {
        'id': id,
        'name': name,
        'profile_pictures': profilePictures.join(','),
        'latest_timestamp': latestTimestamp,
        'latest_message': latestMessage,
      };
    }

    @override
    Conversation fromJson(Map<String, dynamic> json) {
      id = json['id'];
      name = json['name'];
      profilePictures = json['profile_pictures']?.split(',');
      latestTimestamp = json['latest_timestamp'];
      latestMessage = json['latest_message'];
      return this;
    }

}