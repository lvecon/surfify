import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:surfify/constants/gaps.dart';
import 'package:surfify/constants/sizes.dart';
import 'package:surfify/features/main_navigation/main_navigation_screen.dart';
import 'package:surfify/features/video/views/video_tutorial/video_location_tutorial.dart';

import 'package:video_player/video_player.dart';

class VideoPreviewTutorial extends StatefulWidget {
  static const routeName = '/video_preview_tutorial';
  final XFile video;

  const VideoPreviewTutorial({
    super.key,
    required this.video,
  });

  @override
  State<VideoPreviewTutorial> createState() => VideoPreviewTutorialState();
}

class VideoPreviewTutorialState extends State<VideoPreviewTutorial> {
  late final VideoPlayerController _videoPlayerController;

  final bool _savedVideo = false;
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

  void _recordAgain() {
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

  void _onCreateLocation(BuildContext context) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => VideoLocationTutorial(
        video: widget.video,
      ),
    );
  }

  void _goMain() {
    context.go(MainNavigationScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black,
      body: SizedBox(
        width: size.width,
        height: size.height,
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
            Positioned(
              bottom: Sizes.size80,
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  SizedBox(
                    width: 330,
                    height: Sizes.size64,
                    child: CupertinoButton(
                      onPressed: () => _onCreateLocation(context),
                      color: Theme.of(context).primaryColor,
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
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
