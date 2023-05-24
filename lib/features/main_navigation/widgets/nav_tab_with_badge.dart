import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:surfify/features/authentication/repos/authentication_repo.dart';

import '../../../constants/gaps.dart';

class NavTabWithBadge extends ConsumerStatefulWidget {
  const NavTabWithBadge({
    super.key,
    required this.text,
    required this.isSelected,
    required this.icon,
    required this.onTap,
    required this.selectedIcon,
  });

  final String text;
  final bool isSelected;
  final IconData icon;
  final IconData selectedIcon;
  final Function onTap;

  @override
  ConsumerState<NavTabWithBadge> createState() => _NavTabWithBadgeState();
}

class _NavTabWithBadgeState extends ConsumerState<NavTabWithBadge> {
  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> messageStream = FirebaseFirestore.instance
        .collection('users')
        .doc(ref.read(authRepo).user!.uid)
        .collection('message')
        .snapshots();
    print(messageStream.length);
    print('여기');
    return StreamBuilder(
        stream: messageStream,
        builder: (context, snapshot) {
          if (snapshot.hasError ||
              snapshot.connectionState == ConnectionState.waiting) {
            return Expanded(
              child: GestureDetector(
                onTap: () => widget.onTap(),
                child: Container(
                  color: Colors.white,
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 300),
                    opacity: widget.isSelected ? 1 : 0.6,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        FaIcon(
                          widget.isSelected ? widget.selectedIcon : widget.icon,
                          color: widget.isSelected
                              ? Theme.of(context).primaryColor
                              : Colors.black,
                        ),
                        Gaps.v5,
                        Text(
                          widget.text,
                          style: TextStyle(
                            color: widget.isSelected
                                ? Theme.of(context).primaryColor
                                : Colors.black,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            );
          }
          print(snapshot.data!.docs.length);
          return Expanded(
            child: GestureDetector(
              onTap: () => widget.onTap(),
              child: Container(
                color: Colors.white,
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 300),
                  opacity: widget.isSelected ? 1 : 0.6,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Stack(
                        children: [
                          FaIcon(
                            widget.isSelected
                                ? widget.selectedIcon
                                : widget.icon,
                            color: widget.isSelected
                                ? Theme.of(context).primaryColor
                                : Colors.black,
                          ),
                          if (snapshot.data!.docs.isNotEmpty)
                            Container(
                              width: 15,
                              decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(10)),
                              alignment: Alignment.center,
                              child: Text(
                                '${snapshot.data!.docs.length}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                ),
                              ),
                            ),
                        ],
                      ),
                      Gaps.v5,
                      Text(
                        widget.text,
                        style: TextStyle(
                          color: widget.isSelected
                              ? Theme.of(context).primaryColor
                              : Colors.black,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }
}
