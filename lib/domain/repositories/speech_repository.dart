import '../entities/speech_result.dart';

abstract class SpeechRepository {
  Future<SpeechResult> startRecognition();
}
