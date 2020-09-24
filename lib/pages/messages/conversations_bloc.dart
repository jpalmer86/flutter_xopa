import 'package:bloc/bloc.dart';
import 'package:xopa_app/repository/conversation_repository.dart';
import 'package:xopa_app/repository/errors.dart';
import 'package:xopa_app/repository/models/conversation/conversation.dart';

class ConversationsBloc extends Bloc<ConversationsEvent, ConversationsState> {

   final ConversationsState _initialState;

   List<Conversation> _conversations;

   ConversationsBloc({ConversationsState initialState}) : _initialState = initialState {
     if (initialState != null) {
       add(_InitializeState(initialState));
       add(FetchConversations());
     }
   }

   @override
   ConversationsState get initialState =>
       _initialState != null ? _initialState : LoadingConversations();

   @override
   Stream<ConversationsState> mapEventToState(event) async* {
     if (event is _InitializeState) {
       final state = event.state;
       if (state is FetchedConversations) {
         _conversations = state.conversations;
       }
     }

     if(event is FetchConversations) {
       try {
         _conversations = await conversationRepository.getConversations();
         yield FetchedConversations(_conversations);
       } on KozeException catch(e) {
         yield ErrorFetchingConversations(e.message);
       }
     }
   }
}

//Events
abstract class ConversationsEvent {}

class _InitializeState extends ConversationsEvent {
  final ConversationsState state;

  _InitializeState(this.state);
}

class FetchConversations extends ConversationsEvent {}

//States
abstract class ConversationsState {}

class LoadingConversations extends ConversationsState {}

class ErrorFetchingConversations extends ConversationsState {
  final String message;

  ErrorFetchingConversations(this.message);
}

class FetchedConversations extends ConversationsState {
  final List<Conversation> conversations;

  FetchedConversations(this.conversations);
}