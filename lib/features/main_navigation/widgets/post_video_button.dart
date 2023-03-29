import 'package:flutter/material.dart';
import 'package:surfify/constants/sizes.dart';

class PostVideoButton extends StatelessWidget {
  const PostVideoButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Image.asset(
        'assets/images/App_Icon.png',
        height: Sizes.size24,
        width: Sizes.size24,
      ),
    );
    // clipBehavior: Clip.none,
    // children: [
    //   Positioned(
    //     right: 20,
    //     child: Container(
    //       height: 30,
    //       width: 25,
    //       padding: const EdgeInsets.symmetric(
    //         horizontal: Sizes.size8,
    //       ),
    //       decoration: BoxDecoration(
    //         color: const Color(0xff61D4F0),
    //         borderRadius: BorderRadius.circular(
    //           Sizes.size8,
    //         ),
    //       ),
    //     ),
    //   ),
    //   Positioned(
    //     left: 20,
    //     child: Container(
    //       height: 30,
    //       width: 25,
    //       padding: const EdgeInsets.symmetric(
    //         horizontal: Sizes.size8,
    //       ),
    //       decoration: BoxDecoration(
    //         color: Theme.of(context).primaryColor,
    //         borderRadius: BorderRadius.circular(
    //           Sizes.size8,
    //         ),
    //       ),
    //     ),
    //   ),
    //   Container(
    //     height: 30,
    //     padding: const EdgeInsets.symmetric(
    //       horizontal: Sizes.size12,
    //     ),
    //     decoration: BoxDecoration(
    //       color: Colors.white,
    //       borderRadius: BorderRadius.circular(
    //         Sizes.size6,
    //       ),
    //     ),
    //     child: const Center(
    //       child: FaIcon(
    //         FontAwesomeIcons.plus,
    //         color: Colors.black,
    //         size: 18,
    //       ),
    //     ),
    //   )
    // ],
  }
}
