import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:surfify/constants/gaps.dart';
import 'package:surfify/constants/sizes.dart';
import 'package:surfify/features/main_navigation/main_navigation_screen.dart';
import 'package:surfify/features/video/widgets/video_location.dart';

import 'package:video_player/video_player.dart';

import '../../main_navigation/widgets/nav_tab.dart';
import '../../main_navigation/widgets/post_video_button.dart';

class VideoUploadedScreen extends StatefulWidget {
  final XFile video;
  final String address;
  final String name;
  final String tags;
  const VideoUploadedScreen({
    super.key,
    required this.video,
    required this.address,
    required this.name,
    required this.tags,
  });
  @override
  State<VideoUploadedScreen> createState() => VideoUploadedScreenState();
}

class VideoUploadedScreenState extends State<VideoUploadedScreen> {
  late final VideoPlayerController _videoPlayerController;

  bool _savedVideo = false;
  final int _selectedIndex = -1;

  Future<void> _initVideo() async {
    _videoPlayerController = VideoPlayerController.file(
      File(widget.video.path),
    );

    await _videoPlayerController.initialize();
    await _videoPlayerController.setLooping(true);
    await _videoPlayerController.play();

    setState(() {});
  }

  void _recordAgain() {
    // Navigator.popUntil(context, ModalRoute.withName(VideoCreateScreen.routeName));
    Navigator.pop(context);
    Navigator.pop(context);
    Navigator.pop(context);
    Navigator.pop(context);
  }

  @override
  void initState() {
    super.initState();

    _initVideo();
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    super.dispose();
  }

  Future<void> _saveToGallery() async {
    // if (_savedVideo) return;

    await GallerySaver.saveVideo(
      widget.video.path,
      albumName: "TikTok Clone!",
    );

    _savedVideo = true;

    setState(() {});
  }

  void _goMain() {
    // context.go(MainNavigationScreen.routeName);
    Navigator.popUntil(
        context, ModalRoute.withName(MainNavigationScreen.routeName));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            Positioned.fill(
              child: _videoPlayerController.value.isInitialized
                  ? VideoPlayer(_videoPlayerController)
                  : Container(
                      color: Colors.black,
                    ),
            ),
            !_savedVideo
                ? Positioned(
                    top: Sizes.size60,
                    left: Sizes.size20,
                    child: VideoLocation(
                      address: widget.address,
                      name: widget.name,
                    ))
                : Container(),
            !_savedVideo
                ? Positioned(
                    bottom: 180,
                    left: 10,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: Sizes.size28,
                          child: SizedBox(
                            child: ClipOval(
                              child: Image.asset(
                                'assets/images/user.png',
                              ),
                            ),
                          ),
                        ),
                        Gaps.v12,
                        const Text(
                          "마곡드래곤(@dragmag)",
                          style: TextStyle(
                            fontSize: Sizes.size20,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Gaps.v10,
                        SizedBox(
                          width: 300,
                          child: Text(
                            widget.tags,
                            style: const TextStyle(
                              fontSize: Sizes.size16,
                              color: Colors.white,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        )
                      ],
                    ),
                  )
                : Container(),
            !_savedVideo
                ? Positioned(
                    bottom: Sizes.size20,
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      children: [
                        SizedBox(
                          width: 330,
                          height: Sizes.size64,
                          child: CupertinoButton(
                            onPressed: () => _saveToGallery(),
                            color:
                                Theme.of(context).primaryColor.withOpacity(0.8),
                            child: const Text(
                              "서핑포인트 생성",
                              style: TextStyle(
                                fontSize: Sizes.size20,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        Gaps.v16,
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.white, width: Sizes.size2),
                            borderRadius: BorderRadius.circular(Sizes.size8),
                          ),
                          child: SizedBox(
                            width: 330,
                            height: Sizes.size64,
                            child: CupertinoButton(
                              onPressed: _recordAgain,
                              child: const Text(
                                "다시 촬영하기",
                                style: TextStyle(
                                  fontSize: Sizes.size20,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : Positioned(
                    bottom: Sizes.size20,
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      children: [
                        const Text(
                          "고마워요!",
                          style: TextStyle(
                            fontSize: Sizes.size24,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        Gaps.v4,
                        const Text(
                          "이제 다른 사람도 이곳을",
                          style: TextStyle(
                            fontSize: Sizes.size24,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        Gaps.v4,
                        const Text(
                          "서핑할 수 있어요.",
                          style: TextStyle(
                            fontSize: Sizes.size24,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        Gaps.v28,
                        SizedBox(
                          width: 330,
                          height: Sizes.size64,
                          child: CupertinoButton(
                            onPressed: _goMain,
                            color: Theme.of(context).primaryColor,
                            child: const Text(
                              "별말씀을!",
                              style: TextStyle(
                                fontSize: Sizes.size20,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
          ],
        ),
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
                onTap: () => {},
              ),
              NavTab(
                text: "Now",
                isSelected: _selectedIndex == 0,
                icon: FontAwesomeIcons.earthAsia,
                selectedIcon: FontAwesomeIcons.earthAsia,
                onTap: () => {},
              ),
              Gaps.h24,
              GestureDetector(
                child: const PostVideoButton(),
              ),
              Gaps.h24,
              NavTab(
                text: "Msg.",
                isSelected: _selectedIndex == 0,
                icon: FontAwesomeIcons.message,
                selectedIcon: FontAwesomeIcons.message,
                onTap: () => {},
              ),
              NavTab(
                text: "Profile",
                isSelected: _selectedIndex == 4,
                icon: FontAwesomeIcons.user,
                selectedIcon: FontAwesomeIcons.message,
                onTap: () => {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
