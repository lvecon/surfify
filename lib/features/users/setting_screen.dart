import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:surfify/widgets/box_button.dart';

import '../../constants/gaps.dart';
import '../../constants/sizes.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    void _onClosePressed() {
      Navigator.of(context).pop();
    }

    return Container(
      height: size.height * 0.40,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Sizes.size14),
        color: Colors.white,
      ),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0x00f5f5f5),
          automaticallyImplyLeading: false,
          centerTitle: false,
          elevation: 0,
          title: const Text(
            '더 많은 옵션',
            style: TextStyle(
              fontSize: Sizes.size18,
              color: Colors.black,
            ),
          ),
          actions: [
            IconButton(
              onPressed: _onClosePressed,
              icon: const FaIcon(
                FontAwesomeIcons.xmark,
                size: Sizes.size24,
                color: Colors.black,
              ),
            )
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(children: [
            BoxButton(
              text: "지도 연결 - Google Map",
              able: false,
              mainColor: Theme.of(context).primaryColor,
            ),
            Gaps.v6,
            BoxButton(
              text: "Sign Out",
              able: false,
              mainColor: Theme.of(context).primaryColor,
            ),
            Gaps.v6,
            BoxButton(
              text: "Term & Policy",
              able: false,
              mainColor: Theme.of(context).primaryColor,
            ),
            Gaps.v6,
            const BoxButton(
              text: "Quit Service",
              able: false,
              mainColor: Colors.red,
            ),
          ]),
        ),
      ),
    );
  }
}
