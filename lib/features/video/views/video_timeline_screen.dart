import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:surfify/features/video/view_models/here_view_model.dart';
import 'package:surfify/features/video/view_models/timeline_view_model.dart';
import 'package:surfify/features/video/views/widgets/video_post.dart';

import '../view_models/place_view_model.dart';

class VideoTimelineScreen extends ConsumerStatefulWidget {
  const VideoTimelineScreen({super.key});

  @override
  createState() => VideoTimelineScreenState();
}

class VideoTimelineScreenState extends ConsumerState<VideoTimelineScreen> {
  int _itemCount = 0;

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
      //수정해야함
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
      // 넣어야 함
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

  @override
  Widget build(BuildContext context) {
    return ref.watch(hereProvider).when(
          loading: () => const Center(
            child: CircularProgressIndicator(),
          ),
          error: (error, stackTrace) => Center(
            child: Text(
              'Could not load videos: $error',
              style: const TextStyle(color: Colors.white),
            ),
          ),
          data: (locations) => RefreshIndicator(
            onRefresh: _onRefresh,
            displacement: 50,
            edgeOffset: 20,
            color: Theme.of(context).primaryColor,
            child: PageView.builder(
              controller: _pageController,
              scrollDirection: Axis.vertical,
              onPageChanged: _onPageChanged,
              itemCount: locations.length,
              itemBuilder: (context, index) =>
                  ref.watch(placeProvider(locations[index])).when(
                        loading: () => const Center(
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        ),
                        error: (error, stackTrace) => Center(
                          child: Text(
                            'Could not load videos: $error',
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        data: (videos) {
                          _itemCount = 5;
                          return RefreshIndicator(
                            onRefresh: _onRefresh,
                            displacement: 50,
                            edgeOffset: 20,
                            color: Theme.of(context).primaryColor,
                            child: PageView.builder(
                              controller: _pageController2,
                              scrollDirection: Axis.horizontal,
                              onPageChanged: _onPageChanged2,
                              itemCount: videos.length,
                              itemBuilder: (context, index) {
                                final videoData = videos[index];
                                return VideoPost(
                                  onVideoFinished: () {},
                                  index: index,
                                  videoData: videoData,
                                );
                              },
                            ),
                          );
                        },
                      ),
            ),
          ),
        );
  }
}
