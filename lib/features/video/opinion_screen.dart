import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:surfify/features/video/detail_opinion_screen.dart';
import 'package:surfify/widgets/box_button.dart';

import '../../constants/gaps.dart';
import '../../constants/sizes.dart';

class OptionScreen extends StatelessWidget {
  const OptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      height: size.height * 0.45,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Sizes.size14),
      ),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
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
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(children: [
            GestureDetector(
              onTap: () async {
                await showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (context) => const DetailOpinionScreen());
              },
              child: const BoxButton(
                  text: '이 콘텐츠는 부적절합니다', able: false, mainColor: Colors.red),
            ),
            Gaps.v6,
            GestureDetector(
              onTap: () async {
                await showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (context) => const DetailOpinionScreen());
              },
              child: const BoxButton(
                  text: '이 서퍼를 추천하지 않습니다', able: false, mainColor: Colors.red),
            ),
            Gaps.v6,
            GestureDetector(
              onTap: () async {
                await showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (context) => const DetailOpinionScreen());
              },
              child: const BoxButton(
                  text: '이 장소를 다시는 보지 않습니다',
                  able: false,
                  mainColor: Colors.red),
            ),
            Gaps.v6,
            GestureDetector(
              onTap: () async {
                await showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (context) => const DetailOpinionScreen());
              },
              child: BoxButton(
                  text: '서비스 개선 의견이 있습니다',
                  able: false,
                  mainColor: Theme.of(context).primaryColor),
            )
          ]),
        ),
      ),
    );
  }
}
