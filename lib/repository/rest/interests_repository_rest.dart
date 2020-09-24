import 'package:xopa_app/repository/client.dart';
import 'package:xopa_app/repository/interests_repository.dart';
import 'package:xopa_app/repository/models/interests/interest.dart';
import 'package:xopa_app/repository/models/interests/user_and_interest.dart';
import 'package:xopa_app/repository/models/interests/users_interest.dart';
import 'package:xopa_app/repository/models/serializable.dart';

class InterestsRepositoryRest implements InterestsRepository {
  @override
  Future<void> addInterest(UsersInterest interest) async {
    await Client.post(
      '/interests/add/',
      data: interest.toJson(),
    );
  }

  @override
  Future<List<Interest>> getAvailableInterests(String query) async {
    final data = await Client.get('/interests/?query=$query');
    return jsonDecodeList(() => Interest(), data);
  }

  @override
  Future<Set<UsersInterest>> getUserInterests() async {
    final data = await Client.get('/interests/list/');
    return jsonDecodeList(() => UsersInterest(), data).toSet();
  }

  @override
  Future<void> removeInterest(UsersInterest interest) async {
    await Client.post(
      '/interests/remove/',
      data: interest.toJson(),
    );
  }

  @override
  Future<List<UserAndInterest>> getUsersForInterest(Interest interest) async {
    final data = await Client.get('/interests/users/?interest_id=${interest.id}');
    return jsonDecodeList(() => UserAndInterest(), data);
  }


}
