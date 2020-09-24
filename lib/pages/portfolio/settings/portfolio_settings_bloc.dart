import 'package:bloc/bloc.dart';
import 'package:xopa_app/repository/errors.dart';
import 'package:xopa_app/repository/link_instagram_repository.dart';
import 'package:xopa_app/repository/models/portfolio/media.dart';
import 'package:xopa_app/repository/models/portfolio/portfolio.dart';
import 'package:xopa_app/repository/portfolio_repository.dart';

class PortfolioSettingsBloc extends Bloc<PortfolioSettingsEvent, PortfolioSettingsState> {

   @override
   PortfolioSettingsState get initialState => LoadingPortfolioSettings();

   List<Media> allMedia;
   Portfolio _portfolio;

   @override
   Stream<PortfolioSettingsState> mapEventToState(event) async* {
      if(event is FetchPortfolioSettings) {
        _portfolio = event.initialPortfolio;
        try {
          allMedia = await portfolioRepository.getPortfolioMedia();
          yield FetchedPortfolioSettings(_portfolio, allMedia);
        } on KozeException catch(e) {
          yield ErrorFetchingPortfolioSettings(e.message);
        }
      }

      if(event is AddPortfolioMedia) {
        _portfolio.media.add(event.mediaToAdd);
        yield FetchedPortfolioSettings(_portfolio, allMedia);
        try {
          await portfolioRepository.addMedia(event.mediaToAdd);
        } on KozeException {
          //Undo what we just did if an error occurs
          _portfolio.media.remove(event.mediaToAdd);
          yield FetchedPortfolioSettings(_portfolio, allMedia);
        }
      }

      if(event is RemovePortfolioMedia) {
        _portfolio.media.remove(event.mediaToRemove);
        yield FetchedPortfolioSettings(_portfolio, allMedia);
        try {
          await portfolioRepository.removeMedia(event.mediaToRemove);
        } on KozeException {
          //Undo what we just did if an error occurs
          _portfolio.media.add(event.mediaToRemove);
          yield FetchedPortfolioSettings(_portfolio, allMedia);
        }
      }

      if(event is TogglePortfolioPublicity) {
        final previousValue = _portfolio.public;
        _portfolio.public = event.public;
        yield FetchedPortfolioSettings(_portfolio, allMedia);
        try {
          await portfolioRepository.publish(event.public);
        } on KozeException {
          //Undo what we just did if an error occurs
          _portfolio.public = previousValue;
          yield FetchedPortfolioSettings(_portfolio, allMedia);
        }
      }

      if(event is UnlinkInstagramAccount) {
        final List<Media> previousMedia = List<Media>()..addAll(_portfolio.media);
        final List<Media> previousAllMedia = List<Media>()..addAll(allMedia);
        final String previousInstagramUsername = _portfolio.instagramUsername;
        try {
          _portfolio.media.clear();
          allMedia.clear();
          _portfolio.instagramUsername = '';
          yield FetchedPortfolioSettings(_portfolio, allMedia);
          await linkInstagramRepository.unlinkInstagram();
        } on KozeException {
          //Undo what we just did if an error occurs
          _portfolio.media = previousMedia;
          allMedia = previousAllMedia;
          _portfolio.instagramUsername = previousInstagramUsername;
          yield FetchedPortfolioSettings(_portfolio, allMedia);
        }
      }
   }

}

//Events
abstract class PortfolioSettingsEvent {}

class FetchPortfolioSettings extends PortfolioSettingsEvent {
  final Portfolio initialPortfolio;

  FetchPortfolioSettings(this.initialPortfolio);
}

class TogglePortfolioPublicity extends PortfolioSettingsEvent {
  final bool public;

  TogglePortfolioPublicity(this.public);
}

class UnlinkInstagramAccount extends PortfolioSettingsEvent {}

class AddPortfolioMedia extends PortfolioSettingsEvent {
  final Media mediaToAdd;

  AddPortfolioMedia(this.mediaToAdd);
}

class RemovePortfolioMedia extends PortfolioSettingsEvent {
  final Media mediaToRemove;

  RemovePortfolioMedia(this.mediaToRemove);
}

//States
abstract class PortfolioSettingsState {}

class LoadingPortfolioSettings extends PortfolioSettingsState {}

class ErrorFetchingPortfolioSettings extends PortfolioSettingsState {
  final String message;

  ErrorFetchingPortfolioSettings(this.message);
}

class FetchedPortfolioSettings extends PortfolioSettingsState {
  final Portfolio currentPortfolio;
  final List<Media> allMedia;

  FetchedPortfolioSettings(this.currentPortfolio, this.allMedia);
}