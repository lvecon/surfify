import 'package:flutter/material.dart';

class TutorialScreen extends StatelessWidget {
  const TutorialScreen({super.key});
  static const routeName = '/tutorial_screen';

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body: SafeArea(
      child: Text('튜토리얼'),
    ));
  }
}
