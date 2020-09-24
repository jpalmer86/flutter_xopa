import 'package:xopa_app/repository/models/collaborate/collaboration.dart';
import 'package:xopa_app/repository/models/portfolio/portfolio.dart';
import 'package:xopa_app/repository/rest/collaborate_repository_rest.dart';

abstract class CollaborateRepository {
  Future<List<Collaboration>> getCollaborations();
  Future<Collaboration> createCollaboration(Collaboration collaboration);
  Future<void> addCollaborator(String collaborationId, Portfolio user);
  Future<void> removeCollaborator(String collaborationId, Portfolio user);
}

final CollaborateRepository collaborateRepository = new CollaborateRepositoryRest();



