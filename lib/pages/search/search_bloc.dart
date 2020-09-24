import 'package:bloc/bloc.dart';
import 'package:xopa_app/repository/interests_repository.dart';
import 'package:xopa_app/repository/errors.dart';
import 'package:xopa_app/repository/models/interests/interest.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {

  final SearchState _initialState;

  List<Interest> _interests;

  SearchBloc({SearchState initialState}) : _initialState = initialState {
    if (initialState != null) {
      add(_InitializeState(initialState));
    }
  }

  @override
  SearchState get initialState =>
      _initialState != null ? _initialState : LoadingSearch();

  @override
  Stream<SearchState> mapEventToState(event) async* {
    if (event is _InitializeState) {
      final state = event.state;
      if (state is FetchedSearch) {
        _interests = state.interests;
      }
    }

    if(event is FetchSearch) {
      try {
        _interests = await interestsRepository.getAvailableInterests(''); //TODO
        yield FetchedSearch(_interests);
      } on KozeException catch(e) {
        yield ErrorFetchingSearch(e.message);
      }
    }
  }
}

//Events
abstract class SearchEvent {}

class _InitializeState extends SearchEvent {
  final SearchState state;

  _InitializeState(this.state);
}

class FetchSearch extends SearchEvent {}

//States
abstract class SearchState {}

class LoadingSearch extends SearchState {}

class ErrorFetchingSearch extends SearchState {
  final String message;

  ErrorFetchingSearch(this.message);
}

class FetchedSearch extends SearchState {
  final List<Interest> interests;

  FetchedSearch(this.interests);
}