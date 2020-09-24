import 'package:bloc/bloc.dart';
import 'package:xopa_app/repository/chat_repository.dart';
import 'package:xopa_app/repository/errors.dart';
import 'package:xopa_app/repository/models/chat/message.dart';

class ChatHistoryBloc extends Bloc<ChatHistoryEvent, ChatHistoryState> {

   @override
   ChatHistoryState get initialState => LoadingChatHistory();

   @override
   Stream<ChatHistoryState> mapEventToState(event) async* {
     if(event is FetchChatHistory) {
       yield LoadingChatHistory();

       try {
         final pastMessages = await chatRepository.getMessageHistory(event.conversationId);
         yield(FetchedChatHistory(pastMessages));
       } on KozeException catch(e) {
         yield ErrorFetchingChatHistory(e.message);
       }
     }
   }

}

//Events
abstract class ChatHistoryEvent {}

class FetchChatHistory extends ChatHistoryEvent {
  final String conversationId;

  FetchChatHistory(this.conversationId);
}

//States
abstract class ChatHistoryState {}

class LoadingChatHistory extends ChatHistoryState {}

class ErrorFetchingChatHistory extends ChatHistoryState {
  final String message;

  ErrorFetchingChatHistory(this.message);
}

class FetchedChatHistory extends ChatHistoryState {
  final List<Message> messages;

  FetchedChatHistory(this.messages);
}