import 'package:xopa_app/repository/models/portfolio/media.dart';
import 'package:xopa_app/repository/models/portfolio/social_media.dart';
import 'package:xopa_app/repository/models/serializable.dart';

class Portfolio extends Serializable<Portfolio> {
    String userId;
    String name;
    String bio;
    String profilePicture;
    bool public;
    String instagramUsername;
    SocialMedia socialMedia;
    List<Media> media;

    Portfolio({
      this.userId,
      this.name,
      this.bio,
      this.profilePicture,
      this.public,
      this.instagramUsername,
      this.socialMedia,
      this.media,
    });

    @override
    Map<String, dynamic> toJson() {
      return {
        'user_id': userId,
        'name': name,
        'bio': bio,
        'profile_picture': profilePicture,
        'public': public,
        'instagram_username': instagramUsername,
        'social_media': socialMedia?.toJson(),
        'media': media?.map((media) => media.toJson())?.toList(),
      };
    }

    @override
    Portfolio fromJson(Map<String, dynamic> json) {
      userId = json['user_id'];
      name = json['name'];
      bio = json['bio'];
      profilePicture = json['profile_picture'];
      public = json['public'];
      instagramUsername = json['instagram_username'];
      socialMedia = jsonDecode(() => SocialMedia(), json['social_media']);
      media = jsonDecodeList(() => Media(), json['media']);
      return this;
    }

}