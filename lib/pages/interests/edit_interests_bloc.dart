import 'package:bloc/bloc.dart';
import 'package:xopa_app/repository/errors.dart';
import 'package:xopa_app/repository/interests_repository.dart';
import 'package:xopa_app/repository/models/interests/interest.dart';
import 'package:xopa_app/repository/models/interests/users_interest.dart';

class EditInterestsBloc extends Bloc<EditInterestsEvent, EditInterestsState> {
  @override
  EditInterestsState get initialState => LoadingEditInterests();

  List<Interest> _interests = new List<Interest>();
  Set<UsersInterest> _selectedInterests = new Set<UsersInterest>();

  @override
  Stream<EditInterestsState> mapEventToState(event) async* {
    if (event is FetchEditInterests) {
      try {
        _interests =
            await interestsRepository.getAvailableInterests(event.query);
        _selectedInterests = await interestsRepository.getUserInterests();
      } on KozeException catch (e) {
        yield ErrorFetchingEditInterests(
          _interests,
          _selectedInterests,
          e.message,
        );
        return;
      }
    }

    if (event is SelectInterest) {
      try {
        //Immediately add it to the list and update the state
        // in case of a slow network connection.
        _selectedInterests.add(event.interest);
        yield FetchedEditInterests(_interests, _selectedInterests);
        await interestsRepository.addInterest(event.interest);
      } on KozeException catch (e) {
        _selectedInterests.remove(event.interest);
        yield ErrorFetchingEditInterests(
          _interests,
          _selectedInterests,
          e.message,
        );
        return;
      }
    }

    if (event is DeselectInterest) {
      try {
        //Immediately remove it from the list and update the state
        // in case of a slow network connection.
        _selectedInterests.remove(event.interest);
        yield FetchedEditInterests(_interests, _selectedInterests);
        await interestsRepository.removeInterest(event.interest);
      } on KozeException catch (e) {
        _selectedInterests.add(event.interest);
        yield ErrorFetchingEditInterests(
          _interests,
          _selectedInterests,
          e.message,
        );
        return;
      }
    }

    yield FetchedEditInterests(_interests, _selectedInterests);
  }
}

//Events
abstract class EditInterestsEvent {}

class FetchEditInterests extends EditInterestsEvent {
  final String query;

  FetchEditInterests(this.query);
}

class SelectInterest extends EditInterestsEvent {
  final UsersInterest interest;

  SelectInterest(this.interest);
}

class DeselectInterest extends EditInterestsEvent {
  final UsersInterest interest;

  DeselectInterest(this.interest);
}

//States
abstract class EditInterestsState {}

class LoadingEditInterests extends EditInterestsState {}

class ErrorFetchingEditInterests extends FetchedEditInterests {
  final String message;

  ErrorFetchingEditInterests(
    List<Interest> allInterests,
    Set<UsersInterest> selectedInterests,
    this.message,
  ) : super(allInterests, selectedInterests);
}

class FetchedEditInterests extends EditInterestsState {
  final List<Interest> allInterests;
  final Set<UsersInterest> selectedInterests;

  FetchedEditInterests(this.allInterests, this.selectedInterests);
}
