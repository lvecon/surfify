import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:surfify/features/authentication/repos/authentication_repo.dart';
import 'package:surfify/features/authentication/views/register_profile_text.dart';
import 'package:surfify/widgets/form_button.dart';

import '../../../constants/gaps.dart';
import '../../../constants/sizes.dart';
import '../../users/view_models/avatar_view_model.dart';
import '../../users/view_models/user_view_model.dart';
import '../../users/views/avatar.dart';
import '../../video/views/video_tutorial/video_create_tutorial.dart';

class RegisterProfileScreen extends ConsumerStatefulWidget {
  const RegisterProfileScreen({super.key});
  static const routeName = '/register_profile_screen';

  @override
  createState() => _RegisterProfileState();
}

class _RegisterProfileState extends ConsumerState<RegisterProfileScreen> {
  final GlobalKey<RegisterProfileTextState> _formKey =
      GlobalKey<RegisterProfileTextState>();
  bool able = true;
  late final uid = ref.read(authRepo).user!.uid;

  Map<String, String> formData = {};
  void _onSubmitTap() {
    if (_formKey.currentState!.formKey.currentState != null) {
      if (_formKey.currentState!.formKey.currentState!.validate()) {
        _formKey.currentState!.formKey.currentState!.save();
        ref.read(usersProvider(uid).notifier).registerProfile(
            name: _formKey.currentState!.formData["name"],
            intro: _formKey.currentState!.formData['intro'],
            profileAddress: _formKey.currentState!.formData['profileAddress']);
        context.go(VideoCreateTutorial.routeName);
        //context.go(MainNavigationScreen.routeName);
      }
    }
  }

  Future<void> _onAvatarTap(WidgetRef ref) async {
    final xfile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 40,
      maxHeight: 150,
      maxWidth: 150,
    );
    if (xfile != null) {
      final file = File(xfile.path);
      await ref.read(avatarProvider.notifier).uploadAvatar(file);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(avatarProvider).isLoading;
    return ref.watch(usersProvider(uid)).when(
        error: (error, stackTrace) => Center(
              child: Text(error.toString()),
            ),
        loading: () => const Center(
              child: CircularProgressIndicator.adaptive(),
            ),
        data: (data) => Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: false,
                title: const Text(
                  '프로필 등록',
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.w600),
                ),
                backgroundColor: const Color(0x00fafafa),
                elevation: 0,
              ),
              body: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(
                    Sizes.size16,
                  ),
                  child: SingleChildScrollView(
                    child: SizedBox(
                      height: 670,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Avatar(
                              name: data.name,
                              hasAvatar: data.hasAvatar,
                              uid: data.uid,
                            ),
                          ),
                          Gaps.v16,
                          Center(
                            child: GestureDetector(
                              onTap: isLoading ? null : () => _onAvatarTap(ref),
                              child: Text(
                                '사진 변경',
                                style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: Sizes.size16,
                                ),
                              ),
                            ),
                          ),
                          Gaps.v16,
                          RegisterProfileText(key: _formKey),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              bottomNavigationBar: BottomAppBar(
                elevation: 0,
                color: const Color(0x00fafafa),
                child: GestureDetector(
                  onTap: _onSubmitTap,
                  child: FormButton(able: able, text: '다음'),
                ),
              ),
            ));
  }
}
