import 'package:flutter/material.dart';
import 'package:surfify/constants/gaps.dart';

import '../../../../constants/sizes.dart';

class TutorialOne extends StatelessWidget {
  const TutorialOne({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "다음 멀리 있는 장소 서핑",
          style: TextStyle(
            fontSize: Sizes.size18,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        Gaps.v20,
        const Text(
          "Near",
          style: TextStyle(
            fontSize: Sizes.size20,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        Gaps.v10,
        Stack(
          children: [
            Container(
              width: 60,
              height: 200,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.7),
                borderRadius: BorderRadius.circular(50),
              ),
            ),
            Positioned(
              right: Sizes.size12,
              bottom: Sizes.size12,
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
        const Text(
          "Far",
          style: TextStyle(
            fontSize: Sizes.size20,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        Gaps.v96,
        Gaps.v96,
      ],
    );
  }
}
