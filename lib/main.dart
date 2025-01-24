import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'data/datasources/gpt_remote_data_source.dart';
import 'data/datasources/speech_to_text_data_source.dart';
import 'data/repositories/gpt_repository_impl.dart';
import 'data/repositories/speech_repository_impl.dart';
import 'domain/usecases/send_message_usecase.dart';
import 'domain/usecases/start_speech_recognition_usecase.dart';
import 'presentation/blocs/chat_bloc.dart';
import 'presentation/blocs/speech_bloc.dart';
import 'presentation/screens/chat_screen.dart';

void main() {
  // Dependencies

  // Retrieve the API key securely from dart-define
  const String apiKey =
      String.fromEnvironment('OPENAI_API_KEY', defaultValue: '');

  final gptDataSource = GPTRemoteDataSourceImpl(apiKey);
  final speechToTextDataSource = SpeechToTextDataSourceImpl(SpeechToText());
  final gptRepository = GPTRepositoryImpl(gptDataSource);
  final speechRepository = SpeechRepositoryImpl(speechToTextDataSource);
  final sendMessageUseCase = SendMessageUseCase(gptRepository);
  final startSpeechRecognitionUseCase =
      StartSpeechRecognitionUseCase(speechRepository);

  runApp(MyApp(
    sendMessageUseCase: sendMessageUseCase,
    startSpeechRecognitionUseCase: startSpeechRecognitionUseCase,
  ));
}

class MyApp extends StatelessWidget {
  final SendMessageUseCase sendMessageUseCase;
  final StartSpeechRecognitionUseCase startSpeechRecognitionUseCase;

  const MyApp({
    required this.sendMessageUseCase,
    required this.startSpeechRecognitionUseCase,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ChatBloc(sendMessageUseCase)),
        BlocProvider(create: (_) => SpeechBloc(startSpeechRecognitionUseCase)),
      ],
      child: MaterialApp(
        title: 'GPT Chat with Speech',
        home: ChatScreen(),
      ),
    );
  }
}
