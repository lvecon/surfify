import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';

import '../../../../constants/gaps.dart';
import '../../../../constants/sizes.dart';
import '../../../../normalize/distance.dart';
import '../../../../normalize/time.dart';

class VideoCompass extends StatefulWidget {
  final double latitude;
  final double longitude;
  final double currentLatitude;
  final double currentLongitude;
  final int createdAt;

  const VideoCompass(
      {super.key,
      required this.latitude,
      required this.longitude,
      required this.currentLatitude,
      required this.currentLongitude,
      required this.createdAt});

  @override
  State<VideoCompass> createState() => _VideoCompassState();
}

class _VideoCompassState extends State<VideoCompass> {
  // 출발지

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
    const double whiteBallR = 25.0;

    double bearing = Geolocator.bearingBetween(
      widget.currentLatitude,
      widget.currentLongitude,
      widget.latitude,
      widget.longitude,
    );
    return Column(children: [
      Transform.rotate(
        angle: (-_direction) / 180 * pi,
        child: SizedBox(
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
      ),
      Gaps.v3,
      Text(
        distance(widget.currentLongitude, widget.currentLatitude,
            widget.longitude, widget.latitude),
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
          fontSize: Sizes.size16,
        ),
      ),
      Text(
        nomarlizeTime(widget.createdAt),
        style: const TextStyle(
          color: Colors.white,
        ),
      ),
    ]);
  }
}
