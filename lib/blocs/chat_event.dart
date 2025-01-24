abstract class ChatEvent {}

class SendMessage extends ChatEvent {
  final String userMessage;

  SendMessage(this.userMessage);
}
