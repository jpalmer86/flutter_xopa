import 'package:xopa_app/repository/chat_repository.dart';
import 'package:xopa_app/repository/client.dart';
import 'package:xopa_app/repository/errors.dart';
import 'package:xopa_app/repository/models/chat/message.dart';
import 'package:xopa_app/repository/models/serializable.dart';
import 'package:web_socket_channel/status.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class ChatRepositoryRest implements ChatRepository {

  WebSocketChannel _socket;

  @override
  Future<List<Message>> getMessageHistory(String conversationId) async {
    final data = await Client.get('/chat/history/?id=$conversationId');
    return jsonDecodeList(() => Message(), data);
  }

  @override
  Future<Stream<Message>> getMessageStream(String conversationId) async {
    try {
      if(_socket == null)
        _socket = Client.getWebsocket('/chat/?conversation_id=$conversationId');
      return _socket.stream.map((data) => jsonDecode(() => Message(), data));
    } catch (e) {
      throw KozeException(e);
    }
  }

  @override
  Future<void> sendMessage(Message message) async {
    try {
      if(_socket != null)
        _socket.sink.add(message.message);
    } catch (e) {
      throw KozeException(e);
    }
  }

  @override
  void close() {
    _socket.sink.close(goingAway);
    _socket = null;
  }

}