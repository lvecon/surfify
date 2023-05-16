import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:surfify/features/video/models/video_model.dart';

import '../../authentication/repos/authentication_repo.dart';
import '../repo/videos_repo.dart';

class VideoPostViewModel extends FamilyAsyncNotifier<bool, String> {
  late final VideosRepository _repository;
  late final String _videoId;
  late bool _isLiked;

  @override
  FutureOr<bool> build(String arg) async {
    _videoId = arg;
    _repository = ref.read(videosRepo);
    final user = ref.read(authRepo).user!;
    _isLiked = await _repository.isLikeVideo(_videoId, user.uid);
    return _isLiked;
  }

  Future<void> toggleLikeVideo() async {
    final user = ref.read(authRepo).user;
    await _repository.likeVideo(_videoId, user!.uid);
    _isLiked = !_isLiked;
    state = AsyncValue.data(_isLiked);
  }

  Future<void> deleteVideo(VideoModel videoModel) async {
    await _repository.deleteVideo(videoModel);
  }
}

final videoPostProvider =
    AsyncNotifierProvider.family<VideoPostViewModel, bool, String>(
  () => VideoPostViewModel(),
);
