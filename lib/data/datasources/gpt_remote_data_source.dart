import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../domain/entities/message.dart';

class GPTRemoteDataSourceImpl {
  final String apiKey;

  GPTRemoteDataSourceImpl(this.apiKey);

  Future<Message> sendMessageToGPT(String userInput) async {
    final Uri url = Uri.parse('https://api.openai.com/v1/completions');

    // Ensure body is JSON-encoded
    final Map<String, dynamic> body = {
      'model': 'text-davinci-003',
      'prompt': userInput,
      'max_tokens': 100,
    };

    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $apiKey',
        'Content-Type': 'application/json', // Fixing the Content-Type to JSON
      },
      body: jsonEncode(body), // Encode body as JSON
    );

    // Check if the API response is successful
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return Message(
        sender: 'bot',
        text: data['choices'][0]['text'].trim(),
      );
    } else {
      // Log additional response details for debugging
      throw Exception(
          'Failed to fetch data. Status code: ${response.statusCode}, Response: ${response.body}');
    }
  }
}
