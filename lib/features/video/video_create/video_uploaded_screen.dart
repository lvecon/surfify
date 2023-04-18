import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:surfify/constants/gaps.dart';
import 'package:surfify/constants/sizes.dart';
import 'package:surfify/features/main_navigation/main_navigation_screen.dart';
import 'package:surfify/features/video/video_edit/edit_location.dart';
import 'package:surfify/features/video/video_edit/edit_tag.dart';
import 'package:surfify/features/video/video_edit/edit_video.dart';
import 'package:surfify/features/video/widgets/video_location.dart';

import 'package:video_player/video_player.dart';

import '../widgets/video_button.dart';

class VideoUploadedScreen extends StatefulWidget {
  late XFile video;
  late String address;
  late String name;
  late String tags;
  late String lat;
  late String lon;
  late String url;

  VideoUploadedScreen({
    super.key,
    required this.video,
    required this.address,
    required this.name,
    required this.tags,
    required this.lat,
    required this.lon,
    required this.url,
  });
  @override
  State<VideoUploadedScreen> createState() => VideoUploadedScreenState();
}

class VideoUploadedScreenState extends State<VideoUploadedScreen> {
  late VideoPlayerController _videoPlayerController;

  bool _savedVideo = false;
  // final int _selectedIndex = -1;
  bool _recordButtTaped = false;

  Future<void> _initVideo() async {
    _videoPlayerController = VideoPlayerController.file(
      File(widget.video.path),
    );

    await _videoPlayerController.initialize();
    await _videoPlayerController.setLooping(true);
    await _videoPlayerController.play();

    setState(() {});
  }

  void _onEditTag(BuildContext context) async {
    final editTag = await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => EditTag(originalTag: widget.tags),
    );

    setState(() {
      widget.tags = editTag;
    });
  }

  void _onEditLocation(BuildContext context) async {
    final editlocation = await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const EditLocation(),
    );

    setState(() {
      widget.name = editlocation['name'];
      widget.lat = editlocation['lat'];
      widget.lon = editlocation['lon'];
      widget.address = editlocation['address'];
      widget.url = editlocation['url'];
    });
  }

  void _onEditVideo(BuildContext context) async {
    final editVideo = await Navigator.of(context).push(
      MaterialPageRoute(
          builder: (context) => EditVideo(
                video: widget.video,
              )),
    );

    setState(() {
      widget.video = editVideo;
      _videoPlayerController.dispose();
      _initVideo();
    });
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
                  ? FittedBox(
                      fit: BoxFit.cover,
                      child: SizedBox(
                        width: _videoPlayerController.value.size.width,
                        height: _videoPlayerController.value.size.height,
                        child: VideoPlayer(_videoPlayerController),
                      ),
                    )
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
                      latitude: widget.lat,
                      longitude: widget.lon,
                      url: widget.url,
                    ))
                : Container(),
            !_savedVideo
                ? Positioned(
                    bottom: 205,
                    left: 15,
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
                    bottom: 210,
                    right: 25,
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () => _onEditTag(context),
                          child: const VideoButton(
                            icon: FontAwesomeIcons.pen,
                            text: "Edit",
                          ),
                        ),
                      ],
                    ),
                  )
                : Container(),
            !_savedVideo
                ? Positioned(
                    top: 64,
                    right: 15,
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () => _onEditLocation(context),
                          child: const VideoButton(
                            icon: FontAwesomeIcons.penToSquare,
                            text: "Edit",
                          ),
                        ),
                      ],
                    ),
                  )
                : Container(),
            !_savedVideo
                ? Positioned(
                    bottom: Sizes.size40,
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
                        GestureDetector(
                          onTapDown: (TapDownDetails details) => setState(() {
                            _recordButtTaped = true;
                          }),
                          onTapCancel: () => setState(() {
                            _recordButtTaped = false;
                          }),
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: !_recordButtTaped
                                      ? Colors.white
                                      : Colors.white.withOpacity(0.5),
                                  width: Sizes.size3),
                              borderRadius: BorderRadius.circular(Sizes.size8),
                            ),
                            child: SizedBox(
                              width: 324,
                              height: Sizes.size64,
                              child: CupertinoButton(
                                onPressed: () => _onEditVideo(context),
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
                        ),
                      ],
                    ),
                  )
                : Positioned(
                    bottom: Sizes.size60,
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
                        Gaps.v20,
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
      // bottomNavigationBar: BottomAppBar(
      //   color: Colors.white,
      //   child: Padding(
      //     padding: const EdgeInsets.all(Sizes.size12),
      //     child: Row(
      //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //       children: [
      //         NavTab(
      //           text: "Here",
      //           isSelected: _selectedIndex == 0,
      //           icon: FontAwesomeIcons.locationDot,
      //           selectedIcon: FontAwesomeIcons.locationDot,
      //           onTap: () => {},
      //         ),
      //         NavTab(
      //           text: "Now",
      //           isSelected: _selectedIndex == 0,
      //           icon: FontAwesomeIcons.earthAsia,
      //           selectedIcon: FontAwesomeIcons.earthAsia,
      //           onTap: () => {},
      //         ),
      //         Gaps.h24,
      //         GestureDetector(
      //           child: const PostVideoButton(),
      //         ),
      //         Gaps.h24,
      //         NavTab(
      //           text: "Msg.",
      //           isSelected: _selectedIndex == 0,
      //           icon: FontAwesomeIcons.message,
      //           selectedIcon: FontAwesomeIcons.message,
      //           onTap: () => {},
      //         ),
      //         NavTab(
      //           text: "Profile",
      //           isSelected: _selectedIndex == 4,
      //           icon: FontAwesomeIcons.user,
      //           selectedIcon: FontAwesomeIcons.message,
      //           onTap: () => {},
      //         ),
      //       ],
      //     ),
      //   ),
      // ),
    );
  }
}
