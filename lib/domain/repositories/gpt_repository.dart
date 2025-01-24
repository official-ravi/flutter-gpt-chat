import '../entities/message.dart';

abstract class GPTRepository {
  Future<Message> sendMessage(String userInput);
}
