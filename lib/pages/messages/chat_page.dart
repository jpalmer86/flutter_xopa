import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xopa_app/common/account_image.dart';
import 'package:xopa_app/pages/messages/chat_bloc.dart';
import 'package:xopa_app/pages/messages/chat_history_bloc.dart';
import 'package:xopa_app/repository/client.dart';
import 'package:xopa_app/repository/models/chat/message.dart';
import 'package:xopa_app/theme/widgets/themed_appbar.dart';

class ChatPage extends StatefulWidget {
  final String conversationId;

  ChatPage(this.conversationId);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  ChatBloc _chatBloc;
  ChatHistoryBloc _chatHistoryBloc;

  @override
  void initState() {
    _chatBloc = ChatBloc();
    _chatBloc.add(ConnectToChat(widget.conversationId));
    _chatHistoryBloc = ChatHistoryBloc();
    _chatHistoryBloc.add(FetchChatHistory(widget.conversationId));
    super.initState();
  }

  @override
  void dispose() {
    _chatHistoryBloc.close();
    _chatBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ThemedAppBar(
        title: const Text('Conversation'),
      ),
      body: SafeArea(
        child: BlocBuilder(
          bloc: _chatBloc,
          builder: (context, ChatState state) => Column(
            children: <Widget>[
              Expanded(
                child: BlocBuilder(
                  bloc: _chatHistoryBloc,
                  builder:
                      (BuildContext context, ChatHistoryState historyState) {
                    if (historyState is LoadingChatHistory) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    if (historyState is ErrorFetchingChatHistory) {
                      return Center(
                        child: Text(
                          historyState.message,
                          textAlign: TextAlign.center,
                        ),
                      );
                    }

                    if (historyState is FetchedChatHistory) {
                      return ChatList(
                        messages: historyState.messages,
                        newMessages: state is FetchedChat
                            ? state.newMessageStream
                            : null,
                        userId: Client.userId,
                      );
                    }

                    return Container();
                  },
                ),
              ),
              SendMessageWidget(
                _chatBloc,
                Client.userId,
                widget.conversationId,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ChatList extends StatefulWidget {
  final List<Message> messages;
  final Stream<Message> newMessages;
  final String userId;

  ChatList({
    this.messages,
    this.newMessages,
    this.userId,
  });

  @override
  _ChatListState createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  List<Message> messages;
  ScrollController _controller;

  @override
  void initState() {
    _controller = new ScrollController();
    messages = widget.messages;
    widget.newMessages?.listen((message) {
      setState(() {
        messages.add(message);
        SchedulerBinding.instance.addPostFrameCallback((_) {
          _controller.animateTo(
            0,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        });
      });
    });
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (messages.length > 0) {
        _controller.jumpTo(0);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (messages.length == 0) {
      return const Center(
        child: Text('No messages yet!'),
      );
    }
    return ListView.builder(
      controller: _controller,
      itemCount: messages.length,
      itemBuilder: (context, index) =>
          MessageWidget(messages[messages.length - index - 1], widget.userId),
      reverse: true,
    );
  }
}

class MessageWidget extends StatelessWidget {
  final Message message;
  final String userId;

  MessageWidget(this.message, this.userId);

  @override
  Widget build(BuildContext context) {
    final sent = userId == message.fromId;

    return Column(
      crossAxisAlignment:
          sent ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        if (!sent)
          Padding(
            padding: const EdgeInsets.only(left: 60, top: 5),
            child: Text(
              message.fromName,
              style: const TextStyle(fontSize: 10),
            ),
          ),
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              if (!sent)
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: AccountImage(
                    imageUrl: message.fromProfilePicture,
                    size: 40,
                  ),
                ),
              Container(
                child: Text(message.message,
                    style: sent
                        ? Theme.of(context).accentTextTheme.bodyText1
                        : Theme.of(context).textTheme.bodyText1),
                padding: const EdgeInsets.all(8),
                margin: const EdgeInsets.only(left: 10, right: 10, top: 5),
                constraints: BoxConstraints(
                  minWidth: 10,
                  maxWidth: MediaQuery.of(context).size.width / 1.5,
                  minHeight: 36,
                ),
                decoration: BoxDecoration(
                    color: sent
                        ? Theme.of(context).colorScheme.secondary
                        : Theme.of(context).dividerColor,
                    borderRadius: BorderRadius.circular(10)),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class SendMessageWidget extends StatefulWidget {
  final ChatBloc chatBloc;
  final String userId;
  final String conversationId;

  SendMessageWidget(this.chatBloc, this.userId, this.conversationId);

  @override
  _SendMessageWidgetState createState() => _SendMessageWidgetState();
}

class _SendMessageWidgetState extends State<SendMessageWidget> {
  TextEditingController _messageText;
  bool _enabled = false;

  @override
  void initState() {
    _enabled = false;
    _messageText = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _messageText.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: _messageText,
        onChanged: (value) {
          if (value.trim().isNotEmpty) {
            setState(() {
              _enabled = true;
            });
          } else {
            setState(() {
              _enabled = false;
            });
          }
        },
        keyboardType: TextInputType.multiline,
        maxLines: null,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(36),
          ),
          hintText: 'Chat message',
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          suffixIcon: BlocListener(
            bloc: widget.chatBloc,
            listener: (context, ChatState state) {
              if (state is ErrorConnectingToChat) {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Error connecting to chat'),
                    content: Text(state.message),
                  ),
                );
              }
            },
            child: IconButton(
              padding: EdgeInsets.zero,
              icon: Icon(Icons.send),
              onPressed: _enabled ? sendMessage : null,
            ),
          ),
        ),
      ),
    );
  }

  void sendMessage() {
    widget.chatBloc.add(
      SendMessage(
        Message(
          conversationId: widget.conversationId,
          fromId: widget.userId,
          message: _messageText.text,
        ),
      ),
    );
    setState(() {
      _messageText.clear();
      _enabled = false;
    });
  }
}
