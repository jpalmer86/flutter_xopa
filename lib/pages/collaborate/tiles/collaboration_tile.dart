import 'package:flutter/material.dart';
import 'package:xopa_app/common/overlap_image_row.dart';
import 'package:xopa_app/repository/models/collaborate/collaboration.dart';

class CollaborationTile extends StatelessWidget {

  final VoidCallback onTap;
  final Collaboration collaboration;

  CollaborationTile({this.onTap, @required this.collaboration});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      title: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          collaboration.name,
          style: Theme.of(context)
              .textTheme
              .headline6
              .copyWith(fontWeight: FontWeight.bold),
        ),
      ),
      subtitle: Padding(
        padding: const EdgeInsets.all(8.0),
        child: OverlapImageRow(
          collaboration.users
              ?.map((user) => user.profilePicture)
              ?.toList() ??
              [],
          size: 100,
        ),
      ),
    );
  }

}
