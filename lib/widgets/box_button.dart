import 'package:flutter/material.dart';
import '../constants/sizes.dart';

class BoxButton extends StatelessWidget {
  final String text;
  final bool color;

  const BoxButton({super.key, required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: 1,
      child: Container(
        padding: const EdgeInsets.all(Sizes.size14),
        decoration: BoxDecoration(
          color: color ? Theme.of(context).primaryColor : Colors.white,
          border: Border.all(
            color: Theme.of(context).primaryColor,
            width: Sizes.size1,
          ),
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: color ? Colors.white : Theme.of(context).primaryColor,
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
