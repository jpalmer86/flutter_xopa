import 'package:bloc/bloc.dart';
import 'package:xopa_app/repository/errors.dart';
import 'package:xopa_app/repository/models/portfolio/portfolio.dart';
import 'package:xopa_app/repository/portfolio_repository.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileState _initialState;

  ProfileBloc({ProfileState initialState}) : _initialState = initialState {
    if (initialState != null) {
      add(_InitializeState(initialState));
    }
  }

  Portfolio _portfolio;

  @override
  ProfileState get initialState =>
      _initialState != null ? _initialState : LoadingProfile();

  @override
  Stream<ProfileState> mapEventToState(event) async* {
    if (event is _InitializeState) {
      if (event.state is FetchedProfile) {
        // ignore: avoid_as
        _portfolio = (event.state as FetchedProfile).portfolio;
      }
    }

    if (event is FetchProfile) {
      try {
        if (event.userId.isEmpty) {
          _portfolio = await portfolioRepository.getPortfolio();
        } else {
          _portfolio =
              await portfolioRepository.getPublicPortfolio(event.userId);
        }
        yield FetchedProfile(_portfolio);
      } on KozeException catch (e) {
        yield ErrorFetchingProfile(e.message);
      }
    }

    if (event is SetPortfolio) {
      _portfolio = event.newPortfolio;
      yield FetchedProfile(_portfolio);
    }

    if (event is EditBio) {
      if (_portfolio == null) {
        yield ErrorSavingProfile('Portfolio not yet loaded', _portfolio);
        return;
      }

      try {
        _portfolio.bio = event.newBio;
        portfolioRepository.updateBio(_portfolio);
        yield FetchedProfile(_portfolio);
      } on KozeException catch (e) {
        yield ErrorSavingProfile(e.message, _portfolio);
      }
    }
  }
}

//Events
abstract class ProfileEvent {}

class _InitializeState extends ProfileEvent {
  final ProfileState state;

  _InitializeState(this.state);
}

class FetchProfile extends ProfileEvent {
  final String userId;

  FetchProfile(this.userId);
}

class EditBio extends ProfileEvent {
  final String newBio;

  EditBio(this.newBio);
}

class SetPortfolio extends ProfileEvent {
  final Portfolio newPortfolio;

  SetPortfolio(this.newPortfolio);
}

//States
abstract class ProfileState {}

class LoadingProfile extends ProfileState {}

class ErrorFetchingProfile extends ProfileState {
  final String message;

  ErrorFetchingProfile(this.message);
}

class ErrorSavingProfile extends FetchedProfile {
  final String message;

  ErrorSavingProfile(this.message, Portfolio portfolio) : super(portfolio);
}

class FetchedProfile extends ProfileState {
  final Portfolio portfolio;

  FetchedProfile(this.portfolio);
}
