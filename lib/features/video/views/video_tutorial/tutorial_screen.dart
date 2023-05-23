import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:surfify/features/video/views/widgets/tutorial_two.dart';

import '../../../../constants/sizes.dart';
import '../widgets/tutorial_one.dart';
import '../widgets/tutorial_three.dart';

enum Direction { right, left }

enum Page { first, second }

class TutorialScreen extends StatefulWidget {
  const TutorialScreen({super.key});

  @override
  State<TutorialScreen> createState() => _TutorialScreenState();
}

class _TutorialScreenState extends State<TutorialScreen> {
  Direction _direction = Direction.right;
  int _showingPage = 0;

  void _onPanUpdate(DragUpdateDetails details) {
    if (details.delta.dx > 0) {
      setState(() {
        _direction = Direction.right;
      });
    } else {
      setState(() {
        _direction = Direction.left;
      });
    }
  }

  void _onPanEnd(DragEndDetails detail) {
    if (_direction == Direction.right) {
      _showingPage -= 1;
    } else if (_direction == Direction.left) {
      _showingPage += 1;
    }
    if (_showingPage < 0) {
      _showingPage = 0;
    } else if (_showingPage >= 3) {
      _showingPage = 2;
    }
    setState(() {});
  }

  void _onEnterAppTap() {
    context.pop();
    // context.go(MainNavigationScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: _onPanUpdate,
      onPanEnd: _onPanEnd,
      child: Scaffold(
        backgroundColor: Colors.blueGrey.withOpacity(0.6),
        body: Center(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: _showingPage == 0
                ? const TutorialOne()
                : _showingPage == 1
                    ? const TutorialTwo()
                    : _showingPage == 2
                        ? const TutorialThree()
                        : Container(),
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          color: Colors.blueGrey.withOpacity(0),
          child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: Sizes.size24,
                horizontal: Sizes.size24,
              ),
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 300),
                opacity: _showingPage == 2 ? 1 : 0,
                child: CupertinoButton(
                  onPressed: _onEnterAppTap,
                  color: Theme.of(context).primaryColor,
                  child: const Text('Enter the app!'),
                ),
              )),
        ),
      ),
    );
  }
}
