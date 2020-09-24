import 'package:bloc/bloc.dart';
import 'package:xopa_app/repository/client.dart';
import 'package:xopa_app/repository/errors.dart';
import 'package:xopa_app/repository/interests_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoadingBloc extends Bloc<LoadingEvent, LoadingState> {
  @override
  LoadingState get initialState => Loading();

  @override
  Stream<LoadingState> mapEventToState(event) async* {
    if (event is Load) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token != null) {
        Client.setToken(token);

        bool setInterests = prefs.getBool('interests') ?? false;

        if (!setInterests) {
          try {
            final userInterests = await interestsRepository.getUserInterests();
            setInterests = userInterests.isNotEmpty;
            prefs.setBool('interests', setInterests);
          } on KozeException {}
        }

        yield Loaded(
          loggedIn: true,
          needsToSetInterests: !setInterests,
        );
      } else {
        yield Loaded(
          loggedIn: false,
          needsToSetInterests: false,
        );
      }
    }
  }
}

//Events
abstract class LoadingEvent {}

class Load extends LoadingEvent {}

//States
abstract class LoadingState {}

class Loading extends LoadingState {}

class Loaded extends LoadingState {
  final bool loggedIn;
  final bool needsToSetInterests;

  Loaded({this.loggedIn, this.needsToSetInterests});
}
