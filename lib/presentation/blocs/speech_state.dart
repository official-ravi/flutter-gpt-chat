abstract class SpeechState {}

class SpeechInitial extends SpeechState {}

class SpeechListening extends SpeechState {
  final String recognizedText;

  SpeechListening(this.recognizedText);
}

class SpeechError extends SpeechState {
  final String errorMessage;

  SpeechError(this.errorMessage);
}
