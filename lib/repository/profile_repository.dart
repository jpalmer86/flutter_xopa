import 'package:xopa_app/repository/models/onboarding/login.dart';
import 'package:xopa_app/repository/models/onboarding/signup.dart';
import 'package:xopa_app/repository/models/onboarding/token.dart';
import 'package:xopa_app/repository/rest/profile_repository_rest.dart';

abstract class ProfileRepository {
  Future<Token> login(Login login);
  Future<Token> signUp(Signup signup);
}

final ProfileRepository profileRepository = new ProfileRepositoryRest();