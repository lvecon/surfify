import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:surfify/features/message/model/message_model.dart';

class MessageRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> addMessage(MessageModel message) async {
    await _db
        .collection("users")
        .doc(message.receiverId)
        .collection('message')
        .add(message.toJson());
  }

  Future<void> deleteMessage(MessageModel message) async {
    await _db
        .collection("users")
        .doc(message.receiverId)
        .collection("message")
        .doc(message.messageId)
        .delete();
  }

  Future<QuerySnapshot<Map<String, dynamic>>> fetchMessage({
    String? uid,
  }) async {
    final query = await _db
        .collection("users")
        .doc(uid)
        .collection('message')
        .orderBy('createdAt', descending: false)
        .get();
    return query;
  }
}

final messageRepo = Provider((ref) => MessageRepository());
