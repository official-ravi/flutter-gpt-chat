abstract class ChatState {}

class ChatInitial extends ChatState {}

class ChatLoading extends ChatState {}

class ChatSuccess extends ChatState {
  final List<Map<String, String>> messages;

  ChatSuccess(this.messages);
}

class ChatError extends ChatState {
  final String errorMessage;

  ChatError(this.errorMessage);
}
