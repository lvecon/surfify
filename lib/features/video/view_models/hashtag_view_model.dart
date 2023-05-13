import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:surfify/features/video/view_models/searchCondition_view_model.dart';

import '../models/video_model.dart';
import '../repo/videos_repo.dart';

class HashTagViewModel
    extends FamilyAsyncNotifier<List<VideoModel>, List<String>> {
  late VideosRepository _repository;
  List<VideoModel> _list = [];

  Future<List<VideoModel>> _fetchVideos({
    int? lastItemCreatedAt,
    List<String>? searchConditions,
  }) async {
    late QuerySnapshot<Map<String, dynamic>>? result;
    // 유저만 검색
    if (searchConditions![0].startsWith('@') && searchConditions.length == 1) {
      result = await _repository.fetchVideoswithUser(
        lastItemCreatedAt: lastItemCreatedAt,
        searchConditions: substringFromIndex(searchConditions),
      );
    } // 유저랑 해시태그
    else if (searchConditions[0].startsWith('@')) {
      result = await _repository.fetchVideoswithBoth(
        lastItemCreatedAt: lastItemCreatedAt,
        searchConditions: substringFromIndex(searchConditions),
      );
    } else {
      // 해시태그만 검색
      result = await _repository.fetchVideosWithHashTags(
        lastItemCreatedAt: lastItemCreatedAt,
        searchConditions: substringFromIndex(searchConditions),
      );
    }
    if (result == null) return [];
    final videos = result.docs.map(
      (doc) => VideoModel.fromJson(
        json: doc.data(),
        videoId: doc.id,
      ),
    );

    return videos.toList();
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
  FutureOr<List<VideoModel>> build(List<String> arg) async {
    _repository = ref.read(videosRepo);
    _list = await _fetchVideos(lastItemCreatedAt: null, searchConditions: arg);
    return _list;
  }

  Future<void> fetchNextPage() async {
    final nextPage =
        await _fetchVideos(lastItemCreatedAt: _list.last.createdAt);
    state = AsyncValue.data([..._list, ...nextPage]);
    _list = [..._list, ...nextPage];
  }

  Future<void> refresh() async {
    final videos = await _fetchVideos(
        lastItemCreatedAt: null,
        searchConditions: ref.watch(searchConditionProvider).searchCondition);
    _list = videos;
    state = AsyncValue.data(videos);
  }
}

final hashTagProvider = AsyncNotifierProvider.family<HashTagViewModel,
    List<VideoModel>, List<String>>(
  () => HashTagViewModel(),
);
