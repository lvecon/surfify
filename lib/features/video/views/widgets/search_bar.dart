import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../constants/gaps.dart';
import '../../../../constants/sizes.dart';

class SearchBar extends StatelessWidget {
  final List<String> searchcondition;
  const SearchBar({
    super.key,
    required this.searchcondition,
  });

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
          children: [
            const FaIcon(
              FontAwesomeIcons.magnifyingGlass,
              size: Sizes.size18,
              color: Colors.white,
            ),
            Gaps.h6,
            searchcondition.isEmpty
                ? const Text(
                    '주변 모든 장소 서핑',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  )
                : SizedBox(
                    child: Wrap(children: [
                      for (var keyword in searchcondition)
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                16,
                              ),
                              color: keyword.toString().contains('@')
                                  ? Theme.of(context)
                                      .primaryColor
                                      .withOpacity(0.7)
                                  : Colors.red.withOpacity(0.7),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    keyword,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Gaps.h6,
                                ],
                              ),
                            ),
                          ),
                        )
                    ]),
                  ),
          ],
        ),
      ),
    );
  }
}
