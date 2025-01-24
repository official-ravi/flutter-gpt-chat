import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:speech_to_text/speech_to_text.dart';

import 'speech_event.dart';
import 'speech_state.dart';

class SpeechBloc extends Bloc<SpeechEvent, SpeechState> {
  final SpeechToText _speechToText = SpeechToText();

  SpeechBloc() : super(SpeechInitial()) {
    on<StartSpeechRecognition>(_onStartSpeechRecognition);
    on<StopSpeechRecognition>(_onStopSpeechRecognition);
  }

  Future<void> _onStartSpeechRecognition(
      StartSpeechRecognition event, Emitter<SpeechState> emit) async {
    bool isAvailable = await _speechToText.initialize();
    if (isAvailable) {
      _speechToText.listen(onResult: (result) {
        emit(SpeechListening(result.recognizedWords));
      });
    } else {
      emit(SpeechError("Speech recognition is unavailable."));
    }
  }

  Future<void> _onStopSpeechRecognition(
      StopSpeechRecognition event, Emitter<SpeechState> emit) async {
    _speechToText.stop();
    emit(SpeechInitial());
  }
}
