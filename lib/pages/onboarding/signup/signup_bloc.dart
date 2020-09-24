import 'package:bloc/bloc.dart';
import 'package:xopa_app/repository/client.dart';
import 'package:xopa_app/repository/errors.dart';
import 'package:xopa_app/repository/models/onboarding/signup.dart';
import 'package:xopa_app/repository/profile_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  @override
  SignupState get initialState => Ready();

  @override
  Stream<SignupState> mapEventToState(event) async* {
    if (event is SubmitSignup) {
      yield Loading();
      if(event.password != event.repeatedPassword) {
        yield FormError('Passwords do not match');
        return;
      }
      try {
        final token = await profileRepository.signUp(
          Signup(
            username: event.username,
            name: event.name,
            email: event.email,
            password: event.password,
          ),
        );
        Client.setToken(token.token);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('token', token.token);
        yield Success();
      } on KozeException catch (e) {
        yield FormError(e.message);
      }
    }
  }
}

//Events
abstract class SignupEvent {}

class SubmitSignup extends SignupEvent {
  final String name;
  final String email;
  final String password;
  final String repeatedPassword;
  final String username;

  SubmitSignup(
    this.name,
    this.email,
    this.password,
    this.repeatedPassword,
    this.username,
  );
}

//States
abstract class SignupState {}

class Ready extends SignupState {}

class Loading extends SignupState {}

class FormError extends SignupState {
  final String message;

  FormError(this.message);
}

class Success extends SignupState {}
