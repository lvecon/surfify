import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shake/shake.dart';
import 'package:surfify/constants/gaps.dart';
import 'package:surfify/constants/sizes.dart';
import 'package:surfify/features/video/views/widgets/search_bar.dart';
import 'package:surfify/features/video/views/widgets/video_button.dart';
import 'package:surfify/features/video/views/widgets/video_comments.dart';
import 'package:surfify/features/video/views/widgets/video_compass.dart';
import 'package:surfify/features/video/views/widgets/video_location.dart';
import 'package:surfify/features/video/views/widgets/video_radar.dart';

import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../../users/user_profile_screen.dart';
import '../../models/video_model.dart';
import '../../view_models/video_post_view_model.dart';
import '../opinion_screen.dart';
import '../search_screen.dart';
import 'like.dart';

class VideoPost extends ConsumerStatefulWidget {
  final Function onVideoFinished;
  final VideoModel videoData;
  final int index;

  const VideoPost({
    super.key,
    required this.videoData,
    required this.onVideoFinished,
    required this.index,
  });

  @override
  VideoPostState createState() => VideoPostState();
}

class VideoPostState extends ConsumerState<VideoPost>
    with SingleTickerProviderStateMixin {
  late final VideoPlayerController _videoPlayerController;

  final Duration _animationDuration = const Duration(milliseconds: 200);

  late final AnimationController _animationController;

  bool _isPaused = false;

  var radarMode = true;

  bool randomMode = false;
  var like = 0;

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
    ShakeDetector detector = ShakeDetector.autoStart(
      onPhoneShake: () {
        setState(() {
          randomMode = true;
        });
        // Do stuff on phone shake
      },
      minimumShakeCount: 2,
      shakeSlopTimeMS: 500,
      shakeCountResetTime: 3000,
      shakeThresholdGravity: 2.7,
    );

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
    if (_videoPlayerController.value.isPlaying && info.visibleFraction == 0) {
      _onTogglePause();
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

  void _onLikeTap() {
    ref
        .watch(videoPostProvider(widget.videoData.id).notifier)
        .toggleLikeVideo();
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
    final size = MediaQuery.of(context).size;
    final videoId = widget.videoData.id;

    return VisibilityDetector(
      key: Key("${widget.index}"),
      onVisibilityChanged: _onVisibilityChanged,
      child: Stack(
        children: [
          Positioned.fill(
            child: !_videoPlayerController.value.isInitialized
                ? VideoPlayer(_videoPlayerController)
                : Image.network(
                    widget.videoData.thumbnailUrl,
                    fit: BoxFit.cover,
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
                GestureDetector(
                  onTap: () async {
                    await showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (context) => UserProfileScreen(
                            uid: widget.videoData.creatorUid));
                  },
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: Sizes.size28,
                        child: SizedBox(
                          child: ClipOval(
                            child: Image.network(
                              'https://firebasestorage.googleapis.com/v0/b/surfify.appspot.com/o/avatars%2F${widget.videoData.creatorUid}?alt=media',
                            ),
                          ),
                        ),
                      ),
                      Gaps.v12,
                      Text(
                        widget.videoData.creator,
                        style: const TextStyle(
                          fontSize: Sizes.size20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Gaps.v10,
                Text(
                  widget.videoData.description,
                  style: const TextStyle(
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
                ref.read(videoPostProvider(videoId)).when(
                      loading: () => GestureDetector(
                        onTap: null,
                        child: VideoButton(
                          icon: Icons.favorite,
                          text: "${widget.videoData.likes}",
                          color: Colors.white,
                        ),
                      ),
                      error: (error, stackTrace) => const SizedBox(),
                      data: (data) {
                        return Like(
                          number: widget.videoData.likes,
                          originallyLiked: data,
                          videoId: widget.videoData.id,
                        );
                      },
                    ),
                Gaps.v20,
                GestureDetector(
                  onTap: () => _onCommentsTap(context),
                  child: VideoButton(
                    icon: FontAwesomeIcons.solidCommentDots,
                    text: '${widget.videoData.comments}',
                    color: Colors.white,
                  ),
                ),
                Gaps.v20,
                const VideoButton(
                  icon: FontAwesomeIcons.shareNodes,
                  text: "",
                  color: Colors.white,
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
                    color: Colors.white,
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
                  color: Colors.white,
                ),
              ],
            ),
          ),
          randomMode
              ? Positioned(
                  child: Column(
                    children: [
                      Container(
                        width: size.width,
                        height: 160,
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.5),
                        ),
                      ),
                      Container(
                        width: size.width,
                        height: 80,
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.7),
                        ),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Text(
                                'Lucky Mode',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: Sizes.size18,
                                ),
                              ),
                              Gaps.v8,
                              Text('500m이내 무작위(50m 이동 시 새로 고침)',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: Sizes.size18,
                                  )),
                            ]),
                      ),
                    ],
                  ),
                )
              : Container(),
          Positioned(
            top: 50,
            right: 20,
            child: radarMode
                ? GestureDetector(
                    onTap: () {
                      setState(() {
                        radarMode = !radarMode;
                        randomMode = false;
                      });
                    },
                    child: VideoRadar(
                      latitude: widget.videoData.latitude,
                      longitude: widget.videoData.longitude,
                    ),
                  )
                : GestureDetector(
                    onTap: () {
                      setState(() {
                        radarMode = !radarMode;
                        randomMode = false;
                      });
                    },
                    child: VideoCompass(
                      latitude: widget.videoData.latitude,
                      longitude: widget.videoData.longitude,
                    )),
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
          Positioned(
            top: 90,
            left: 20,
            child: VideoLocation(
              name: widget.videoData.location,
              address: widget.videoData.address,
              latitude: widget.videoData.latitude,
              longitude: widget.videoData.longitude,
              url: widget.videoData.kakaomapId,
            ),
          ),
        ],
      ),
    );
  }
}
