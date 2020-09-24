import 'package:bloc/bloc.dart';
import 'package:xopa_app/repository/errors.dart';
import 'package:xopa_app/repository/interests_repository.dart';
import 'package:xopa_app/repository/models/interests/interest.dart';
import 'package:xopa_app/repository/models/interests/user_and_interest.dart';

class InterestDetailBloc extends Bloc<InterestDetailEvent, InterestDetailState> {

   @override
   InterestDetailState get initialState => LoadingInterestDetail();

   @override
   Stream<InterestDetailState> mapEventToState(event) async* {
     if(event is FetchInterestDetail) {
       try {
         final interestUsers = await interestsRepository.getUsersForInterest(event.interest);
         yield FetchedInterestDetail(interestUsers);
       } on KozeException catch(e) {
         yield ErrorFetchingInterestDetail(e.message);
       }
     }
   }

}

//Events
abstract class InterestDetailEvent {}

class FetchInterestDetail extends InterestDetailEvent {
  final Interest interest;

  FetchInterestDetail(this.interest);
}

//States
abstract class InterestDetailState {}

class LoadingInterestDetail extends InterestDetailState {}

class ErrorFetchingInterestDetail extends InterestDetailState {
  final String message;

  ErrorFetchingInterestDetail(this.message);
}

class FetchedInterestDetail extends InterestDetailState {
  final List<UserAndInterest> usersForInterest;

  FetchedInterestDetail(this.usersForInterest);
}