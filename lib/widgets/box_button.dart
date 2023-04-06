import 'package:flutter/material.dart';
import '../constants/sizes.dart';

class BoxButton extends StatelessWidget {
  final String text;
  final bool able;
  final Color mainColor;

  const BoxButton(
      {super.key,
      required this.text,
      required this.able,
      required this.mainColor});

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: 1,
      child: Container(
        height: 50,
        padding: const EdgeInsets.all(Sizes.size14),
        decoration: BoxDecoration(
          color: able ? mainColor : Colors.white,
          border: Border.all(
            color: mainColor,
            width: Sizes.size1,
          ),
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: able ? Colors.white : mainColor,
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
