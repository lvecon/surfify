import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../constants/gaps.dart';
import '../../../../constants/sizes.dart';

class SearchBar extends StatelessWidget {
  const SearchBar({super.key});

  final searched = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: searched ? Theme.of(context).primaryColor : Colors.transparent,
        borderRadius: BorderRadius.circular(16),
      ),
      width: 280,
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: const [
            FaIcon(
              FontAwesomeIcons.magnifyingGlass,
              size: Sizes.size18,
              color: Colors.white,
            ),
            Gaps.h6,
            Text(
              '주변 모든 장소 서핑',
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
