import 'package:xopa_app/repository/models/serializable.dart';

class SocialMedia extends Serializable<SocialMedia> {
    String facebookUsername;
    String linkedinUsername;
    String twitterUsername;

    SocialMedia({this.facebookUsername, this.linkedinUsername, this.twitterUsername});

    @override
    Map<String, dynamic> toJson() {
      return {
        'facebook_username': facebookUsername,
        'linkedin_username': linkedinUsername,
        'twitter_username': twitterUsername,
      };
    }

    @override
    SocialMedia fromJson(Map<String, dynamic> json) {
      facebookUsername = json['facebook_username'];
      linkedinUsername = json['linkedin_username'];
      twitterUsername = json['twitter_username'];
      return this;
    }

}