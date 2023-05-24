import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:surfify/features/message/model/message_model.dart';

import '../../authentication/repos/authentication_repo.dart';
import '../repo/message_repo.dart';

class MessageViewModel extends AsyncNotifier<List<MessageModel>> {
  late final MessageRepository _repository;
  List<MessageModel> _list = [];

  Future<List<MessageModel>> _fetchMessage() async {
    final userId = ref.read(authRepo).user!.uid;
    final result = await _repository.fetchMessage(uid: userId);
    final messages = result.docs.map(
      (message) => MessageModel.fromJson(
        json: message.data(),
      ),
    );
    return messages.toList();
  }

  Future<void> refresh() async {
    final messages = await _fetchMessage();
    _list = messages;
    state = AsyncValue.data(messages);
  }

  Future<void> deleteMessage(MessageModel message) async {
    await _repository.deleteMessage(message);
  }

  Future<void> deleteAllMessage() async {
    final userId = ref.read(authRepo).user!.uid;
    await _repository.deleteAllMessage(userId);
  }

  Future<void> addMessage({
    String? videoId,
    String? comment,
    String? receiverId,
  }) async {
    final user = ref.read(authRepo).user;
    await _repository.addMessage(MessageModel(
        creatorId: user!.uid,
        comment: comment!,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        receiverId: receiverId!,
        videoId: videoId!,
        messageId: ""));
  }

  @override
  FutureOr<List<MessageModel>> build() async {
    _repository = ref.read(messageRepo);
    _list = await _fetchMessage();
    return _list;
  }
}

final messageProvider =
    AsyncNotifierProvider<MessageViewModel, List<MessageModel>>(
  () => MessageViewModel(),
);
