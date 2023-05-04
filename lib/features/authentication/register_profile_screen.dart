import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:surfify/features/authentication/repos/authentication_repo.dart';
import 'package:surfify/widgets/form_button.dart';

import '../../constants/gaps.dart';
import '../../constants/sizes.dart';
import '../users/view_models/avatar_view_model.dart';
import '../users/view_models/user_view_model.dart';
import '../users/views/avatar.dart';
import '../video/views/video_tutorial/video_create_tutorial.dart';

class RegisterProfileScreen extends ConsumerStatefulWidget {
  const RegisterProfileScreen({super.key});
  static const routeName = '/register_profile_screen';

  @override
  createState() => _RegisterProfileState();
}

class _RegisterProfileState extends ConsumerState<RegisterProfileScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool able = false;
  late final uid = ref.read(authRepo).user!.uid;

  Map<String, String> formData = {};

  void _onSubmitTap() {
    if (_formKey.currentState != null) {
      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();
        ref.read(usersProvider(uid).notifier).registerProfile(
            name: formData["name"],
            intro: formData['intro'],
            profileAddress: formData['profileAddress']);
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
                                uid: data.uid,
                              ),
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
                              '프로필 주소',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontSize: Sizes.size16,
                              ),
                            ),
                            Gaps.v16,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const Text(
                                  '@',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontSize: Sizes.size32,
                                  ),
                                ),
                                Gaps.h6,
                                Flexible(
                                  child: TextFormField(
                                    onChanged: (value) {
                                      setState(() {
                                        if (_formKey.currentState!.validate()) {
                                          able = true;
                                        }
                                      });
                                    },
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return '프로필 주소를 입력해주세요';
                                      } else if (value == 'madragon') {
                                        return "음 그 이름은 주인이 있네요...😒";
                                      }
                                      return null;
                                    },
                                    onSaved: (newValue) {
                                      if (newValue != null) {
                                        formData['profileAddress'] = newValue;
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
                                      ),
                                    ),
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
                  child: FormButton(able: able, text: '다음'),
                ),
              ),
            ));
  }
}
