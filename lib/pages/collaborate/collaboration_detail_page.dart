import 'package:flutter/material.dart';
import 'package:xopa_app/common/text_icon_button.dart';
import 'package:xopa_app/pages/collaborate/collaboration_detail_bloc.dart';
import 'package:xopa_app/pages/home_page.dart';
import 'package:xopa_app/pages/messages/chat_page.dart';
import 'package:xopa_app/pages/search/search_page.dart';
import 'package:xopa_app/pages/search/tiles/user_tile.dart';
import 'package:xopa_app/repository/client.dart';
import 'package:xopa_app/repository/models/collaborate/collaboration.dart';
import 'package:xopa_app/theme/widgets/themed_appbar.dart';
import 'package:xopa_app/theme/widgets/themed_dialog.dart';

class CollaborationDetailPage extends StatefulWidget {
  final Collaboration collaboration;

  CollaborationDetailPage(this.collaboration);

  @override
  _CollaborationDetailPageState createState() =>
      _CollaborationDetailPageState();
}

class _CollaborationDetailPageState extends State<CollaborationDetailPage> {
  CollaborationDetailBloc _collaborationDetailBloc;
  Collaboration _collaboration;

  @override
  void initState() {
    _collaboration = widget.collaboration;
    _collaborationDetailBloc = new CollaborationDetailBloc();
    _collaborationDetailBloc.listen((CollaborationDetailState state) {
      if (state is ErrorRemovingCollaborator) {
        showDialog(
          context: context,
          builder: (_) => ThemedDialog.dialog(
            context: context,
            title: const Text('Error Removing Collaborator'),
            content: Text(state.message),
          ),
        );
      }

      if (state is RemovedCollaborator) {
        if(state.collaborator.userId == Client.userId) {
          Navigator.of(context).popUntil((route) => route.isFirst);
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (_) => HomePage(initialIndex: 0),
          ));
          return;
        }
        setState(() {
          _collaboration.users.remove(state.collaborator);
        });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _collaborationDetailBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ThemedAppBar(title: Text(widget.collaboration.name)),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  TextIconButton(
                    icon: Icon(Icons.chat),
                    text: 'Chat with Group',
                    onPressed: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (_) {
                        return ChatPage(widget.collaboration.conversationId);
                      }));
                    },
                  ),
                  TextIconButton(
                    icon: Icon(Icons.add),
                    text: 'Add Collaborator',
                    onPressed: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (_) {
                        return SearchPage();
                      }));
                    },
                  )
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _collaboration.users.length,
                itemBuilder: (context, index) {
                  return UserTile(
                    portfolio: _collaboration.users[index],
                    overflowActions: {
                      (Client.userId == _collaboration.users[index].userId
                          ? 'Leave Collaboration'
                          : 'Remove from Collaboration'): () {
                        _collaborationDetailBloc.add(RemoveCollaborator(
                          _collaboration.id,
                          _collaboration.users[index],
                        ));
                      },
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
