import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:surfify/constants/gaps.dart';
import 'package:surfify/constants/sizes.dart';
import 'package:surfify/features/video/search_screen.dart';
import 'package:surfify/features/video/widgets/search_bar.dart';
import 'package:surfify/features/video/widgets/video_button.dart';
import 'package:surfify/features/video/widgets/video_comments.dart';
import 'package:surfify/features/video/widgets/video_compass.dart';
import 'package:surfify/features/video/widgets/video_location.dart';
import 'package:surfify/features/video/widgets/video_radar.dart';

import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../opinion_screen.dart';

class VideoPost extends StatefulWidget {
  final Function onVideoFinished;

  final int index;

  const VideoPost({
    super.key,
    required this.onVideoFinished,
    required this.index,
  });

  @override
  State<VideoPost> createState() => _VideoPostState();
}

class _VideoPostState extends State<VideoPost>
    with SingleTickerProviderStateMixin {
  late final VideoPlayerController _videoPlayerController;

  final Duration _animationDuration = const Duration(milliseconds: 200);

  late final AnimationController _animationController;

  bool _isPaused = false;

  var radarMode = true;

  void _onVideoChange() {
    if (_videoPlayerController.value.isInitialized) {
      if (_videoPlayerController.value.duration ==
          _videoPlayerController.value.position) {
        widget.onVideoFinished();
      }
    }
  }

  void _initVideoPlayer() async {
    _videoPlayerController =
        VideoPlayerController.asset("assets/videos/video.mp4");
    await _videoPlayerController.initialize();
    await _videoPlayerController.setLooping(true);
    _videoPlayerController.addListener(_onVideoChange);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _initVideoPlayer();

    _animationController = AnimationController(
      vsync: this,
      lowerBound: 1.0,
      upperBound: 1.5,
      value: 1.5,
      duration: _animationDuration,
    );
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    super.dispose();
  }

  void _onVisibilityChanged(VisibilityInfo info) {
    if (!mounted) return;
    if (info.visibleFraction == 1 &&
        !_isPaused &&
        !_videoPlayerController.value.isPlaying) {
      _videoPlayerController.play();
    }
  }

  void _onTogglePause() {
    if (!mounted) return;
    if (_videoPlayerController.value.isPlaying) {
      _videoPlayerController.pause();
      _animationController.reverse();
    } else {
      _videoPlayerController.play();
      _animationController.forward();
    }
    setState(() {
      _isPaused = !_isPaused;
    });
  }

  void _onCommentsTap(BuildContext context) async {
    if (_videoPlayerController.value.isPlaying) {
      _onTogglePause();
    }
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const VideoComments(),
    );
    _onTogglePause();
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: Key("${widget.index}"),
      onVisibilityChanged: _onVisibilityChanged,
      child: Stack(
        children: [
          Positioned.fill(
            child: _videoPlayerController.value.isInitialized
                ? VideoPlayer(_videoPlayerController)
                : Container(
                    color: Colors.black,
                  ),
          ),
          Positioned.fill(
            child: GestureDetector(
              onTap: _onTogglePause,
            ),
          ),
          Positioned.fill(
            child: IgnorePointer(
              child: Center(
                child: AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _animationController.value,
                      child: child,
                    );
                  },
                  child: AnimatedOpacity(
                    opacity: _isPaused ? 1 : 0,
                    duration: _animationDuration,
                    child: const FaIcon(
                      FontAwesomeIcons.play,
                      color: Colors.white,
                      size: Sizes.size52,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 20,
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
                const Text(
                  "LG사이언스파크에서 #창문 #화분 #빌딩",
                  style: TextStyle(
                    fontSize: Sizes.size16,
                    color: Colors.white,
                  ),
                )
              ],
            ),
          ),
          Positioned(
            bottom: 185,
            right: 14.5,
            child: Container(
              width: 48,
              height: 260,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.vertical(
                    top: Radius.circular(50), bottom: Radius.circular(50)),
                color: Color.fromRGBO(0, 0, 0, 0.22),
              ),
            ),
          ),
          Positioned(
            bottom: 180,
            right: 20,
            child: Column(
              children: [
                const VideoButton(
                  icon: FontAwesomeIcons.solidHeart,
                  text: "192K",
                ),
                Gaps.v20,
                GestureDetector(
                  onTap: () => _onCommentsTap(context),
                  child: const VideoButton(
                    icon: FontAwesomeIcons.solidCommentDots,
                    text: "544",
                  ),
                ),
                Gaps.v20,
                const VideoButton(
                  icon: FontAwesomeIcons.shareNodes,
                  text: "1.2K",
                ),
                Gaps.v20,
                GestureDetector(
                  onTap: () async {
                    await showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (context) => const OptionScreen());
                  },
                  child: const VideoButton(
                    icon: FontAwesomeIcons.ellipsisVertical,
                    text: "",
                  ),
                )
              ],
            ),
          ),
          Positioned(
            bottom: 30,
            right: 20,
            child: Column(
              children: const [
                VideoButton(
                  icon: FontAwesomeIcons.pen,
                  text: "Edit",
                ),
              ],
            ),
          ),
          Positioned(
            top: 50,
            right: 20,
            child: radarMode
                ? GestureDetector(
                    onTap: () {
                      setState(() {
                        radarMode = !radarMode;
                      });
                    },
                    child: const VideoRadar())
                : GestureDetector(
                    onTap: () {
                      setState(() {
                        radarMode = !radarMode;
                      });
                    },
                    child: const VideoCompass()),
          ),
          Positioned(
            top: 50,
            left: 20,
            child: GestureDetector(
                onTap: () async {
                  await showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (context) => const SearchScreen());
                },
                child: const SearchBar()),
          ),
          const Positioned(
            top: 90,
            left: 20,
            child: VideoLocation(),
          )
        ],
      ),
    );
  }
}
