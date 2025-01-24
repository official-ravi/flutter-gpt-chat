import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/chat_bloc.dart';
import '../blocs/chat_event.dart';
import '../blocs/chat_state.dart';

class ChatScreen extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('GPT Chat - Clean Architecture')),
      body: Column(
        children: [
          // Chat Messages
          Expanded(
            child: BlocBuilder<ChatBloc, ChatState>(
              builder: (context, state) {
                if (state is ChatLoading) {
                  return Center(child: CircularProgressIndicator());
                } else if (state is ChatError) {
                  return Center(
                      child: Text(state.message,
                          style: TextStyle(color: Colors.red)));
                } else if (state is ChatSuccess) {
                  return ListTile(
                    leading: Icon(Icons.room, color: Colors.blue),
                    title: Text(state.botMessage.text),
                  );
                }
                return Center(child: Text('Start chatting!'));
              },
            ),
          ),
          // Input Field
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(hintText: 'Type a message'),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    final message = _controller.text.trim();
                    if (message.isNotEmpty) {
                      context.read<ChatBloc>().add(SendMessageEvent(message));
                      _controller.clear();
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
