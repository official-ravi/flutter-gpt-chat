import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/send_message_usecase.dart';
import '../../domain/entities/message.dart';
import 'chat_event.dart';
import 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final SendMessageUseCase sendMessageUseCase;

  ChatBloc(this.sendMessageUseCase) : super(ChatInitial()) {
    on<SendMessageEvent>(_onSendMessage);
  }

  Future<void> _onSendMessage(
      SendMessageEvent event, Emitter<ChatState> emit) async {
    emit(ChatLoading());

    try {
      final botMessage = await sendMessageUseCase(event.userMessage);
      emit(ChatSuccess(botMessage));
    } catch (error) {
      emit(ChatError('Failed to fetch response: $error'));
    }
  }
}
