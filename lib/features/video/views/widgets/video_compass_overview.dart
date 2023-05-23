import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../constants/sizes.dart';

class VideoCompassOverView extends StatefulWidget {
  final double latitude;
  final double longitude;

  const VideoCompassOverView({
    super.key,
    required this.latitude,
    required this.longitude,
  });

  @override
  State<VideoCompassOverView> createState() => _VideoCompassOverViewState();
}

class _VideoCompassOverViewState extends State<VideoCompassOverView> {
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
              FaIcon(
                FontAwesomeIcons.arrowUp,
                size: Sizes.size24,
                color: Theme.of(context).primaryColor,
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
    ]);
  }
}
