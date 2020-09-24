import 'package:bloc/bloc.dart';
import 'package:xopa_app/repository/client.dart';
import 'package:xopa_app/repository/errors.dart';
import 'package:xopa_app/repository/models/onboarding/login.dart';
import 'package:xopa_app/repository/profile_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  @override
  LoginState get initialState => Ready();

  @override
  Stream<LoginState> mapEventToState(event) async* {
    if (event is SubmitLogin) {
      yield Loading();
      try {
        final token = await profileRepository.login(
          Login(
            username: event.username,
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
abstract class LoginEvent {}

class SubmitLogin extends LoginEvent {
  final String username;
  final String password;

  SubmitLogin(this.username, this.password);
}

//States
abstract class LoginState {}

class Ready extends LoginState {}

class Loading extends LoginState {}

class FormError extends LoginState {
  final String message;

  FormError(this.message);
}

class Success extends LoginState {}
