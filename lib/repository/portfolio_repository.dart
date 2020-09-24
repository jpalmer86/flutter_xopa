import 'package:xopa_app/repository/models/portfolio/media.dart';
import 'package:xopa_app/repository/models/portfolio/portfolio.dart';
import 'package:xopa_app/repository/models/portfolio/social_media.dart';
import 'package:xopa_app/repository/rest/portfolio_repository_rest.dart';

abstract class PortfolioRepository {
  Future<Portfolio> getPortfolio();
  Future<Portfolio> getPublicPortfolio(String userId);
  Future<List<Media>> getPortfolioMedia();
  Future<void> addMedia(Media media);
  Future<void> removeMedia(Media media);
  Future<void> publish(bool public);
  Future<void> updateProfilePicture(Portfolio profilePicture);
  Future<void> updateBio(Portfolio bio);
  Future<void> updateSocialMedia(SocialMedia socialMedia);
}

PortfolioRepository portfolioRepository = new PortfolioRepositoryRest();