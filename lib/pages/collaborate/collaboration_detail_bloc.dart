import 'package:bloc/bloc.dart';
import 'package:xopa_app/repository/collaborate_repository.dart';
import 'package:xopa_app/repository/errors.dart';
import 'package:xopa_app/repository/models/portfolio/portfolio.dart';

class CollaborationDetailBloc
    extends Bloc<CollaborationDetailEvent, CollaborationDetailState> {
  @override
  CollaborationDetailState get initialState => CollaborationReadyState();

  @override
  Stream<CollaborationDetailState> mapEventToState(event) async* {
    if (event is RemoveCollaborator) {
      try {
        await collaborateRepository.removeCollaborator(
          event.collaborationId,
          event.collaboratorToRemove,
        );
        yield RemovedCollaborator(event.collaboratorToRemove);
      } on KozeException catch(e) {
        yield ErrorRemovingCollaborator(e.message);
      }
    }
  }
}

//Events
abstract class CollaborationDetailEvent {}

class RemoveCollaborator extends CollaborationDetailEvent {
  final String collaborationId;
  final Portfolio collaboratorToRemove;

  RemoveCollaborator(this.collaborationId, this.collaboratorToRemove);
}

//States
abstract class CollaborationDetailState {}

class CollaborationReadyState extends CollaborationDetailState {}

class RemovedCollaborator extends CollaborationDetailState {
  final Portfolio collaborator;

  RemovedCollaborator(this.collaborator);
}

class ErrorRemovingCollaborator extends CollaborationDetailState {
  final String message;

  ErrorRemovingCollaborator(this.message);
}
