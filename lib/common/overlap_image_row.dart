import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:xopa_app/common/account_image.dart';

class OverlapImageRow extends StatelessWidget {
  final List<String> imageUrls;
  final double size;
  final double overlap;
  final int max;
  final bool leftOnTop;

  OverlapImageRow(
    this.imageUrls, {
    this.size = 100,
    this.overlap = 0.7,
    this.max,
    this.leftOnTop = false,
  });

  @override
  Widget build(BuildContext context) {
    final actualMax =
        max != null ? math.min(imageUrls.length, max) : imageUrls.length;
    List<Widget> mappedImages = new List<Widget>();
    for (int i = 0; i < actualMax; i++) {
      int actualIndex = leftOnTop? actualMax - 1 - i: i;
      mappedImages.add(
        Positioned(
          left:  actualIndex * size * overlap,
          child: AccountImage(imageUrl: imageUrls[actualIndex], size: size),
        ),
      );
    }

    return SizedBox(
      width: size + size * (math.max(actualMax, max ?? -1) - 1) * overlap,
      height: size,
      child: Stack(
        children: mappedImages,
      ),
    );
  }
}
