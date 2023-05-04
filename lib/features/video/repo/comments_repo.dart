import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:surfify/features/video/models/comment_model.dart';

class CommentsRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> addComment(CommentModel commentModel) async {
    await _db
        .collection("videos")
        .doc(commentModel.videoId)
        .collection('comments')
        .add(commentModel.toJson());
  }

  Future<QuerySnapshot<Map<String, dynamic>>> fetchComments({
    String? videoId,
  }) async {
    final query = await _db
        .collection("videos")
        .doc(videoId)
        .collection('comments')
        .orderBy('createdAt', descending: true)
        .get();
    return query;
  }
}

final commentsRepo = Provider((ref) => CommentsRepository());
