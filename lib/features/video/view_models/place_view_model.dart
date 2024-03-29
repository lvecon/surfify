import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/video_model.dart';
import '../repo/videos_repo.dart';

class PlaceViewModel extends FamilyAsyncNotifier<List<VideoModel>, String> {
  late final VideosRepository _repository;
  List<VideoModel> _list = [];

  Future<List<VideoModel>> _fetchVideos({
    int? lastItemCreatedAt,
    String? hash,
  }) async {
    final result = await _repository.fetchVideosHome(
      lastItemCreatedAt: lastItemCreatedAt,
      hash: hash,
    );
    final ids = result.docs.map((doc) => doc.data()['id']);
    var result2 = [];
    for (var id in ids) {
      final temp = await _repository.fetchSpecificVideos(
        id: id,
      );
      result2.add(temp);
    }

    final videos = result2.map(
      (doc) => VideoModel.fromJson(
        json: doc.data(),
        videoId: doc.id,
      ),
    );
    //  final videos = result2
    //     .where((doc) => doc.data() != null)
    //     .map((doc) => VideoModel.fromJson(
    //           json: doc.data(),
    //           videoId: doc.id,
    //         ))
    //     .toList();
    return videos.toList();
  }

  @override
  FutureOr<List<VideoModel>> build(String arg) async {
    _repository = ref.read(videosRepo);
    _list = await _fetchVideos(lastItemCreatedAt: null, hash: arg);
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

final placeProvider =
    AsyncNotifierProvider.family<PlaceViewModel, List<VideoModel>, String>(
  () => PlaceViewModel(),
);
