import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:surfify/features/users/models/thumb_nail_model.dart';

import '../../authentication/repos/authentication_repo.dart';
import '../repos/user_repo.dart';

class ProfileViewModel extends AsyncNotifier<List<ThumbnailModel>> {
  late final UserRepository _repository;
  List<ThumbnailModel> _list = [];

  Future<List<ThumbnailModel>> _fetchThumbnail() async {
    final result =
        await _repository.fetchThumbnail(ref.read(authRepo).user!.uid);
    final videos =
        result.docs.map((doc) => ThumbnailModel.fromJson(doc.data()));
    return videos.toList();
  }

  @override
  FutureOr<List<ThumbnailModel>> build() async {
    _repository = ref.read(userRepo);
    _list = await _fetchThumbnail();
    return _list;
  }
}

final profileProvider =
    AsyncNotifierProvider<ProfileViewModel, List<ThumbnailModel>>(
  () => ProfileViewModel(),
);
