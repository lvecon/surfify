import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:surfify/features/users/view_models/avatar_view_model.dart';
import 'package:surfify/features/users/view_models/user_view_model.dart';
import 'package:surfify/features/users/views/avatar.dart';
import 'package:surfify/widgets/form_button.dart';

import '../../constants/gaps.dart';
import '../../constants/sizes.dart';
import '../authentication/repos/authentication_repo.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});
  static const routeName = '/edit_profile_screen';

  @override
  createState() => _EditProfileState();
}

class _EditProfileState extends ConsumerState<EditProfileScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool able = true;

  Map<String, String> formData = {};

  void _onSubmitTap() {
    if (_formKey.currentState != null) {
      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();
        ref
            .read(usersProvider(ref.read(authRepo).user!.uid).notifier)
            .updateProfile(
              name: formData["name"],
              intro: formData['intro'],
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
  Widget build(BuildContext context) {
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
                    child: Form(
                      key: _formKey,
                      child: SizedBox(
                        height: 670,
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
                                onTap:
                                    isLoading ? null : () => _onAvatarTap(ref),
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
                            const Text(
                              '프로필 주소 (변경불가)',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontSize: Sizes.size16,
                              ),
                            ),
                            Gaps.v16,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  '@${data.profileAddress}',
                                  textAlign: TextAlign.left,
                                  style: const TextStyle(
                                    fontSize: Sizes.size20,
                                  ),
                                ),
                              ],
                            ),
                            Gaps.v6,
                            Gaps.v16,
                            const Text(
                              '이름 또는 별명',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontSize: Sizes.size16,
                              ),
                            ),
                            Gaps.v6,
                            TextFormField(
                              initialValue: data.name,
                              onChanged: (value) {
                                setState(() {
                                  if (_formKey.currentState!.validate()) {
                                    able = true;
                                  }
                                });
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return '이름을 작성해주세요';
                                } else if (utf8.encode(value).length >= 20) {
                                  return '20 Byte까지만 저장되어요...😒';
                                }
                                return null;
                              },
                              onSaved: (newValue) {
                                if (newValue != null) {
                                  formData['name'] = newValue;
                                }
                              },
                              cursorColor: Theme.of(context).primaryColor,
                              decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.grey.shade200,
                                  enabledBorder: const UnderlineInputBorder(
                                    borderSide: BorderSide.none,
                                  ),
                                  focusedBorder: const UnderlineInputBorder(
                                    borderSide: BorderSide.none,
                                  )),
                            ),
                            Gaps.v6,
                            Gaps.v16,
                            const Text(
                              '자기소개',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontSize: Sizes.size16,
                              ),
                            ),
                            Gaps.v6,
                            TextFormField(
                              initialValue: data.intro,
                              textInputAction: TextInputAction.done,
                              onChanged: (value) {
                                setState(() {
                                  if (_formKey.currentState!.validate()) {
                                    able = true;
                                  } else {
                                    able = false;
                                  }
                                });
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return '자기소개를 작성해주세요';
                                } else if (utf8.encode(value).length > 120) {
                                  return '120 Byte까지만 저장되어요...😒';
                                } else {
                                  return null;
                                }
                              },
                              onSaved: (newValue) {
                                if (newValue != null) {
                                  formData['intro'] = newValue;
                                }
                              },
                              maxLines: 5,
                              cursorColor: Theme.of(context).primaryColor,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.grey.shade200,
                                enabledBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide.none,
                                ),
                                focusedBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                            Gaps.v6
                          ],
                        ),
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
