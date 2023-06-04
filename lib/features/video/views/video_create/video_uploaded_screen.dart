import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:surfify/constants/gaps.dart';
import 'package:surfify/constants/sizes.dart';
import 'package:surfify/features/authentication/repos/authentication_repo.dart';
import 'package:surfify/features/main_navigation/main_navigation_screen.dart';
import 'package:surfify/features/users/view_models/user_view_model.dart';
import 'package:surfify/features/video/views/video_edit/edit_location.dart';
import 'package:surfify/features/video/views/video_edit/edit_tag.dart';
import 'package:surfify/features/video/views/video_edit/edit_video.dart';
import 'package:surfify/features/video/views/widgets/video_location.dart';

import 'package:video_player/video_player.dart';

import '../../view_models/upload_video_view_model.dart';
import '../widgets/video_button.dart';

class VideoUploadedScreen extends ConsumerStatefulWidget {
  late XFile video;
  late String address;
  late String name;
  late String tags;
  late String lat;
  late String lon;
  late String url;
  late bool hasViolence;

  VideoUploadedScreen({
    super.key,
    required this.video,
    required this.address,
    required this.name,
    required this.tags,
    required this.lat,
    required this.lon,
    required this.url,
    required this.hasViolence,
  });
  @override
  createState() => VideoUploadedScreenState();
}

class VideoUploadedScreenState extends ConsumerState<VideoUploadedScreen> {
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

  List<String> extractHashtags(String text) {
    final List<String> hashtags = [];
    final List<String> words = text.split(" ");

    for (String word in words) {
      if (word.startsWith("#")) {
        final String hashtag = word.substring(1);
        hashtags.add(hashtag);
      }
    }

    return hashtags;
  }

  void _onEditTag(BuildContext context) async {
    final editTag = await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => EditTag(originalTag: widget.tags),
    );

    print(extractHashtags(editTag));

    setState(() {
      widget.tags = editTag ?? widget.tags;
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
      if (editlocation != null) {
        widget.name = editlocation['name'];
        widget.lat = editlocation['lat'];
        widget.lon = editlocation['lon'];
        widget.address = editlocation['address'];
        widget.url = editlocation['url'];
      }
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
      widget.video = editVideo ?? widget.video;
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
    ref.read(uploadVideoProvider.notifier).uploadVideo(
          File(widget.video.path),
          widget.name,
          widget.address,
          double.parse(widget.lon),
          double.parse(widget.lat),
          widget.tags,
          extractHashtags(widget.tags),
          widget.url,
          context,
        );

    _savedVideo = true;

    setState(() {});
  }

  void _goMain() {
    Navigator.popUntil(
        context, ModalRoute.withName(MainNavigationScreen.routeName));
  }

  @override
  Widget build(BuildContext context) {
  WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.hasViolence) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Violence detected'),
              content: Text('Violence has been detected. When uploaded, this video will be reviewed by our team.'),
              actions: <Widget>[
                TextButton(
                  child: Text('Close'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    });

    return Scaffold(
      resizeToAvoidBottomInset: false,
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
                      latitude: double.parse(widget.lat),
                      longitude: double.parse(widget.lon),
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
                        ref
                            .read(usersProvider(ref.read(authRepo).user!.uid))
                            .when(
                              error: (error, stackTrace) => Center(
                                child: Text(error.toString()),
                              ),
                              loading: () => const Center(
                                child: CircularProgressIndicator.adaptive(),
                              ),
                              data: (data) => CircleAvatar(
                                radius: 28,
                                foregroundImage: data.hasAvatar
                                    ? NetworkImage(
                                        "https://firebasestorage.googleapis.com/v0/b/surfify.appspot.com/o/avatars%2F${data.uid}?alt=media")
                                    : null,
                                child: data.hasAvatar ? null : Text(data.name),
                              ),
                            ),
                        Gaps.v12,
                        ref
                            .read(usersProvider(ref.read(authRepo).user!.uid))
                            .when(
                              error: (error, stackTrace) => Center(
                                child: Text(error.toString()),
                              ),
                              loading: () => const Center(
                                child: CircularProgressIndicator.adaptive(),
                              ),
                              data: (data) => Text(
                                data.name,
                                style: const TextStyle(
                                  fontSize: Sizes.size20,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
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
                            color: Colors.white,
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
                            color: Colors.white,
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
                            onPressed: () =>
                                ref.watch(uploadVideoProvider).isLoading
                                    ? () {}
                                    : _saveToGallery(),
                            color:
                                Theme.of(context).primaryColor.withOpacity(0.8),
                            child: ref.watch(uploadVideoProvider).isLoading
                                ? const Text(
                                    "로딩 중 잠시만 기다려주세요",
                                    style: TextStyle(
                                      fontSize: Sizes.size20,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  )
                                : const Text(
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
