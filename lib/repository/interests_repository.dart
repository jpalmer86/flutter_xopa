import 'package:xopa_app/repository/models/interests/interest.dart';
import 'package:xopa_app/repository/models/interests/user_and_interest.dart';
import 'package:xopa_app/repository/models/interests/users_interest.dart';
import 'package:xopa_app/repository/rest/interests_repository_rest.dart';

abstract class InterestsRepository {
  Future<void> addInterest(UsersInterest interest);
  Future<void> removeInterest(UsersInterest interest);
  Future<Set<UsersInterest>> getUserInterests();
  Future<List<Interest>> getAvailableInterests(String query);
  Future<List<UserAndInterest>> getUsersForInterest(Interest interest);
}

final InterestsRepository interestsRepository = new InterestsRepositoryRest();