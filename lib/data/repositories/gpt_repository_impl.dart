import '../../domain/entities/message.dart';
import '../../domain/repositories/gpt_repository.dart';
import '../datasources/gpt_remote_data_source.dart';

class GPTRepositoryImpl implements GPTRepository {
  final GPTRemoteDataSourceImpl dataSource;

  GPTRepositoryImpl(this.dataSource);

  @override
  Future<Message> sendMessage(String userInput) {
    return dataSource.sendMessageToGPT(userInput);
  }
}
