import 'package:bloc/bloc.dart';
import 'package:xopa_app/repository/errors.dart';
import 'package:xopa_app/repository/models/portfolio/social_media.dart';
import 'package:xopa_app/repository/portfolio_repository.dart';

class PortfolioSocialMediaSettingsBloc extends Bloc<PortfolioSocialMediaSettingsEvent, PortfolioSocialMediaSettingsState> {

   @override
   PortfolioSocialMediaSettingsState get initialState => Ready();

   @override
   Stream<PortfolioSocialMediaSettingsState> mapEventToState(event) async* {
     if (event is SubmitPortfolioSocialMediaSettings) {
       try {
         await portfolioRepository.updateSocialMedia(event.socialMedia);
         yield Success();
       } on KozeException catch(e) {
         yield FormError(e.message);
       }
     }
   }

}

//Events
abstract class PortfolioSocialMediaSettingsEvent {}

class SubmitPortfolioSocialMediaSettings extends PortfolioSocialMediaSettingsEvent {
  final SocialMedia socialMedia;

  SubmitPortfolioSocialMediaSettings(this.socialMedia);
}

//States
abstract class PortfolioSocialMediaSettingsState {}

class Ready extends PortfolioSocialMediaSettingsState {}

class Loading extends PortfolioSocialMediaSettingsState {}

class FormError extends PortfolioSocialMediaSettingsState {
  final String message;

  FormError(this.message);
}

class Success extends PortfolioSocialMediaSettingsState {}