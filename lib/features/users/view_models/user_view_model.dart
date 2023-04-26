import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:surfify/features/users/models/user_profile_model.dart';
import 'package:surfify/features/users/repos/user_repo.dart';

import '../../authentication/repos/authentication_repo.dart';

class UsersViewModel extends AsyncNotifier<UserProfileModel> {
  late final UserRepository _usersRepository;
  late final AuthenticaitonRepository _authenticationRepository;

  @override
  FutureOr<UserProfileModel> build() async {
    _usersRepository = ref.read(userRepo);
    _authenticationRepository = ref.read(authRepo);

    if (_authenticationRepository.isLoggedIn) {
      final profile = await _usersRepository
          .findProfile(_authenticationRepository.user!.uid);
      if (profile != null) {
        return UserProfileModel.fromJson(profile);
      }
    }
    return UserProfileModel.empty();
  }

  Future<void> createAccount(UserCredential credential) async {
    state = const AsyncValue.loading();
    final profile = UserProfileModel(
      hasAvatar: false,
      link: "undefined",
      uid: credential.user!.uid,
      name: credential.user!.displayName ?? "undefined",
      profileAddress: credential.user!.email ?? "undefined",
      intro: "undefined",
      serviceAgree: false,
      serviceAgreeDate: DateTime.now().toString(),
      privacyAgree: false,
      privacyAgreeDate: DateTime.now().toString(),
      marketingAgree: false,
      marketingAgreeDate: DateTime.now().toString(),
    );
    _usersRepository.createProfile(profile);
    state = AsyncValue.data(profile);
  }

  Future<void> onAvatarUpload() async {
    if (state.value == null) return;
    state = AsyncValue.data(state.value!.copyWith(hasAvatar: true));
    await _usersRepository.updateUser(state.value!.uid, {"hasAvatar": true});
  }

  Future<void> registerProfile({
    required String? profileAddress,
    required String? name,
    required String? intro,
  }) async {
    state = AsyncValue.data(
      state.value!.copyWith(
        name: name,
        intro: intro,
        profileAddress: profileAddress,
      ),
    );
    await _usersRepository.updateUser(
      state.value!.uid,
      {
        "name": name,
        "intro": intro,
        "profileAddress": profileAddress,
      },
    );
  }

  Future<void> updateProfile({
    required String? name,
    required String? intro,
  }) async {
    state = AsyncValue.data(state.value!.copyWith(
      name: name,
      intro: intro,
    ));
    await _usersRepository.updateUser(state.value!.uid, {
      "name": name,
      "intro": intro,
    });
  }

  Future<void> updateAgreement({
    required bool? serviceAgree,
    required bool? privacyAgree,
    required bool? marketingAgree,
  }) async {
    state = AsyncValue.data(state.value!.copyWith(
      serviceAgree: serviceAgree,
      privacyAgree: privacyAgree,
      marketingAgree: marketingAgree,
    ));
    await _usersRepository.updateUser(state.value!.uid, {
      "serviceAgree": serviceAgree,
      "privacyAgree": privacyAgree,
      "marketingAgree": marketingAgree,
      "serviceAgreeDate": DateTime.now().toString(),
      "privacyAgreeDate": DateTime.now().toString(),
      "marketingAgreeDate": DateTime.now().toString(),
    });
  }
}

final usersProvider = AsyncNotifierProvider<UsersViewModel, UserProfileModel>(
  () => UsersViewModel(),
);
