import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:surfify/features/authentication/policy_agreement_screen.dart';
import 'package:surfify/features/main_navigation/main_navigation_screen.dart';
import '../../../utils.dart';
import '../repos/authentication_repo.dart';

class SocialAuthViewModel extends AsyncNotifier<void> {
  late final AuthenticaitonRepository _repository;

  @override
  FutureOr<void> build() {
    _repository = ref.read(authRepo);
  }

  Future<void> googleSignUp(BuildContext context) async {
    state = const AsyncValue.loading();
    state =
        await AsyncValue.guard(() async => await _repository.googleSignIn());
    if (state.hasError) {
      showFirebaseErrorSnack(context, state.error);
    } else {
      context.go(PolicyAgreementScreen.routeName);
    }
  }

  Future<void> googleSignIn(BuildContext context) async {
    state = const AsyncValue.loading();
    state =
        await AsyncValue.guard(() async => await _repository.googleSignIn());
    if (state.hasError) {
      showFirebaseErrorSnack(context, state.error);
    } else {
      context.go(MainNavigationScreen.routeName);
    }
  }
}

final socialAuthProvider = AsyncNotifierProvider<SocialAuthViewModel, void>(
  () => SocialAuthViewModel(),
);
