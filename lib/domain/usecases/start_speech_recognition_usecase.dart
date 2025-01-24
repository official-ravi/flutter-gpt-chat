import '../entities/speech_result.dart';
import '../repositories/speech_repository.dart';

class StartSpeechRecognitionUseCase {
  final SpeechRepository repository;

  StartSpeechRecognitionUseCase(this.repository);

  Future<SpeechResult> call() {
    return repository.startRecognition();
  }
}
