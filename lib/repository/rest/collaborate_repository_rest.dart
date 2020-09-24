import 'package:xopa_app/repository/client.dart';
import 'package:xopa_app/repository/collaborate_repository.dart';
import 'package:xopa_app/repository/models/collaborate/collaboration.dart';
import 'package:xopa_app/repository/models/portfolio/portfolio.dart';
import 'package:xopa_app/repository/models/serializable.dart';

class CollaborateRepositoryRest implements CollaborateRepository {
  @override
  Future<List<Collaboration>> getCollaborations() async {
    final data = await Client.get('/collaborations/');
    return jsonDecodeList(() => Collaboration(), data);
  }

  @override
  Future<void> addCollaborator(String collaborationId, Portfolio user) async {
    await Client.post(
      '/collaborations/$collaborationId/add-collaborator/',
      data: user.toJson(),
    );
  }

  @override
  Future<Collaboration> createCollaboration(Collaboration collaboration) async {
    final data = await Client.post('/collaborations/create/', data: collaboration.toJson());
    return jsonDecode(() => Collaboration(), data);
  }

  @override
  Future<void> removeCollaborator(String collaborationId, Portfolio user) async {
    await Client.post(
      '/collaborations/$collaborationId/remove-collaborator/',
      data: user.toJson(),
    );
  }
}
