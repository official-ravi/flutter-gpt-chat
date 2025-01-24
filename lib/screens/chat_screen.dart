import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/chat_bloc.dart';
import '../blocs/chat_event.dart';
import '../blocs/chat_state.dart';
import '../blocs/speech_bloc.dart';
import '../blocs/speech_event.dart';
import '../blocs/speech_state.dart';

class ChatScreen extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('AI Chatbot with Speech'),
        elevation: 0.5,
      ),
      body: Column(
        children: [
          // Chat Message List with bubble styling
          Expanded(
            child: BlocBuilder<ChatBloc, ChatState>(
              builder: (context, state) {
                if (state is ChatLoading) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 10),
                        Text("Bot is typing...",
                            style: TextStyle(fontStyle: FontStyle.italic)),
                      ],
                    ),
                  );
                } else if (state is ChatError) {
                  return Center(
                      child: Text(state.errorMessage,
                          style: TextStyle(color: Colors.red)));
                } else if (state is ChatSuccess) {
                  final messages = state.messages;
                  return ListView.builder(
                    reverse: true, // Show latest messages at the bottom
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final message = messages[index];
                      final isUser = message['sender'] == 'user';
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Align(
                          alignment: isUser
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: Container(
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color:
                                  isUser ? Colors.blue[200] : Colors.grey[300],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              crossAxisAlignment: isUser
                                  ? CrossAxisAlignment.end
                                  : CrossAxisAlignment.start,
                              children: [
                                Text(
                                  message['text'] ?? '',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }
                return Center(child: Text('Start chatting with the AI!'));
              },
            ),
          ),

          // Speech-to-Text & Input Field with send icon in front of other icons
          BlocBuilder<SpeechBloc, SpeechState>(
            builder: (context, state) {
              String speechText = '';
              if (state is SpeechListening) {
                speechText = state.recognizedText;
                _controller.text = speechText; // Dynamically update input field
              }
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.send, color: Colors.blueAccent),
                          onPressed: () {
                            final message = _controller.text.trim();
                            if (message.isNotEmpty) {
                              BlocProvider.of<ChatBloc>(context)
                                  .add(SendMessage(message));
                              _controller.clear();
                            }
                          },
                        ),
                        Expanded(
                          child: TextField(
                            controller: _controller,
                            decoration: InputDecoration(
                              hintText: 'Type or speak a message',
                              filled: true,
                              fillColor: Colors.grey[200],
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.mic, color: Colors.red),
                          onPressed: () {
                            BlocProvider.of<SpeechBloc>(context)
                                .add(StartSpeechRecognition());
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.stop, color: Colors.grey),
                          onPressed: () {
                            BlocProvider.of<SpeechBloc>(context)
                                .add(StopSpeechRecognition());
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
