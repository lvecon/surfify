import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:surfify/features/authentication/view_models/social_auth_view_model.dart';
import 'package:surfify/widgets/box_button.dart';

import '../constants/gaps.dart';
import '../constants/sizes.dart';
import 'authentication/policy_agreement_screen.dart';

class InitialScreen extends ConsumerWidget {
  const InitialScreen({super.key});

  static const routeName = "/";

  void onRegisterTap(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => const PolicyAgreementScreen(),
    ));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
            child: Padding(
          padding: const EdgeInsets.all(Sizes.size36),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  SizedBox(height: screenHeight * 0.2),
                  Image.asset(
                    'assets/images/App_Icon.png',
                    height: Sizes.size128,
                    width: Sizes.size128,
                  ),
                  Gaps.v10,
                  const Text(
                    'SURFI',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Text(
                    '어디갈까?',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () => ref
                        .read(socialAuthProvider.notifier)
                        .googleSignIn(context),
                    child: BoxButton(
                      text: 'Google 로그인',
                      able: true,
                      mainColor: Theme.of(context).primaryColor,
                    ),
                  ),
                  Gaps.v12,
                  GestureDetector(
                      onTap: () {
                        ref
                            .read(socialAuthProvider.notifier)
                            .googleSignUp(context);
                        onRegisterTap(context);
                      },
                      child: BoxButton(
                        text: '회원가입',
                        able: false,
                        mainColor: Theme.of(context).primaryColor,
                      )),
                ],
              ),
            ],
          ),
        )));
  }
}
