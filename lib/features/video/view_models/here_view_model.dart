import 'dart:async';

import 'package:dart_geohash/dart_geohash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../repo/videos_repo.dart';

class HereViewModel extends AsyncNotifier<List<dynamic>> {
  late final VideosRepository _repository;
  List<dynamic> _list = [];
  var geoHasher = GeoHasher();

  Future<List<dynamic>> _fetchLocations({
    String? hash,
  }) async {
    final result = await _repository.fetchLocations(
      hash: hash,
    );
    final videos = result.docs.map(
      (doc) => doc.data()['geoHash'],
    );
    return videos.toList();
  }

  @override
  FutureOr<List<dynamic>> build() async {
    final hash = geoHasher.encode(
      126.95236219241595,
      37.458938402839834,
      precision: 9,
    );
    _repository = ref.read(videosRepo);
    _list = await _fetchLocations(hash: hash);
    print(_list);
    return _list;
  }

  Future<void> fetchNextPage() async {
    final hash = geoHasher.encode(
      126.95236219241595,
      37.458938402839834,
      precision: 9,
    );
    final neighborNorth = geoHasher.neighbors(hash)['NORTH'];

    final nextPage = await _fetchLocations(hash: neighborNorth);
    state = AsyncValue.data([..._list, ...nextPage]);
    _list = [..._list, ...nextPage];
  }

  Future<void> refresh() async {
    final hash = geoHasher.encode(
      126.95236219241595,
      37.458938402839834,
      precision: 9,
    );
    final videos = await _fetchLocations(hash: hash);
    _list = videos;
    state = AsyncValue.data(videos);
  }
}

final hereProvider = AsyncNotifierProvider<HereViewModel, List<dynamic>>(
  () => HereViewModel(),
);
