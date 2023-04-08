import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:surfify/features/authentication/repos/authentication_repo.dart';
import 'package:surfify/features/users/delete_account_screen.dart';
import 'package:surfify/widgets/box_button.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../constants/gaps.dart';
import '../../constants/sizes.dart';

class SettingScreen extends ConsumerStatefulWidget {
  const SettingScreen({super.key});

  @override
  ConsumerState<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends ConsumerState<SettingScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 200),
  );

  late final Animation<double> _arrowAnimation =
      Tween(begin: 0.0, end: 0.5).animate(_animationController);

  late final Animation<Offset> _panelAnimation1 = Tween(
    begin: const Offset(0, 0),
    end: const Offset(0, 1.0),
  ).animate(_animationController);
  late final Animation<Offset> _panelAnimation2 = Tween(
    begin: const Offset(0, 0),
    end: const Offset(0, 2.0),
  ).animate(_animationController);

  void _onMapSettingTap() {
    if (_animationController.isCompleted) {
      _animationController.reverse();
    } else {
      _animationController.forward();
    }
  }

  @override
  void initState() {
    super.initState();
    // "ref" can be used in all life-cycles of a StatefulWidget.
    ref.read(authRepo);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    void onClosePressed() {
      Navigator.of(context).pop();
    }

    return Container(
      height: size.height * 0.40,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Sizes.size14),
        color: Colors.white,
      ),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: false,
          centerTitle: false,
          elevation: 0,
          title: const Text(
            '더 많은 옵션',
            style: TextStyle(
              fontSize: Sizes.size18,
              color: Colors.black,
            ),
          ),
          actions: [
            IconButton(
              onPressed: onClosePressed,
              icon: const FaIcon(
                FontAwesomeIcons.xmark,
                size: Sizes.size24,
                color: Colors.black,
              ),
            )
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Stack(
            children: [
              Column(
                children: [
                  Gaps.v56,
                  GestureDetector(
                    onTap: () {
                      ref.read(authRepo).signOut();
                      context.go("/");
                    },
                    child: BoxButton(
                      text: "Sign Out",
                      able: false,
                      mainColor: Theme.of(context).primaryColor,
                    ),
                  ),
                  Gaps.v6,
                  GestureDetector(
                    onTap: () async {
                      await launchUrlString(
                          "https://notice.danbee.ai/terms/use_policy.html");
                    },
                    child: BoxButton(
                      text: "Term & Policy",
                      able: false,
                      mainColor: Theme.of(context).primaryColor,
                    ),
                  ),
                  Gaps.v6,
                  GestureDetector(
                    onTap: () async {
                      await showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (context) => const DeleteAccountScreen());
                    },
                    child: const BoxButton(
                      text: "Quit Service",
                      able: false,
                      mainColor: Colors.red,
                    ),
                  ),
                ],
              ),
              SlideTransition(
                position: _panelAnimation2,
                child: BoxButton(
                    text: "지도 연결 - 카카오맵",
                    able: false,
                    mainColor: Theme.of(context).primaryColor),
              ),
              SlideTransition(
                position: _panelAnimation1,
                child: BoxButton(
                    text: "지도 연결 - 네이버 지도",
                    able: false,
                    mainColor: Theme.of(context).primaryColor),
              ),
              FractionallySizedBox(
                widthFactor: 1,
                child: Container(
                  height: 50,
                  padding: const EdgeInsets.all(Sizes.size14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: Theme.of(context).primaryColor,
                      width: Sizes.size1,
                    ),
                  ),
                  child: GestureDetector(
                    onTap: _onMapSettingTap,
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            "지도 연결 - Google Map",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: RotationTransition(
                            turns: _arrowAnimation,
                            child: FaIcon(
                              FontAwesomeIcons.chevronDown,
                              size: Sizes.size24,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
