import 'package:xopa_app/repository/models/serializable.dart';

class Message implements Serializable<Message> {
  String timestamp;
  String conversationId;
  String fromId;
  String fromName;
  String fromProfilePicture;
  String message;

  Message({
    this.timestamp,
    this.conversationId,
    this.fromId,
    this.fromName,
    this.fromProfilePicture,
    this.message,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      'timestamp': timestamp,
      'conversation_id': conversationId,
      'from_id': fromId,
      'from_name': fromName,
      'from_profile_picture': fromProfilePicture,
      'message': message,
    };
  }

  @override
  Message fromJson(Map<String, dynamic> json) {
    timestamp = json['timestamp'];
    conversationId = json['conversation_id'];
    fromId = json['from_id'];
    fromName = json['from_name'];
    fromProfilePicture = json['from_profile_picture'];
    message = json['message'];
    return this;
  }
}
