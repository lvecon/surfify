import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:surfify/features/video/view_models/timeline_view_model.dart';

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
    return ref.watch(timelineProvider.notifier).refresh();
  }

  List<List<Map<String, dynamic>>> video_example = [
    [
      {
        'src': "assets/videos/pizza02.mp4",
        'nickname': "마곡드래곤(@dragmag)",
        'content': '피자집',
        'location': "비바 나폴리",
        'longitude': 37.56037058748502,
        'latitude': 126.82747856620537,
        'comments': 0.0,
        'address': '서울특별시 강서구 마곡중앙로 76'
      },
      {
        'src': "assets/videos/pizza01.mp4",
        'location': "비바 나폴리",
        'nickname': "마곡드래곤(@dragmag)",
        'content': '피자집 내부',
        'longitude': 37.56037058748502,
        'latitude': 126.82747856620537,
        'comments': 0.0,
        'address': '서울특별시 강서구 마곡중앙로 76'
      },
      {
        'src': "assets/videos/pizza03.mp4",
        'location': "비바 나폴리",
        'nickname': "마곡드래곤(@dragmag)",
        'content': '메뉴판',
        'longitude': 37.56037058748502,
        'latitude': 126.82747856620537,
        'comments': 0.0,
        'address': '서울특별시 강서구 마곡중앙로 76'
      },
    ],
    [
      {
        'src': "assets/videos/snu_main01.mp4",
        'nickname': "허남현(@namhyeon)",
        'content': '서울대 잔디광장의 야경 #서울대 #야경 #총장잔디',
        'location': "서울대 본관",
        'longitude': 37.45959904963221,
        'latitude': 126.95175650442046,
        'comments': 0.0,
        'address': '서울특별시 관악구 관악로 1'
      },
    ],
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
                      itemCount: video_example[0].length,
                      itemBuilder: (context, index) => const Text("temp"),
                      // VideoPost(
                      //   index: index,
                      //   src: video_example[0][index]['src'],
                      //   nickname: video_example[0][index]['nickname'],
                      //   content: video_example[0][index]['content'],
                      //   latitude: video_example[0][index]['latitude'],
                      //   longitude: video_example[0][index]['longitude'],
                      //   location: video_example[0][index]['location'],
                      //   adress: video_example[0][index]['address'],
                      // ),
                    )),
          ),
        );
  }
}
