import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../constants/gaps.dart';
import '../../../constants/sizes.dart';

class VideoLocation extends StatelessWidget {
  const VideoLocation({
    super.key,
    required this.name,
    required this.address,
  });
  final latitude = 37.4553;
  final longitude = 126.95;
  final name;
  final address;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const FaIcon(
              FontAwesomeIcons.locationDot,
              size: Sizes.size24,
              color: Colors.white,
            ),
            Gaps.h10,
            Text(
              name,
              style: const TextStyle(
                fontSize: Sizes.size24,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            )
          ],
        ),
        Gaps.v4,
        Row(
          children: [
            Gaps.h28,
            GestureDetector(
              onTap: () async {
                await launchUrlString(
                    "https://www.google.com/maps/search/?api=1&query=$latitude,$longitude");
              },
              child: Text(
                address,
                style: const TextStyle(
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
