import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:xopa_app/repository/models/portfolio/media.dart';

class MediaGrid extends StatelessWidget {
  final void Function(Media media, bool selected) onTap;
  final bool scrollable;
  final List<Media> media;
  final Set<Media> selectedMedia;

  final List<Media> flattenedMedia;

  MediaGrid(
    this.media, {
    this.onTap,
    this.scrollable = false,
    this.selectedMedia,
  }) : flattenedMedia = new List<Media>() {
    media.forEach((item) {
      if (item.mediaType == MediaType.Album) {
        flattenedMedia.addAll(item.children);
      } else {
        flattenedMedia.add(item);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      controller: ScrollController(keepScrollOffset: false),
      shrinkWrap: true,
      physics: scrollable
          ? const ScrollPhysics()
          : const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.only(left: 8, right: 8),
      crossAxisCount: 2,
      mainAxisSpacing: 8,
      crossAxisSpacing: 8,
      children: flattenedMedia.map((item) {
        final mediaUrl = item.mediaType == MediaType.Video
            ? item.thumbnailUrl
            : item.mediaUrl;
        if (selectedMedia != null && selectedMedia.contains(item)) {
          return InkWell(
            onTap: () => onTap?.call(item, true),
            child: Stack(
              children: <Widget>[
                Container(
                  child: CachedNetworkImage(
                    imageUrl: mediaUrl,
                    fit: BoxFit.fitWidth,
                  ),
                  foregroundDecoration: BoxDecoration(
                    border: Border.all(
                      color: Theme.of(context).colorScheme.secondary,
                      width: 3,
                    ),
                  ),
                ),
                Container(
                  color: Colors.black54,
                  width: double.infinity,
                  height: double.infinity,
                  child: Icon(
                    Icons.check_circle_outline,
                    color: Colors.white,
                    size: 48,
                  ),
                ),
              ],
            ),
          );
        } else {
          return InkWell(
            onTap: () => onTap?.call(item, false),
            child: CachedNetworkImage(
              imageUrl: mediaUrl,
              fit: BoxFit.fitWidth,
            ),
          );
        }
      }).toList(),
    );
  }
}
