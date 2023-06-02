import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:surfify/features/users/view_models/user_view_model.dart';

import '../../../constants/gaps.dart';
import '../../../constants/sizes.dart';
import '../../authentication/repos/authentication_repo.dart';

class RegisterProfileText extends ConsumerStatefulWidget {
  const RegisterProfileText({super.key});
  @override
  createState() => RegisterProfileTextState();
}

class RegisterProfileTextState extends ConsumerState<RegisterProfileText> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool able = true;

  Map<String, String> formData = {};

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ref.watch(usersProvider(ref.read(authRepo).user!.uid)).when(
          error: (error, stackTrace) => Center(
            child: Text(error.toString()),
          ),
          loading: () => const Center(
            child: CircularProgressIndicator.adaptive(),
          ),
          data: (data) => Padding(
            padding: const EdgeInsets.all(
              Sizes.size16,
            ),
            child: Form(
              key: formKey,
              child: SizedBox(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                                if (formKey.currentState!.validate()) {
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
                          if (formKey.currentState!.validate()) {
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
                          if (formKey.currentState!.validate()) {
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
                  ],
                ),
              ),
            ),
          ),
        );
  }
}
