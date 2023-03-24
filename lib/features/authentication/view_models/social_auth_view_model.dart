import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../utils.dart';
import '../repos/authentication_repo.dart';

class SocialAuthViewModel extends AsyncNotifier<void> {
  late final AuthenticaitonRepository _repository;

  @override
  FutureOr<void> build() {
    _repository = ref.read(authRepo);
  }

  Future<void> googleSignIn(BuildContext context) async {
    state = const AsyncValue.loading();
    state =
        await AsyncValue.guard(() async => await _repository.googleSignIn());
    if (state.hasError) {
      showFirebaseErrorSnack(context, state.error);
    } else {
      context.go("/home");
    }
  }
}

final socialAuthProvider = AsyncNotifierProvider<SocialAuthViewModel, void>(
  () => SocialAuthViewModel(),
);
