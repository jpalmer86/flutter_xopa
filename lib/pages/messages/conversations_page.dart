import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xopa_app/common/overlap_image_row.dart';
import 'package:xopa_app/pages/messages/chat_page.dart';
import 'package:xopa_app/pages/messages/conversations_bloc.dart';

class ConversationsPage extends StatefulWidget {
  ConversationsPage({Key key}) : super(key: key);

  @override
  _ConversationsPageState createState() => _ConversationsPageState();
}

class _ConversationsPageState extends State<ConversationsPage> {
  ConversationsBloc _conversationsBloc;

  @override
  void initState() {
    final savedState =
        PageStorage.of(context).readState(context, identifier: widget.key);
    if (savedState != null) {
      _conversationsBloc = new ConversationsBloc(initialState: savedState);
    } else {
      _conversationsBloc = new ConversationsBloc();
      _conversationsBloc.add(FetchConversations());
    }
    _conversationsBloc.listen((ConversationsState state) {
      PageStorage.of(context)
          .writeState(context, state, identifier: widget.key);
    });
    super.initState();
  }

  @override
  void dispose() {
    _conversationsBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      bloc: _conversationsBloc,
      builder: (context, ConversationsState state) {
        if (state is LoadingConversations) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (state is ErrorFetchingConversations) {
          return Center(
            child: Text(state.message),
          );
        }

        if (state is FetchedConversations) {
          if(state.conversations.length == 0) {
            return const Center(
              child: Text('No messages yet'),
            );
          }

          return ListView.builder(
            itemCount: state.conversations.length,
            itemBuilder: (context, index) {
              final conversation = state.conversations[index];
              return OpenContainer(
                closedBuilder: (_, open) => ListTile(
                  leading: OverlapImageRow(
                    conversation.profilePictures,
                    size: 40,
                    overlap: 0.2,
                    max: 3,
                    leftOnTop: true,
                  ),
                  title: Text(
                    conversation.name,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  subtitle: Text(
                    conversation.latestMessage,
                    style: Theme.of(context).textTheme.subtitle2,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  onTap: open,
                ),
                openBuilder: (_, __) {
                  return ChatPage(conversation.id);
                },
              );
            },
          );
        }

        return Container();
      },
    );
  }
}
