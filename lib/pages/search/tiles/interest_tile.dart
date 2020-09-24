import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:xopa_app/pages/interests/interest_detail_page.dart';
import 'package:xopa_app/repository/models/interests/interest.dart';

class InterestTile extends StatelessWidget {

  final Interest interest;

  InterestTile(this.interest);

  @override
  Widget build(BuildContext context) {
      return OpenContainer(
        transitionType: ContainerTransitionType.fadeThrough,
        closedBuilder: (_, open) {
          return ListTile(
            onTap: open,
            title: Text(interest.name),
          );
        },
        openBuilder: (_, __) {
          return InterestDetailPage(interest);
        },
      );
  }
}
