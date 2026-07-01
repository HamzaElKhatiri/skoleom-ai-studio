import 'package:skoleom_ai_studio/services/mock_repository.dart';
import 'package:skoleom_ai_studio/services/studio_repository.dart';

class RepositoryProvider {
  RepositoryProvider._();

  static StudioRepository _instance = const MockRepository();

  static StudioRepository get instance => _instance;

  static void configure(StudioRepository repository) {
    _instance = repository;
  }
}
