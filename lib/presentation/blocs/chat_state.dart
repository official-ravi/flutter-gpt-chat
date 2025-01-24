import 'package:fluttergptchat/domain/entities/message.dart';

abstract class ChatState {}

class ChatInitial extends ChatState {}

class ChatLoading extends ChatState {}

class ChatSuccess extends ChatState {
  final Message botMessage;

  ChatSuccess(this.botMessage);
}

class ChatError extends ChatState {
  final String message;

  ChatError(this.message);
}
