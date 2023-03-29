import 'package:flutter/material.dart';

class VideoScreen extends StatelessWidget {
  const VideoScreen({super.key});
  static const routeName = '/home_screen';

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body: SafeArea(
      child: Text('홈스크린'),
    ));
  }
}
