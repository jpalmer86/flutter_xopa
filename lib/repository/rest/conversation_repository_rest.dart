import 'package:xopa_app/repository/client.dart';
import 'package:xopa_app/repository/conversation_repository.dart';
import 'package:xopa_app/repository/models/conversation/conversation.dart';
import 'package:xopa_app/repository/models/conversation/group.dart';
import 'package:xopa_app/repository/models/serializable.dart';

class ConversationRepositoryRest implements ConversationRepository {
  @override
  Future<Conversation> createConversation(Group group) async {
    final data = await Client.post(
      '/conversations/create/',
      data: group.toJson(),
    );
    return jsonDecode(() => Conversation(), data);
  }

  @override
  Future<List<Conversation>> getConversations() async {
    final data = await Client.get('/conversations/');
    return jsonDecodeList(() => Conversation(), data);
  }
}
