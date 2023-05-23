import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:surfify/constants/gaps.dart';
import 'package:surfify/constants/sizes.dart';
import 'package:surfify/features/main_navigation/widgets/nav_tab.dart';
import 'package:surfify/features/main_navigation/widgets/post_video_button.dart';
import 'package:surfify/features/message/view/message_screen.dart';
import 'package:surfify/features/users/user_profile_screen.dart';
import 'package:surfify/features/video/views/video_create/video_create_screen.dart';

import '../authentication/repos/authentication_repo.dart';
import '../video/views/video_timeline_now_screen.dart';
import '../video/views/video_timeline_screen.dart';
import '../video/views/video_tutorial/tutorial_screen.dart';

class MainNavigationScreen extends ConsumerStatefulWidget {
  const MainNavigationScreen({super.key});

  static const routeName = '/main_navigation_screen';

  @override
  createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends ConsumerState<MainNavigationScreen> {
  int _selectedIndex = 0;
  late bool _firstSeen;
  double? latitude;
  double? longitude;

  Future checkFirstSeen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _firstSeen = (prefs.getBool('firstSeen') ?? false);
    await prefs.setBool('firstSeen', true);
    if (_firstSeen) {
      await prefs.setBool('firstSeen', true);
      Navigator.of(context).push(
        PageRouteBuilder(
          opaque: false, // set to false
          pageBuilder: (_, __, ___) => const TutorialScreen(),
        ),
      );
    }
    setState(() {});
  }

  void _onTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> getCurrentLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    // print(permission);
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setState(() {
        latitude = position.latitude;
        longitude = position.longitude;
      });
    } catch (e) {
      print(e);
    }
  }

  void _onPostVideoButtonTap() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const VideoCreateScreen(),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    checkFirstSeen();
    getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        builder: (BuildContext context, AsyncSnapshot snapshot) {
      if (latitude == null) {
        return const CircularProgressIndicator(
          color: Colors.red,
        );
      } else {
        return Scaffold(
          backgroundColor: Colors.black,
          body: Stack(
            children: [
              Offstage(
                offstage: _selectedIndex != 0,
                child: VideoTimelineScreen(
                  latitude: latitude!,
                  longitude: longitude!,
                ), //수정해야함
              ),
              Offstage(
                offstage: _selectedIndex != 1,
                child: VideoTimelineNowScreen(
                  latitude: latitude,
                  longitude: longitude,
                ),
              ),
            ],
          ),
          bottomNavigationBar: BottomAppBar(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(Sizes.size12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  NavTab(
                    text: "Here",
                    isSelected: _selectedIndex == 0,
                    icon: FontAwesomeIcons.locationDot,
                    selectedIcon: FontAwesomeIcons.locationDot,
                    onTap: () => _onTap(0),
                  ),
                  NavTab(
                    text: "Now",
                    isSelected: _selectedIndex == 1,
                    icon: FontAwesomeIcons.earthAsia,
                    selectedIcon: FontAwesomeIcons.earthAsia,
                    onTap: () => _onTap(1),
                  ),
                  Gaps.h24,
                  GestureDetector(
                    onTap: _onPostVideoButtonTap,
                    child: const PostVideoButton(),
                  ),
                  Gaps.h24,
                  NavTab(
                      text: "Msg.",
                      isSelected: _selectedIndex == 3,
                      icon: FontAwesomeIcons.message,
                      selectedIcon: FontAwesomeIcons.solidMessage,
                      onTap: () async {
                        await showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (context) => const MessageScreen());
                      }),
                  NavTab(
                      text: "Profile",
                      isSelected: _selectedIndex == 4,
                      icon: FontAwesomeIcons.user,
                      selectedIcon: FontAwesomeIcons.solidUser,
                      onTap: () async {
                        await showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (context) => UserProfileScreen(
                                uid: ref.read(authRepo).user!.uid));
                      }),
                ],
              ),
            ),
          ),
        );
      }
    });
  }
}
