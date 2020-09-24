import 'package:xopa_app/repository/models/conversation/conversation.dart';
import 'package:xopa_app/repository/models/conversation/group.dart';
import 'package:xopa_app/repository/rest/conversation_repository_rest.dart';

abstract class ConversationRepository {
  Future<Conversation> createConversation(Group group);
  Future<List<Conversation>> getConversations();
}

final ConversationRepository conversationRepository = new ConversationRepositoryRest();