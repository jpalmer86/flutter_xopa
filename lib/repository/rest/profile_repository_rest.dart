import 'package:xopa_app/repository/client.dart';
import 'package:xopa_app/repository/errors.dart';
import 'package:xopa_app/repository/models/onboarding/login.dart';
import 'package:xopa_app/repository/models/serializable.dart';
import 'package:xopa_app/repository/models/onboarding/signup.dart';
import 'package:xopa_app/repository/models/onboarding/token.dart';
import 'package:xopa_app/repository/profile_repository.dart';
import 'package:dio/dio.dart';

class ProfileRepositoryRest implements ProfileRepository {
  @override
  Future<Token> login(Login login) async {
    try {
      final response = await Client.getDio().post(
        Client.url('/auth/'),
        data: login.toJson(),
      );
      return jsonDecode(() => Token(), response.data);
    } on DioError catch(e) {
      switch(e.response?.statusCode) {
        case 401:
          throw KozeException('Incorrect username or password');
        case 500:
          throw KozeException('Server Error. Try again later.');
      }
      throw KozeException(e.message);
    }
  }

  @override
  Future<Token> signUp(Signup signup) async {
    try {
      final response = await Client.getDio().post(
        Client.url('/auth/signup/'),
        data: signup.toJson(),
      );
      return jsonDecode(() => Token(), response.data);
    } on DioError catch(e) {
      switch(e.response?.statusCode) {
        case 400:
          throw KozeException("Email or password don't meet requirements");
        case 409:
          throw KozeException('An account for this email or username already exists');
        case 500:
          throw KozeException('Server Error. Try again later.');
      }

      throw KozeException(e.message);
    }
  }
}
