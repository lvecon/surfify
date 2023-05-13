import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:surfify/features/video/models/video_model.dart';
import 'package:surfify/features/video/view_models/hashtag_view_model.dart';
import 'package:surfify/features/video/view_models/here_view_model.dart';
import 'package:surfify/features/video/view_models/searchCondition_view_model.dart';
import 'package:surfify/features/video/views/search_screen.dart';
import 'package:surfify/features/video/views/widgets/search_bar.dart';
import 'package:surfify/features/video/views/widgets/video_post.dart';

import '../view_models/place_view_model.dart';

class VideoTimelineScreen extends ConsumerStatefulWidget {
  const VideoTimelineScreen({super.key});

  @override
  createState() => VideoTimelineScreenState();
}

class VideoTimelineScreenState extends ConsumerState<VideoTimelineScreen> {
  int _itemCount = 0;
  int overViewMode = 0;

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
  bool checkUserandHashTags(
      List<String> list, String username, List<String> elements) {
    return elements.sublist(1).every((element) => list.contains(element)) &&
        username == elements[0];
  }

  bool checkHashTags(List<String> list, List<String> elements) {
    return elements.every((element) => list.contains(element));
  }

  List<String> substringFromIndex(List<String> inputList) {
    List<String> result = [];
    for (String element in inputList) {
      if (element.length > 1) {
        result.add(element.substring(1));
      }
    }

    return result;
  }

  @override
  void dispose() {
    _pageController.dispose();
    _pageController2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final searchCondition = ref.watch(searchConditionProvider).searchCondition;
    return GestureDetector(
      onScaleStart: (details) {
        setState(() {
          overViewMode += 1;
        });
      },
      child: Stack(children: [
        ref.watch(searchConditionProvider).searchCondition.isEmpty
            ? ref
                .watch(hereProvider('126.95236219241595,37.458938402839834'))
                .when(
                  loading: () => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  error: (error, stackTrace) => Center(
                    child: Text(
                      'Could not load videos: $error',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  data: (overViewMode % 4 == 0)
                      ? (locations) => RefreshIndicator(
                            onRefresh: ref
                                .watch(hereProvider(
                                        '126.95236219241595,37.458938402839834')
                                    .notifier)
                                .refresh,
                            displacement: 50,
                            edgeOffset: 20,
                            color: Theme.of(context).primaryColor,
                            child: PageView.builder(
                              controller: _pageController,
                              scrollDirection: Axis.vertical,
                              onPageChanged: _onPageChanged,
                              itemCount: locations.length,
                              itemBuilder: (context, index) => ref
                                  .watch(placeProvider(locations[index]))
                                  .when(
                                    loading: () => const Center(
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                      ),
                                    ),
                                    error: (error, stackTrace) => Center(
                                      child: Text(
                                        'Could not load videos: $error',
                                        style: const TextStyle(
                                            color: Colors.white),
                                      ),
                                    ),
                                    data: (videos) {
                                      _itemCount = videos.length;
                                      return RefreshIndicator(
                                        onRefresh: ref
                                            .watch(
                                                placeProvider(locations[index])
                                                    .notifier)
                                            .refresh,
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
                          )
                      : (data) {
                          return SingleChildScrollView(
                            child: Column(
                              children: [
                                const Text('안녕하세요'),
                                for (var location in data)
                                  ref.watch(placeProvider(location)).when(
                                        loading: () => const Center(
                                          child: CircularProgressIndicator(
                                            color: Colors.white,
                                          ),
                                        ),
                                        error: (error, stackTrace) => Center(
                                          child: Text(
                                            'Could not load videos: $error',
                                            style: const TextStyle(
                                                color: Colors.white),
                                          ),
                                        ),
                                        data: (pics) {
                                          return SingleChildScrollView(
                                            scrollDirection: Axis.horizontal,
                                            child: Row(
                                              children: [
                                                for (var pic in pics)
                                                  FadeInImage.assetNetwork(
                                                    fit: BoxFit.cover,
                                                    placeholder:
                                                        "assets/images/user.png",
                                                    image: pic.thumbnailUrl,
                                                  ),
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                              ],
                            ),
                          );
                        },
                )
            : ref.watch(hashTagProvider(searchCondition)).when(
                  loading: () => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  error: (error, stackTrace) => Center(
                    child: Text(
                      'Could not load videos: $error',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  data: (videos) {
                    late final List<VideoModel> filteredVideos;
                    if (searchCondition[0].startsWith('@') && // 유저만
                        searchCondition.length == 1) {
                      filteredVideos = videos;
                    } else if (searchCondition[0].startsWith('@')) {
                      //유저랑 해시태그
                      filteredVideos = videos
                          .where((video) => checkUserandHashTags(
                              video.hashtag,
                              video.creator,
                              substringFromIndex(searchCondition)))
                          .toList();
                    } else {
                      // 해시태그만
                      filteredVideos = videos
                          .where((video) => checkHashTags(video.hashtag,
                              substringFromIndex(searchCondition)))
                          .toList();
                    }
                    if (filteredVideos.isEmpty) {
                      return RefreshIndicator(
                          onRefresh: ref
                              .watch(hashTagProvider(searchCondition).notifier)
                              .refresh,
                          displacement: 50,
                          edgeOffset: 20,
                          color: Theme.of(context).primaryColor,
                          child: Stack(
                            children: [
                              Positioned(
                                top: 38,
                                left: 20,
                                child: GestureDetector(
                                  onTap: () async {
                                    await showModalBottomSheet(
                                        context: context,
                                        isScrollControlled: true,
                                        backgroundColor: Colors.transparent,
                                        builder: (context) =>
                                            const SearchScreen());
                                  },
                                  child: SearchBar(
                                      searchcondition: searchCondition),
                                ),
                              ),
                              const Center(
                                child: Text(
                                  '검색 결과가 없어요!',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ));
                    }

                    return RefreshIndicator(
                      onRefresh: ref
                          .watch(hashTagProvider(searchCondition).notifier)
                          .refresh,
                      displacement: 50,
                      edgeOffset: 20,
                      color: Theme.of(context).primaryColor,
                      child: PageView.builder(
                        controller: _pageController,
                        scrollDirection: Axis.vertical,
                        onPageChanged: _onPageChanged,
                        itemCount: filteredVideos.length,
                        itemBuilder: (context, index) {
                          final videoData = filteredVideos[index];
                          return VideoPost(
                            onVideoFinished: () {},
                            index: index,
                            videoData: videoData,
                          );
                        },
                      ),
                    );
                  },
                )
      ]),
    );
  }
}
