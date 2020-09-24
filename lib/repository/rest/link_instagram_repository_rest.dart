import 'package:xopa_app/repository/client.dart';
import 'package:xopa_app/repository/link_instagram_repository.dart';
import 'package:xopa_app/repository/models/oauth/authcode.dart';

class LinkInstagramRepositoryRest implements LinkInstagramRepository {
  @override
  Future<void> linkInstagram(String authCode) async {
    await Client.post(
      '/oauth/auth/',
      data: AuthCode(authCode).toJson(),
    );
  }

  @override
  Future<void> unlinkInstagram() async {
    await Client.post('/oauth/unlink/');
  }
}
