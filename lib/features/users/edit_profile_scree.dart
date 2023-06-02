import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:surfify/features/users/view_models/avatar_view_model.dart';
import 'package:surfify/features/users/view_models/user_view_model.dart';
import 'package:surfify/features/users/views/avatar.dart';
import 'package:surfify/features/users/views/profile_text.dart';

import '../../constants/gaps.dart';
import '../../constants/sizes.dart';
import '../../widgets/form_button.dart';
import '../authentication/repos/authentication_repo.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});
  static const routeName = '/edit_profile_screen';

  @override
  createState() => _EditProfileState();
}

class _EditProfileState extends ConsumerState<EditProfileScreen> {
  final GlobalKey<ProfileTextState> _formKey = GlobalKey<ProfileTextState>();
  bool able = true;

  final TextEditingController _nameTextEditingController =
      TextEditingController();
  final TextEditingController _expTextEditingController =
      TextEditingController();

  Map<String, String> formData = {};

  void _onSubmitTap() {
    print(_formKey.currentState);
    if (_formKey.currentState != null) {
      if (_formKey.currentState!.formKey.currentState!.validate()) {
        _formKey.currentState!.formKey.currentState!.save();
        ref
            .read(usersProvider(ref.read(authRepo).user!.uid).notifier)
            .updateProfile(
              name: _formKey.currentState!.formData["name"],
              intro: _formKey.currentState!.formData['intro'],
            );
        Navigator.of(context).pop();
      }
    }
  }

  void _onClosePressed() {
    Navigator.of(context).pop();
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
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final name = ref.watch(usersProvider(ref.read(authRepo).user!.uid));
    final size = MediaQuery.of(context).size;
    final isLoading = ref.watch(avatarProvider).isLoading;

    return ref.watch(usersProvider(ref.read(authRepo).user!.uid)).when(
          error: (error, stackTrace) => Center(
            child: Text(error.toString()),
          ),
          loading: () => const Center(
            child: CircularProgressIndicator.adaptive(),
          ),
          data: (data) => Container(
            height: size.height * 0.95,
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Sizes.size14),
              color: Colors.white,
            ),
            child: Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: false,
                centerTitle: false,
                title: const Text(
                  'Edit Profile',
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.w600),
                ),
                actions: [
                  IconButton(
                    onPressed: _onClosePressed,
                    icon: const FaIcon(FontAwesomeIcons.xmark,
                        color: Colors.black),
                  ),
                ],
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Avatar(
                                name: data.name,
                                hasAvatar: data.hasAvatar,
                                uid: data.uid),
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
                          ProfileText(key: _formKey)
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
                  child: FormButton(able: able, text: '변경완료'),
                ),
              ),
            ),
          ),
        );
  }
}
