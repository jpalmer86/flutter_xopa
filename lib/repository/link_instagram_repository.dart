import 'package:xopa_app/repository/rest/link_instagram_repository_rest.dart';

abstract class LinkInstagramRepository {
  Future<void> linkInstagram(String authCode);
  Future<void> unlinkInstagram();
}

LinkInstagramRepository linkInstagramRepository = new LinkInstagramRepositoryRest();