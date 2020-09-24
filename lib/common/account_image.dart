import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class AccountImage extends StatelessWidget {
  final String imageUrl;
  final double size;

  AccountImage({
    @required this.imageUrl,
    this.size = 100,
  });

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      imageBuilder: (context, provider) {
        return CircleAvatar(
          backgroundImage: provider,
          backgroundColor: Theme.of(context).colorScheme.primary,
          radius: size / 2,
        );
      },
      errorWidget: (_, __, ___) => CircleAvatar(
        child: Icon(Icons.account_circle, size: size),
        radius: size / 2,
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      placeholder: (_, __) => CircleAvatar(
        child: Icon(Icons.account_circle, size: size),
        radius: size / 2,
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
    );
  }
}
