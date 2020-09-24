import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xopa_app/pages/messages/chat_page.dart';
import 'package:xopa_app/pages/messages/create_conversation_bloc.dart';
import 'package:xopa_app/repository/models/conversation/group.dart';
import 'package:xopa_app/theme/widgets/themed_appbar.dart';

class CreateConversationPage extends StatefulWidget {
  final Group conversationGroup;

  CreateConversationPage(this.conversationGroup);

  @override
  _CreateConversationPageState createState() => _CreateConversationPageState();
}

class _CreateConversationPageState extends State<CreateConversationPage> {
  CreateConversationBloc _createConversationBloc;

  @override
  void initState() {
    _createConversationBloc = new CreateConversationBloc();
    _createConversationBloc.add(CreateConversation(widget.conversationGroup));
    super.initState();
  }

  @override
  void dispose() {
    _createConversationBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      bloc: _createConversationBloc,
      builder: (context, CreateConversationState state) {
        if(state is Loading) {
          return Scaffold(
            appBar: ThemedAppBar(title: const Text('New Conversation')),
            body: const Center(child: CircularProgressIndicator()),
          );
        }

        if(state is ErrorCreatingConversation) {
          return Scaffold(
            appBar: ThemedAppBar(title: const Text('New Conversation')),
            body: Center(child: Text(state.message)),
          );
        }

        if(state is Success) {
          return ChatPage(state.newConversationId);
        }

        return Container();
      },
    );
  }
}
