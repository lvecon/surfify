import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:surfify/features/video/video_recording_screen.dart';
import 'package:surfify/widgets/form_button.dart';

import '../../constants/gaps.dart';
import '../../constants/sizes.dart';

class RegisterProfileScreen extends StatefulWidget {
  const RegisterProfileScreen({super.key});
  static const routeName = '/register_profile_screen';

  @override
  State<RegisterProfileScreen> createState() => _RegisterProfileState();
}

class _RegisterProfileState extends State<RegisterProfileScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool able = false;

  Map<String, String> formData = {};

  void _onSubmitTap() {
    if (_formKey.currentState != null) {
      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();
        context.go(VideoRecordingScreen.routeName);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          '프로필 등록',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
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
                    const Center(
                      child: CircleAvatar(
                        radius: 64,
                        child: SizedBox(
                          height: Sizes.size128,
                          width: Sizes.size128,
                          child: CircleAvatar(
                            radius: 50,
                            foregroundImage: NetworkImage(
                                "http://file3.instiz.net/data/cached_img/upload/2019/06/22/15/04187419bdd68827a847fdbdd65edcda.jpg"),
                            child: Text("마곡냥"),
                          ),
                        ),
                      ),
                    ),
                    Gaps.v16,
                    Center(
                      child: Text(
                        '사진 변경',
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: Sizes.size16,
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
                                formData['profile'] = newValue;
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
                          formData['nickname'] = newValue;
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
                          formData['selfIntroduction'] = newValue;
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
    );
  }
}
