import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:surfify/features/users/view_models/user_view_model.dart';

import '../../video/models/video_model.dart';
import '../repos/user_repo.dart';

class ProfileViewModel extends FamilyAsyncNotifier<List<VideoModel>, String> {
  late final UserRepository _repository;
  List<VideoModel> _list = [];

  Future<List<VideoModel>> _fetchThumbnail(String arg) async {
    final result = await _repository
        .fetchThumbnail(ref.read(usersProvider(arg)).value!.uid);
    final videos = result.docs
        .map((doc) => VideoModel.fromJson(json: doc.data(), videoId: doc.id));
    return videos.toList();
  }

  @override
  FutureOr<List<VideoModel>> build(String arg) async {
    _repository = ref.read(userRepo);
    _list = await _fetchThumbnail(arg);
    return _list;
  }
}

final profileProvider =
    AsyncNotifierProvider.family<ProfileViewModel, List<VideoModel>, String>(
  () => ProfileViewModel(),
);
