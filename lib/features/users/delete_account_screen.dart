import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:surfify/features/initial_screen.dart';

import '../../constants/gaps.dart';
import '../../constants/sizes.dart';
import '../../widgets/box_button.dart';

class DeleteAccountScreen extends StatefulWidget {
  const DeleteAccountScreen({super.key});

  @override
  State<DeleteAccountScreen> createState() => _DeleteAccountScreenState();
}

class _DeleteAccountScreenState extends State<DeleteAccountScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String confirm = '';
  bool able = false;
  Map<String, String> formData = {};

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      height: size.height * 0.60,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Sizes.size14),
        color: Colors.white,
      ),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: false,
          centerTitle: false,
          elevation: 0,
          title: const Text(
            '탈퇴',
            style: TextStyle(
              fontSize: Sizes.size18,
              color: Colors.black,
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {
                context.pop();
              },
              icon: const FaIcon(
                FontAwesomeIcons.xmark,
                size: Sizes.size24,
                color: Colors.black,
              ),
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(
                16.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '@magoking님,',
                    style: TextStyle(
                      fontSize: Sizes.size16,
                    ),
                  ),
                  const Text(
                    '탈퇴를 하시려는 이유가 무엇인가요?',
                    style: TextStyle(
                      fontSize: Sizes.size16,
                    ),
                  ),
                  TextFormField(
                    textInputAction: TextInputAction.done,
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
                  Gaps.v24,
                  const Text(
                    '\'지금탈퇴’ 라고 입력하고 [탈퇴] 버튼을 누르면 탈퇴 처리됩니다.',
                    style: TextStyle(
                      fontSize: Sizes.size16,
                    ),
                  ),
                  TextFormField(
                    onChanged: (value) => {
                      confirm = value,
                      setState(
                        () => {
                          if (confirm == '지금탈퇴')
                            {able = true}
                          else
                            {able = false}
                        },
                      )
                    },
                    validator: (value) {
                      if (value != '지금탈퇴') {
                        return '';
                      }
                      return null;
                    },
                    textInputAction: TextInputAction.done,
                    maxLines: 1,
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
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: Sizes.size32,
            horizontal: Sizes.size16,
          ),
          child: GestureDetector(
            onTap: able
                ? () async {
                    return showDialog<void>(
                      context: context,
                      barrierDismissible: false, // user must tap button!
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('회원탈퇴'),
                          content: const Text('회원 탈퇴 하시겠습니까?'),
                          actions: <Widget>[
                            TextButton(
                              child: const Text(
                                '취소',
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            TextButton(
                              child: Text(
                                '회원탈퇴',
                                style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                              onPressed: () {
                                context.go(InitialScreen.routeName);
                              },
                            ),
                          ],
                        );
                      },
                    );
                  }
                : () {
                    if (_formKey.currentState != null) {
                      _formKey.currentState!.validate();
                    }
                  },
            child: BoxButton(
              text: "지금 탈퇴",
              able: able,
              mainColor: Colors.red,
            ),
          ),
        ),
      ),
    );
  }
}
