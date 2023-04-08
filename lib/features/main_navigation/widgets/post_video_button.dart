import 'package:flutter/material.dart';
import 'package:surfify/constants/sizes.dart';

class PostVideoButton extends StatelessWidget {
  const PostVideoButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Sizes.size44,
      width: Sizes.size44,
      child: Image.asset(
        'assets/images/App_Icon_resize.png',
      ),
    );
  }
}
