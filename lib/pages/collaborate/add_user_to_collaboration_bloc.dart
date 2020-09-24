import 'package:bloc/bloc.dart';
import 'package:xopa_app/repository/collaborate_repository.dart';
import 'package:xopa_app/repository/errors.dart';
import 'package:xopa_app/repository/models/portfolio/portfolio.dart';

class AddUserToCollaborationBloc
    extends Bloc<AddUserToCollaborationEvent, AddUserToCollaborationState> {
  @override
  AddUserToCollaborationState get initialState =>
      WaitingForUserToBeAdded();

  @override
  Stream<AddUserToCollaborationState> mapEventToState(event) async* {
    if (event is AddUserToCollaborationEvent) {
      try {
        await collaborateRepository.addCollaborator(
          event.collaborationId,
          Portfolio(userId: event.userId),
        );
        yield AddedUser();
      } on KozeException catch(e) {
        yield ErrorAddingUserToCollaboration(e.message);
      }
    }
  }
}

//Events
class AddUserToCollaborationEvent {
  final String collaborationId;
  final String userId;

  AddUserToCollaborationEvent(
    this.collaborationId,
    this.userId,
  );
}

//States
abstract class AddUserToCollaborationState {}

class WaitingForUserToBeAdded extends AddUserToCollaborationState {}

class AddedUser extends AddUserToCollaborationState {}

class ErrorAddingUserToCollaboration extends AddUserToCollaborationState {
  final String message;

  ErrorAddingUserToCollaboration(this.message);
}
