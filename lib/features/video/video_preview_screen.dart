import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:surfify/constants/gaps.dart';
import 'package:surfify/constants/sizes.dart';
import 'package:surfify/features/main_navigation/main_navigation_screen.dart';

import 'package:video_player/video_player.dart';

class VideoPreviewScreen extends StatefulWidget {
  final XFile video;

  const VideoPreviewScreen({
    super.key,
    required this.video,
  });

  @override
  State<VideoPreviewScreen> createState() => _VideoPreviewScreenState();
}

class _VideoPreviewScreenState extends State<VideoPreviewScreen> {
  late final VideoPlayerController _videoPlayerController;

  bool _savedVideo = false;

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

  Future<void> _saveToGallery() async {
    if (_savedVideo) return;

    await GallerySaver.saveVideo(
      widget.video.path,
      albumName: "TikTok Clone!",
    );

    _savedVideo = true;

    setState(() {});
  }

  void _goMain() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => const MainNavigationScreen(),
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final mediaSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black,
      // appBar: AppBar(
      //   title: const Text('Preview video'),
      //   actions: [
      //     IconButton(
      //       onPressed: _saveToGallery,
      //       icon: FaIcon(
      //         _savedVideo ? FontAwesomeIcons.check : FontAwesomeIcons.download,
      //       ),
      //     )
      //   ],
      // ),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              child: _videoPlayerController.value.isInitialized
                  ? AspectRatio(
                      aspectRatio: _videoPlayerController.value.aspectRatio,
                      child: VideoPlayer(_videoPlayerController),
                    )
                  : null,
            ),
            !_savedVideo
                ? Positioned(
                    bottom: Sizes.size80,
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      children: [
                        SizedBox(
                          width: 330,
                          height: Sizes.size64,
                          child: CupertinoButton(
                            onPressed: _saveToGallery,
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
                    bottom: Sizes.size80,
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
                  )
          ],
        ),
      ),
    );
  }
}
