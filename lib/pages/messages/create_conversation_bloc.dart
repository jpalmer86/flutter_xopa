import 'package:bloc/bloc.dart';
import 'package:xopa_app/repository/conversation_repository.dart';
import 'package:xopa_app/repository/errors.dart';
import 'package:xopa_app/repository/models/conversation/group.dart';

class CreateConversationBloc extends Bloc<CreateConversationEvent, CreateConversationState> {

  @override
  CreateConversationState get initialState => Loading();

  @override
  Stream<CreateConversationState> mapEventToState(event) async* {
    if (event is CreateConversation) {
      try {
        final conversation = await conversationRepository.createConversation(event.conversationGroup);

        yield Success(conversation.id);
      } on KozeException catch(e) {
        yield ErrorCreatingConversation(e.message);
      }
    }
  }

}

//Events
abstract class CreateConversationEvent {}

class CreateConversation extends CreateConversationEvent {
  final Group conversationGroup;

  CreateConversation(this.conversationGroup);
}

//States
abstract class CreateConversationState {}

class Loading extends CreateConversationState {}

class ErrorCreatingConversation extends CreateConversationState {
  final String message;

  ErrorCreatingConversation(this.message);
}

class Success extends CreateConversationState {
  final String newConversationId;

  Success(this.newConversationId);

}