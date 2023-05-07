import 'package:flutter/material.dart';

import '../../../../constants/gaps.dart';
import '../../../../constants/sizes.dart';

class TutorialTwo extends StatelessWidget {
  const TutorialTwo({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "같은 장소",
          style: TextStyle(
            fontSize: Sizes.size18,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        Gaps.v4,
        const Text(
          "다른 영상 보기",
          style: TextStyle(
            fontSize: Sizes.size18,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        Gaps.v10,
        Stack(
          children: [
            Container(
              width: 220,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.7),
                borderRadius: BorderRadius.circular(50),
              ),
            ),
            Positioned(
              right: Sizes.size8,
              top: Sizes.size12,
              child: Container(
                width: Sizes.size36,
                height: Sizes.size36,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        ),
        Gaps.v12,
        Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text(
              "New",
              style: TextStyle(
                fontSize: Sizes.size20,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            Gaps.h96,
            Text(
              "Old",
              style: TextStyle(
                fontSize: Sizes.size20,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        Gaps.v96,
        Gaps.v96,
        Gaps.v52,
      ],
    );
  }
}
