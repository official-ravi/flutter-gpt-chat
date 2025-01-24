import 'package:speech_to_text/speech_to_text.dart';
import '../../domain/entities/speech_result.dart';

class SpeechToTextDataSourceImpl {
  final SpeechToText speechToText;

  SpeechToTextDataSourceImpl(this.speechToText);

  Future<SpeechResult> startRecognition() async {
    final available = await speechToText.initialize();
    if (!available) throw Exception('Speech-to-Text is not available.');

    final result =
        await speechToText.listen(onResult: (result) {}).asStream().first;
    return SpeechResult(recognizedWords: result.recognizedWords);
  }
}
