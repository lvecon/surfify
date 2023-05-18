import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:geolocator/geolocator.dart';

import '../../../../constants/gaps.dart';
import '../../../../constants/sizes.dart';

class VideoRadar extends StatefulWidget {
  final double latitude;
  final double longitude;

  const VideoRadar(
      {super.key, required this.latitude, required this.longitude});

  @override
  State<VideoRadar> createState() => _VideoRadarState();
}

class _VideoRadarState extends State<VideoRadar> {
  double _direction = 0.00;
  StreamSubscription<CompassEvent>? stream;

  @override
  void initState() {
    super.initState();
    stream = FlutterCompass.events?.listen((event) async {
      setState(() {
        _direction = event.heading ?? 0.0;
      });
    });
  }

  @override
  void dispose() {
    stream?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 출발지
    const double lat1 = 35.71;
    const double lon1 = 139.73;

    const double purpleBallR = 8.0;
    const double whiteBallR = 25.0;

    double bearing = Geolocator.bearingBetween(
      lat1,
      lon1,
      widget.latitude,
      widget.longitude,
    );
    double x = (whiteBallR - purpleBallR) * sin(bearing * pi / 180);
    double y = (whiteBallR - purpleBallR) * cos(bearing * pi / 180);

    return Column(
      children: [
        SizedBox(
          height: 2 * whiteBallR,
          width: 2 * whiteBallR,
          child: Transform.rotate(
            angle: (-_direction) / 180 * pi,
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
                Positioned(
                  top: whiteBallR - purpleBallR - y,
                  left: whiteBallR - purpleBallR + x,
                  child: Container(
                    width: 2 * purpleBallR,
                    height: 2 * purpleBallR,
                    decoration: const BoxDecoration(
                      color: Color(0xffda6662),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ),
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
      ],
    );
  }
}
