import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/video_model.dart';
import '../repo/videos_repo.dart';

class HashTagViewModel
    extends FamilyAsyncNotifier<List<VideoModel>, List<String>> {
  late final VideosRepository _repository;
  List<VideoModel> _list = [];

  Future<List<VideoModel>> _fetchVideos({
    int? lastItemCreatedAt,
    List<String>? hashtags,
  }) async {
    final result = await _repository.fetchVideosHashTags(
      lastItemCreatedAt: lastItemCreatedAt,
      hashtags: hashtags,
    );
    final videos = result.docs.map(
      (doc) => VideoModel.fromJson(
        json: doc.data(),
        videoId: doc.id,
      ),
    );
    print(videos.toList());
    return videos.toList();
  }

  @override
  FutureOr<List<VideoModel>> build(List<String> arg) async {
    _repository = ref.read(videosRepo);
    _list = await _fetchVideos(lastItemCreatedAt: null, hashtags: arg);
    return _list;
  }

  Future<void> fetchNextPage() async {
    final nextPage =
        await _fetchVideos(lastItemCreatedAt: _list.last.createdAt);
    state = AsyncValue.data([..._list, ...nextPage]);
    _list = [..._list, ...nextPage];
  }

  Future<void> refresh() async {
    final videos = await _fetchVideos(lastItemCreatedAt: null);
    _list = videos;
    state = AsyncValue.data(videos);
  }
}

final hashTagProvider = AsyncNotifierProvider.family<HashTagViewModel,
    List<VideoModel>, List<String>>(
  () => HashTagViewModel(),
);
