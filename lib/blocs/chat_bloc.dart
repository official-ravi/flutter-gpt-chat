import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'chat_event.dart';
import 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  // Retrieve the API key securely from dart-define
  final String apiKey =
      const String.fromEnvironment('OPENAI_API_KEY', defaultValue: '');

  final List<Map<String, String>> _messages = [];

  ChatBloc() : super(ChatInitial()) {
    on<SendMessage>(_onSendMessage);
  }

  Future<void> _onSendMessage(
      SendMessage event, Emitter<ChatState> emit) async {
    final userMessage = event.userMessage;
    _messages.add({'sender': 'user', 'text': userMessage});
    emit(ChatLoading());

    try {
      final aiResponse = await _fetchAIResponse(userMessage);
      _messages.add({'sender': 'bot', 'text': aiResponse});
      emit(ChatSuccess(List.from(_messages)));
    } catch (e) {
      emit(ChatError('Oops! Something went wrong. Please try again.'));
    }
  }

  Future<String> _fetchAIResponse(String userMessage) async {
    if (apiKey.isEmpty) {
      throw Exception(
          'Missing OpenAI API key. Please set it using --dart-define.');
    }

    final response = await http.post(
      Uri.parse('https://api.openai.com/v1/completions'),
      headers: {
        'Authorization': 'Bearer $apiKey',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'model': 'text-davinci-003',
        'prompt': userMessage,
        'max_tokens': 100,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['choices'][0]['text'].trim();
    } else {
      throw Exception('API Error: ${response.statusCode}');
    }
  }
}
