import 'package:bloc/bloc.dart';
import 'package:xopa_app/repository/collaborate_repository.dart';
import 'package:xopa_app/repository/errors.dart';
import 'package:xopa_app/repository/models/collaborate/collaboration.dart';

class CollaborationsBloc
    extends Bloc<CollaborationsEvent, CollaborationsState> {
  final CollaborationsState _initialState;

  CollaborationsBloc({CollaborationsState initialState})
      : _initialState = initialState {
    if (initialState != null) {
      add(_InitializeState(initialState));
    }
  }

  @override
  CollaborationsState get initialState =>
      _initialState != null ? _initialState : LoadingCollaborations();

  List<Collaboration> _collaborations;

  @override
  Stream<CollaborationsState> mapEventToState(event) async* {
    if (event is _InitializeState) {
      final state = event.state;
      if (state is FetchedCollaborations) {
        _collaborations = state.collaborations;
      }
    }

    if (event is FetchCollaborations) {
      try {
        _collaborations = await collaborateRepository.getCollaborations();
        yield FetchedCollaborations(_collaborations);
      } on KozeException catch (e) {
        yield ErrorFetchingCollaborations(e.message);
      }
    }

    if (event is NewCollaboration) {
      try {
        final collaboration = await collaborateRepository.createCollaboration(
          Collaboration(name: event.name),
        );
        _collaborations.add(collaboration);
        add(FetchCollaborations());
      } on KozeException catch (e) {
        yield ErrorAddingCollaboration(e.message, _collaborations);
      }
    }
  }
}

//Events
abstract class CollaborationsEvent {}

class FetchCollaborations extends CollaborationsEvent {}

class NewCollaboration extends CollaborationsEvent {
  final String name;

  NewCollaboration(this.name);
}

class _InitializeState extends CollaborationsEvent {
  final CollaborationsState state;

  _InitializeState(this.state);
}

//States
abstract class CollaborationsState {}

class LoadingCollaborations extends CollaborationsState {}

class ErrorFetchingCollaborations extends CollaborationsState {
  final String message;

  ErrorFetchingCollaborations(this.message);
}

class ErrorAddingCollaboration extends FetchedCollaborations {
  final String message;

  ErrorAddingCollaboration(
    this.message,
    List<Collaboration> collaborations,
  ) : super(collaborations);
}

class FetchedCollaborations extends CollaborationsState {
  final List<Collaboration> collaborations;

  FetchedCollaborations(this.collaborations);
}
