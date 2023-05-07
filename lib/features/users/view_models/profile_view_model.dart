import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:surfify/features/users/models/thumb_nail_model.dart';
import 'package:surfify/features/users/view_models/user_view_model.dart';

import '../repos/user_repo.dart';

class ProfileViewModel
    extends FamilyAsyncNotifier<List<ThumbnailModel>, String> {
  late final UserRepository _repository;
  List<ThumbnailModel> _list = [];

  Future<List<ThumbnailModel>> _fetchThumbnail(String arg) async {
    final result = await _repository
        .fetchThumbnail(ref.read(usersProvider(arg)).value!.uid);
    final videos =
        result.docs.map((doc) => ThumbnailModel.fromJson(doc.data()));
    return videos.toList();
  }

  @override
  FutureOr<List<ThumbnailModel>> build(String arg) async {
    _repository = ref.read(userRepo);
    _list = await _fetchThumbnail(arg);
    return _list;
  }
}

final profileProvider = AsyncNotifierProvider.family<ProfileViewModel,
    List<ThumbnailModel>, String>(
  () => ProfileViewModel(),
);
