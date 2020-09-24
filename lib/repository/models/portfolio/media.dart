import 'package:xopa_app/repository/models/serializable.dart';

class Media extends Serializable<Media> {
  String id;
  MediaType mediaType;
  String mediaUrl;
  String thumbnailUrl;
  String permalink;
  String username;
  DateTime timestamp;
  String caption;
  List<Media> children;

  Media({
    this.id,
    this.mediaType,
    this.mediaUrl,
    this.thumbnailUrl,
    this.permalink,
    this.username,
    this.timestamp,
    this.caption,
    this.children,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'media_type': _mediaTypeToJson(mediaType),
      'media_url': mediaUrl,
      'thumbnail_url': thumbnailUrl,
      'permalink': permalink,
      'username': username,
      'timestamp': timestamp.toIso8601String(),
      'caption': caption,
      'children': {
        'data': children?.map((c) => c.toJson())?.toList(),
      },
    };
  }

  @override
  Media fromJson(Map<String, dynamic> json) {
    id = json['id'];
    mediaType = _mediaTypeFromJson(json['media_type']);
    mediaUrl = json['media_url'];
    thumbnailUrl = json['thumbnail_url'];
    permalink = json['permalink'];
    username = json['username'];
    timestamp = DateTime.tryParse(json['timestamp']);
    caption = json['caption'];
    if(json['children'] != null) {
      children = jsonDecodeList(() => Media(), json['children']['data']);
    }
    return this;
  }

  @override
  bool operator ==(other) {
    return id == other?.id ?? '';
  }

  @override
  int get hashCode => id.hashCode;
}

enum MediaType { Image, Video, Album }

MediaType _mediaTypeFromJson(String json) {
  switch(json) {
    case 'IMAGE': return MediaType.Image;
    case 'VIDEO': return MediaType.Video;
    case 'CAROUSEL_ALBUM': return MediaType.Album;
    default: return null;
  }
}

String _mediaTypeToJson(MediaType type) {
  switch(type) {
    case MediaType.Image: return 'IMAGE';
    case MediaType.Video: return 'VIDEO';
    case MediaType.Album: return 'CAROUSEL_ALBUM';
    default: return null;
  }
}
