import 'dart:math';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';

import '../../../constants/gaps.dart';
import '../../../constants/sizes.dart';

class VideoCompass extends StatelessWidget {
  const VideoCompass({super.key});

  @override
  Widget build(BuildContext context) {
    // 출발지
    const double lat1 = 35.71;
    const double lon1 = 139.73;

    //도착지
    const double lat2 = 37.57;
    const double lon2 = 126.98;

    const double purpleBallR = 8.0;
    const double whiteBallR = 25.0;

    double bearing = Geolocator.bearingBetween(
      lat1,
      lon1,
      lat2,
      lon2,
    );
    print(bearing);
    return Column(children: [
      SizedBox(
        height: 2 * whiteBallR,
        width: 2 * whiteBallR,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 2 * whiteBallR,
              height: 2 * whiteBallR,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),
            Transform.rotate(
              angle: bearing / 180 * pi,
              child: FaIcon(
                FontAwesomeIcons.arrowUp,
                size: Sizes.size24,
                color: Theme.of(context).primaryColor,
              ),
            ),
            const Text(
              'N\n\n\n',
              style: TextStyle(
                color: Colors.black,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
      Gaps.v3,
      const Text(
        '300m',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
          fontSize: Sizes.size16,
        ),
      ),
      const Text(
        '방금',
        style: TextStyle(
          color: Colors.white,
        ),
      ),
    ]);
  }
}
