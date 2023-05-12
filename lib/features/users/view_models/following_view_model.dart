import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../authentication/repos/authentication_repo.dart';
import '../repos/user_repo.dart';

class FollowingViewModel extends FamilyAsyncNotifier<bool, String> {
  late final UserRepository _usersRepository;
  late final AuthenticaitonRepository _authenticationRepository;

  Future<void> followUser({
    required String uid2,
  }) async {
    await _usersRepository.followUser(
        _authenticationRepository.user!.uid, uid2);
  }

  Future<bool> isFollowUser({
    required String uid2,
  }) async {
    return await _usersRepository.isFollowUser(
        _authenticationRepository.user!.uid, uid2);
  }

  @override
  FutureOr<bool> build(String arg) async {
    _usersRepository = ref.read(userRepo);
    _authenticationRepository = ref.read(authRepo);

    return _usersRepository.isFollowUser(
        _authenticationRepository.user!.uid, arg);
  }
}

final followProvider =
    AsyncNotifierProvider.family<FollowingViewModel, bool, String>(
  () => FollowingViewModel(),
);
