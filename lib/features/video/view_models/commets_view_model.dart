import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../authentication/repos/authentication_repo.dart';
import '../models/comment_model.dart';
import '../repo/comments_repo.dart';

class CommentsViewModel
    extends FamilyAsyncNotifier<List<CommentModel>, String> {
  late final CommentsRepository _repository;
  List<CommentModel> _list = [];

  Future<List<CommentModel>> _fetchComments({
    String? videoId,
  }) async {
    final result = await _repository.fetchComments(videoId: videoId);
    final videos = result.docs.map(
      (doc) => CommentModel.fromJson(
        json: doc.data(),
        videoId: doc.id,
      ),
    );
    return videos.toList();
  }

  Future<void> uploadComment({
    String? videoId,
    String? comment,
  }) async {
    final user = ref.read(authRepo).user;
    await _repository.addComment(CommentModel(
      creatorId: user!.uid,
      comment: comment,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      likes: 0,
      videoId: videoId,
    ));
  }

  @override
  FutureOr<List<CommentModel>> build(String arg) async {
    _repository = ref.read(commentsRepo);
    _list = await _fetchComments(videoId: arg);
    return _list;
  }
}

final commentsProvider =
    AsyncNotifierProvider.family<CommentsViewModel, List<CommentModel>, String>(
  () => CommentsViewModel(),
);
