import 'package:bloc/bloc.dart';
import 'package:xopa_app/repository/errors.dart';
import 'package:xopa_app/repository/link_instagram_repository.dart';

class LinkInstagramBloc extends Bloc<LinkInstagramEvent, LinkInstagramState> {

   @override
   LinkInstagramState get initialState => WaitingForUser();

   @override
   Stream<LinkInstagramState> mapEventToState(event) async* {
     if(event is SubmitAuthCode) {
       try {
         await linkInstagramRepository.linkInstagram(event.authCode);
         yield SuccessfullyLinkedInstagram();
       } on KozeException catch(e) {
         yield ErrorLinkingInstagram(e.message);
       }
     }
   }

}

//Events
abstract class LinkInstagramEvent {}

class SubmitAuthCode extends LinkInstagramEvent {
  final String authCode;

  SubmitAuthCode(this.authCode);
}

//States
abstract class LinkInstagramState {}

class WaitingForUser extends LinkInstagramState {}
class LoadingLinkInstagram extends LinkInstagramState {}

class ErrorLinkingInstagram extends LinkInstagramState {
  final String message;

  ErrorLinkingInstagram(this.message);
}

class SuccessfullyLinkedInstagram extends LinkInstagramState {}