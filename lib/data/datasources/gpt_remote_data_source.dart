import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../domain/entities/message.dart';

class GPTRemoteDataSourceImpl {
  final String apiKey;

  GPTRemoteDataSourceImpl(this.apiKey);

  Future<Message> sendMessageToGPT(String userInput) async {
    // Use the correct endpoint for chat completions (GPT-3.5 Turbo or GPT-4)
    final Uri url = Uri.parse('https://api.openai.com/v1/chat/completions');

    // Ensure body is JSON-encoded and matches the API requirements
    final Map<String, dynamic> body = {
      'model': 'gpt-3.5-turbo', // Updated to GPT-3.5 Turbo
      'messages': [
        {
          'role': 'user',
          'content': userInput,
        },
      ],
      'max_tokens': 100, // Optional: Limit the response length
      'temperature':
          0.7, // Optional: Control creativity (0 = deterministic, 1 = creative)
    };

    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $apiKey',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(body), // Encode body as JSON
    );

    // Check if the API response is successful
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      // Extract the response message from the correct field
      final responseMessage = data['choices'][0]['message']['content'].trim();
      return Message(
        sender: 'bot',
        text: responseMessage,
      );
    } else {
      // Log additional response details for debugging
      throw Exception(
        'Failed to fetch data. Status code: ${response.statusCode}, Response: ${response.body}',
      );
    }
  }
}
