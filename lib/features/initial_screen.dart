import 'package:flutter/material.dart';
import 'package:surfify/widgets/box_button.dart';

import '../constants/gaps.dart';
import '../constants/sizes.dart';
import 'authentication/policy_agreement_screen.dart';

class InitialScreen extends StatelessWidget {
  const InitialScreen({super.key});

  void onRegisterTap(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => const PolicyAgreementScreen(),
    ));
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
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
              const BoxButton(
                text: 'Google 로그인',
                color: true,
              ),
              Gaps.v12,
              GestureDetector(
                  onTap: () {
                    onRegisterTap(context);
                  },
                  child: const BoxButton(text: '회원가입', color: false)),
            ],
          ),
        ],
      ),
    )));
  }
}
