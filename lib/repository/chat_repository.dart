import 'package:xopa_app/repository/models/chat/message.dart';
import 'package:xopa_app/repository/rest/chat_repository_rest.dart';

abstract class ChatRepository {
  Future<List<Message>> getMessageHistory(String conversationId);
  Future<Stream<Message>> getMessageStream(String conversationId);
  Future<void> sendMessage(Message message);
  void close();
}

final ChatRepository chatRepository = new ChatRepositoryRest();