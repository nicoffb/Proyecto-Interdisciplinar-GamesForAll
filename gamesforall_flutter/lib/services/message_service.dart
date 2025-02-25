import 'package:gamesforall_frontend/models/message_response.dart';
import 'package:gamesforall_frontend/repositories/message_repository.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import '../config/locator.dart';
import '../models/message_request.dart';
import 'localstorage_service.dart';

@Order(5)
@singleton
class MessageService {
  late LocalStorageService localStorageService;
  late final MessageRepository messageRepository;

  MessageService() {
    messageRepository = getIt<MessageRepository>();
    GetIt.I
        .getAsync<LocalStorageService>()
        .then((value) => localStorageService = value);
  }

  Future<List<MessageResponse>> getMessagesWithUser(String userId) async {
    return await messageRepository.getMessagesWithUser(userId);
  }

  Future<MessageResponse> addMessage(
      MessageRequest messageRequest, String userId) async {
    return await messageRepository.addMessage(messageRequest, userId);
  }
}
