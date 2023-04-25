import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:surfify/features/video/view_models/timeline_view_model.dart';
import 'package:surfify/features/video/widgets/video_post.dart';

class VideoTimelineScreen extends ConsumerStatefulWidget {
  const VideoTimelineScreen({super.key});

  @override
  createState() => VideoTimelineScreenState();
}

class VideoTimelineScreenState extends ConsumerState<VideoTimelineScreen> {
  int _itemCount = 4;

  final PageController _pageController = PageController();
  final PageController _pageController2 = PageController();

  final Duration _scrollDuration = const Duration(milliseconds: 250);
  final Curve _scrollCurve = Curves.linear;

  void _onPageChanged(int page) {
    _pageController.animateToPage(
      page,
      duration: _scrollDuration,
      curve: _scrollCurve,
    );
    if (page == _itemCount - 1) {
      _itemCount = _itemCount + 4;
      setState(() {});
    }
  }

  void _onPageChanged2(int page) {
    _pageController2.animateToPage(
      page,
      duration: _scrollDuration,
      curve: _scrollCurve,
    );
    if (page == _itemCount - 1) {
      _itemCount = _itemCount + 4;
      setState(() {});
    }
  }

  // void _onVideoFinished() {
  //   return;
  //   _pageController.nextPage(
  //     duration: _scrollDuration,
  //     curve: _scrollCurve,
  //   );
  // }

  @override
  void dispose() {
    _pageController.dispose();
    _pageController2.dispose();
    super.dispose();
  }

  Future<void> _onRefresh() {
    return Future.delayed(
      const Duration(seconds: 5),
    );
  }

  List<String> video_index = [
    "assets/videos/pizza02.mp4",
    "assets/videos/pizza01.mp4",
    "assets/videos/pizza03.mp4"
  ];
  List<String> video_index2 = [
    "assets/videos/pizza02.mp4",
    "assets/videos/pizza01.mp4",
    "assets/videos/pizza03.mp4"
  ];

  List<Map<String, dynamic>> video_example = [
    {
      'src': "assets/videos/pizza02.mp4",
      'nickname': "마곡드래곤(@dragmag)",
      'content': '피자집',
      'location': "비바 나폴리",
      'longitude': 0,
      'latitude': 0,
      'comments': 0,
    },
    {
      'src': "assets/videos/pizza01.mp4",
      'location': "비바 나폴리",
      'nickname': "마곡드래곤(@dragmag)",
      'content': '피자집',
      'longitude': 0,
      'latitude': 0,
      'comments': 0,
    },
    {
      'src': "assets/videos/pizza03.mp4",
      'location': "비바 나폴리",
      'nickname': "마곡드래곤(@dragmag)",
      'content': '피자집',
      'longitude': 0,
      'latitude': 0,
      'comments': 0,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return ref.watch(timelineProvider).when(
        loading: () => const Center(
              child: CircularProgressIndicator(),
            ),
        error: (error, stackTrace) => Center(
              child: Text('Could not load videos: $error'),
            ),
        data: (videos) => RefreshIndicator(
              onRefresh: _onRefresh,
              displacement: 50,
              edgeOffset: 20,
              color: Theme.of(context).primaryColor,
              child: PageView.builder(
                controller: _pageController,
                scrollDirection: Axis.vertical,
                onPageChanged: _onPageChanged,
                itemCount: _itemCount,
                itemBuilder: (context, index) => PageView.builder(
                  controller: _pageController2,
                  scrollDirection: Axis.horizontal,
                  onPageChanged: _onPageChanged2,
                  itemCount: _itemCount,
                  itemBuilder: (context, index) => (index == 0)
                      ? VideoPost(
                          index: index,
                          src: video_index[index],
                          nickname: video_example[index]['nickname'],
                          content: video_example[index]['content'])
                      : VideoPost(
                          index: index,
                          src: video_example[index]['src'],
                          nickname: video_example[index]['nickname'],
                          content: video_example[index]['content']),
                ),
              ),
            ));
  }
}
