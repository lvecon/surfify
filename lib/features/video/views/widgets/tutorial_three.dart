import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../constants/gaps.dart';
import '../../../constants/sizes.dart';

class TutorialThree extends StatelessWidget {
  const TutorialThree({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "흔들어서",
          style: TextStyle(
            fontSize: Sizes.size18,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        Gaps.v4,
        const Text(
          "현재위치 새로고침",
          style: TextStyle(
            fontSize: Sizes.size18,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        Gaps.v20,
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 20,
              height: 70,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.8),
              ),
            ),
            Gaps.h10,
            Container(
              width: 20,
              height: 110,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.8),
              ),
            ),
            Gaps.h10,
            FaIcon(
              FontAwesomeIcons.mobileScreen,
              size: Sizes.size128 + Sizes.size60,
              color: Colors.white.withOpacity(0.8),
            ),
            // Gaps.h10,
            Container(
              width: 20,
              height: 110,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.8),
              ),
            ),
            Gaps.h10,
            Container(
              width: 20,
              height: 70,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.8),
              ),
            ),
          ],
        ),
        Gaps.v12,
        Gaps.v96,
        Gaps.v96,
        Gaps.v52,
      ],
    );
  }
}
