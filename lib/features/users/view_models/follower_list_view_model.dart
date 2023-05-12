import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../repos/user_repo.dart';

class FollowerListViewModel extends FamilyAsyncNotifier<List<String>, String> {
  late final UserRepository _repository;
  List<String> _list = [];

  Future<List<String>> _fetchFollowers(String arg) async {
    final result = await _repository.fetchFollowers(arg);
    final followers = result.docs.map((doc) => (doc['uid'].toString()));
    return followers.toList();
  }

  Future<void> refresh(String arg) async {
    final result = await _fetchFollowers(arg);
    _list = result;
    state = AsyncValue.data(_list);
  }

  @override
  FutureOr<List<String>> build(String arg) async {
    _repository = ref.read(userRepo);
    _list = await _fetchFollowers(arg);
    return _list;
  }
}

final followerListProvider =
    AsyncNotifierProvider.family<FollowerListViewModel, List<String>, String>(
  () => FollowerListViewModel(),
);
