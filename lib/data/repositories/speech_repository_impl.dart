import '../../domain/entities/speech_result.dart';
import '../../domain/repositories/speech_repository.dart';
import '../datasources/speech_to_text_data_source.dart';

class SpeechRepositoryImpl implements SpeechRepository {
  final SpeechToTextDataSourceImpl dataSource;

  SpeechRepositoryImpl(this.dataSource);

  @override
  Future<SpeechResult> startRecognition() {
    return dataSource.startRecognition();
  }
}
