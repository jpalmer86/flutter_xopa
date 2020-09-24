import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:xopa_app/repository/chat_repository.dart';
import 'package:xopa_app/repository/errors.dart';
import 'package:xopa_app/repository/models/chat/message.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {

   @override
   ChatState get initialState => LoadingChat();

   @override
   Future<void> close() {
     chatRepository.close();
     return super.close();
  }

   @override
   Stream<ChatState> mapEventToState(event) async* {
     if(event is ConnectToChat) {
       try {
         final stream = await chatRepository.getMessageStream(event.conversationId);
         yield FetchedChat(stream);
       } on KozeException catch(e) {
         yield ErrorConnectingToChat(e.message);
       }
     }

      if(event is SendMessage) {
        try {
          await chatRepository.sendMessage(event.message);
        } on KozeException {
          //TODO
        }
      }
   }

}

//Events
abstract class ChatEvent {}

class ConnectToChat extends ChatEvent {
  final String conversationId;

  ConnectToChat(this.conversationId);
}

class SendMessage extends ChatEvent {
  final Message message;

  SendMessage(this.message);
}

//States
abstract class ChatState {}

class LoadingChat extends ChatState {}

class ErrorConnectingToChat extends ChatState {
  final String message;

  ErrorConnectingToChat(this.message);
}

class FetchedChat extends ChatState {
  final Stream<Message> newMessageStream;

  FetchedChat(this.newMessageStream);
}