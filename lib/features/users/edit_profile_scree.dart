import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:surfify/widgets/form_button.dart';

import '../../constants/gaps.dart';
import '../../constants/sizes.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});
  static const routeName = '/edit_profile_screen';

  @override
  State<EditProfileScreen> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfileScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool able = true;

  Map<String, String> formData = {};

  void _onSubmitTap() {
    if (_formKey.currentState != null) {
      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();
        Navigator.of(context).pop();
      }
    }
  }

  void _onClosePressed() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
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
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
          ),
          actions: [
            IconButton(
              onPressed: _onClosePressed,
              icon: const FaIcon(FontAwesomeIcons.xmark, color: Colors.black),
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
                        '프로필 주소 (변경불가)',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: Sizes.size16,
                        ),
                      ),
                      Gaps.v16,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: const [
                          Text(
                            '@dragmag',
                            textAlign: TextAlign.left,
                            style: TextStyle(
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
                        initialValue: "마곡드래곤",
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
                        initialValue: "주로 마곡에 맛집",
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
            child: FormButton(able: able, text: '변경완료'),
          ),
        ),
      ),
    );
  }
}
