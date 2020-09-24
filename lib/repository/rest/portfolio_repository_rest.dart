import 'package:xopa_app/repository/client.dart';
import 'package:xopa_app/repository/models/portfolio/media.dart';
import 'package:xopa_app/repository/models/portfolio/portfolio.dart';
import 'package:xopa_app/repository/models/portfolio/social_media.dart';
import 'package:xopa_app/repository/models/serializable.dart';
import 'package:xopa_app/repository/portfolio_repository.dart';

class PortfolioRepositoryRest implements PortfolioRepository {
  @override
  Future<Portfolio> getPortfolio() async {
    final data = await Client.get('/portfolio/');
    return jsonDecode(() => Portfolio(), data);
  }

  @override
  Future<Portfolio> getPublicPortfolio(String userId) async {
    final data = await Client.get('/portfolio/?user_id=$userId');
    return jsonDecode(() => Portfolio(), data);
  }

  @override
  Future<List<Media>> getPortfolioMedia() async {
    final data = await Client.get('/portfolio/media/');
    return jsonDecodeList(() => Media(), data);
  }

  @override
  Future<void> addMedia(Media media) async {
    await Client.post('/portfolio/media/add/', data: media.toJson());
  }

  @override
  Future<void> removeMedia(Media media) async {
    await Client.post('/portfolio/media/remove/', data: media.toJson());
  }

  @override
  Future<void> publish(bool public) async {
    await Client.post(
      '/portfolio/publish/',
      data: {
        'public': public,
      },
    );
  }

  @override
  Future<void> updateBio(Portfolio bio) async {
    await Client.post('/portfolio/bio/', data: bio.toJson());
  }

  @override
  Future<void> updateProfilePicture(Portfolio profilePicture) async {
    await Client.post(
      '/portfolio/profile/picture/',
      data: profilePicture.toJson(),
    );
  }

  @override
  Future<void> updateSocialMedia(SocialMedia socialMedia) async {
    await Client.post(
      '/portfolio/socialmedia/',
      data: socialMedia.toJson(),
    );
  }
}
