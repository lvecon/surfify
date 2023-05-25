import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../../constants/gaps.dart';
import '../../../../constants/sizes.dart';

class VideoLocation extends StatelessWidget {
  const VideoLocation({
    super.key,
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.url,
  });
  final double latitude;
  final double longitude;
  final String name;
  final String address;
  final String url;

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
            SizedBox(
              width: 250,
              child: Text(
                name,
                style: const TextStyle(
                  fontSize: Sizes.size20 + Sizes.size2,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
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
                //_openKakaoMapScreen(context, name, latitude, longitude);

                await launchUrlString("http://place.map.kakao.com/$url");
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

//   Future<void> _openKakaoMapScreen(BuildContext context, String name,
//       double latitude, double longitude) async {
//   //  KakaoMapUtil util = KakaoMapUtil();
//    // String url = await util.getMapScreenURL(longitude, latitude, name: name);

//     Navigator.push(
//         context, MaterialPageRoute(builder: (_) => KakaoMapScreen(url: url)));
//   }
// }
}
