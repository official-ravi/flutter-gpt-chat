import '../repositories/gpt_repository.dart';
import '../entities/message.dart';

class SendMessageUseCase {
  final GPTRepository repository;

  SendMessageUseCase(this.repository);

  Future<Message> call(String userInput) {
    return repository.sendMessage(userInput);
  }
}
