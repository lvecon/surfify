import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:surfify/widgets/box_button.dart';

import '../../constants/gaps.dart';
import '../../constants/sizes.dart';

class DetailOpinionScreen extends StatefulWidget {
  const DetailOpinionScreen({super.key});

  @override
  State<DetailOpinionScreen> createState() => _DetailOpinionScreenState();
}

class _DetailOpinionScreenState extends State<DetailOpinionScreen> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      height: size.height * 0.7,
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
            '조금 더 자세히 이야기 해주세요',
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
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '모든 신고 및 의견에 답변 드리지는 못해도\n모두 살펴보고 더 좋은 서비스를 위해 노력하고 있어요!\n적극적인 참여 너무나 감사해요',
                  style: TextStyle(
                    color: Colors.black.withOpacity(0.8),
                    height: 1.5,
                  ),
                ),
                Gaps.v12,
                TextFormField(
                  textInputAction: TextInputAction.done,
                  maxLines: 10,
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
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 48,
          ),
          child: GestureDetector(
            onTap: () {
              context.pop();
              context.pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('신고가 완료되었습니다')),
              );
            },
            child: BoxButton(
              text: "보내기",
              able: true,
              mainColor: Theme.of(context).primaryColor,
            ),
          ),
        ),
      ),
    );
  }
}
