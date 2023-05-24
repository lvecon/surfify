import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../repos/user_repo.dart';

class FollowingListViewModel extends FamilyAsyncNotifier<List<String>, String> {
  late final UserRepository _repository;
  List<String> _list = [];

  Future<List<String>> _fetchFollowing(String arg) async {
    final result = await _repository.fetchFollowings(arg);
    final followings = result.docs.map((doc) => doc['uid'].toString());
    return followings.toList();
  }

  Future<void> refresh(String arg) async {
    final result = await _fetchFollowing(arg);
    _list = result;
    state = AsyncValue.data(_list);
  }

  @override
  FutureOr<List<String>> build(String arg) async {
    _repository = ref.read(userRepo);
    _list = await _fetchFollowing(arg);
    return _list;
  }
}

final followingListProvider =
    AsyncNotifierProvider.family<FollowingListViewModel, List<String>, String>(
  () => FollowingListViewModel(),
);
