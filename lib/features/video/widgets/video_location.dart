import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../constants/gaps.dart';
import '../../../constants/sizes.dart';

class VideoLocation extends StatelessWidget {
  const VideoLocation({super.key});
  final latitude = 37.4553;
  final longitude = 126.95;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: const [
            FaIcon(
              FontAwesomeIcons.locationDot,
              size: Sizes.size24,
              color: Colors.white,
            ),
            Gaps.h10,
            Text(
              '서울식물원',
              style: TextStyle(
                fontSize: 24,
                color: Colors.white,
              ),
            )
          ],
        ),
        Row(
          children: [
            Gaps.h28,
            GestureDetector(
              onTap: () async {
                await launchUrlString(
                    "https://www.google.com/maps/search/?api=1&query=$latitude,$longitude");
              },
              child: const Text(
                '서울시 강서구 마곡동 161',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            )
          ],
        )
      ],
    );
  }
}
