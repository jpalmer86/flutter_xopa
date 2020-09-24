import 'package:flutter/material.dart';
import 'package:xopa_app/common/account_image.dart';
import 'package:xopa_app/common/text_icon_button.dart';
import 'package:xopa_app/pages/messages/create_conversation_page.dart';
import 'package:xopa_app/pages/profile/profile_page.dart';
import 'package:xopa_app/repository/client.dart';
import 'package:xopa_app/repository/models/conversation/group.dart';
import 'package:xopa_app/repository/models/interests/user_and_interest.dart';
import 'package:xopa_app/repository/models/portfolio/portfolio.dart';

class UserTile extends StatelessWidget {
  final UserAndInterest userAndInterest;
  final Portfolio portfolio;
  final List<TextIconButton> primaryActions;
  final Map<String, VoidCallback> overflowActions;

  UserTile({
    this.userAndInterest,
    this.portfolio,
    this.primaryActions = const [],
    this.overflowActions = const {},
  })  : assert(
          userAndInterest != null || portfolio != null,
          'Either userAndInterest or portfolio must be given.',
        ),
        assert(
          (userAndInterest == null && portfolio != null) ||
              (userAndInterest != null && portfolio == null),
          'You cannot pass in both a userAndInterest and portfolio.',
        ),
        assert(
          overflowActions != null,
          'overflowActions must not be null!',
        ),
        assert(
          primaryActions != null,
          'primaryActions must not be null!'
        );

  @override
  Widget build(BuildContext context) {
    final userId =
        portfolio != null ? portfolio.userId : userAndInterest.userId;
    final name = portfolio != null ? portfolio.name : userAndInterest.name;
    final profilePicture = portfolio != null
        ? portfolio.profilePicture
        : userAndInterest.profilePicture;
    final portfolioIsPublic = portfolio != null ? portfolio.public : true;
    final additionalInformation =
        portfolio != null ? null : userAndInterest.comment;

    final isCurrentUser = portfolio != null
        ? portfolio.userId == Client.userId
        : userAndInterest.userId == Client.userId;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 12, right: 12, top: 24),
          child: AccountImage(
            imageUrl: profilePicture,
            size: 65,
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: 24),
              Text(
                name,
                style: Theme.of(context).textTheme.bodyText1,
              ),
              if (additionalInformation != null &&
                  additionalInformation.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  additionalInformation,
                  style: Theme.of(context).textTheme.caption,
                ),
              ],
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  if (primaryActions.isNotEmpty)
                    ...primaryActions.map((action) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 16),
                        child: action,
                      );
                    }),
                  if (!isCurrentUser)
                    TextIconButton(
                      icon: Icon(Icons.chat),
                      text: 'Chat',
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => CreateConversationPage(
                              Group(ids: [Client.userId, userId]),
                            ),
                          ),
                        );
                      },
                    ),
                  if (!isCurrentUser) const SizedBox(width: 16),
                  if (portfolioIsPublic)
                    TextIconButton(
                      icon: Icon(Icons.portrait),
                      text: 'Portfolio',
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => ProfilePage(userId),
                          ),
                        );
                      },
                    )
                  else
                    const SizedBox(width: 32),
                ],
              ),
            ],
          ),
        ),
        if (overflowActions.length > 0)
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert),
            itemBuilder: (context) => overflowActions
                .map((key, value) {
                  return MapEntry(
                      PopupMenuItem(
                        child: Text(key),
                        value: key,
                      ),
                      value);
                })
                .keys
                .toList(),
            onSelected: (String value) {
              overflowActions[value]?.call();
            },
          ),
      ],
    );
  }
}
