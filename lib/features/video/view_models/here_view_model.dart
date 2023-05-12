import 'dart:async';

import 'package:dart_geohash/dart_geohash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../repo/videos_repo.dart';

class HereViewModel extends FamilyAsyncNotifier<List<dynamic>, String> {
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
      (doc) => {
        "geoHash": doc.data()['geoHash'],
        "latitude": doc.data()['latitude'],
        "longitude": doc.data()['latitude'],
      },
    );
    var list = videos.toList();
    var location = geoHasher.decode(hash!);
    list.sort((m1, m2) {
      return ((m1['longitude'] -
                  2 * location[0] +
                  m1['latitude'] -
                  2 * location[1] -
                  m2['longitude'] -
                  m2['latitude']) *
              16)
          .round(); //현재위치와의 거리 비교. 원래는 위도 경도 제곱으로 계산해야하는데 그냥 맨해튼 거리로 계산.
    });
    print(list);
    var sol = list.map((element) => element['geoHash']).toList();
    return sol;
  }

  @override
  FutureOr<List<dynamic>> build(String arg) async {
    var location = arg.split(',');
    final hash = geoHasher.encode(
      double.parse(location[0]),
      double.parse(location[1]),
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

final hereProvider =
    AsyncNotifierProvider.family<HereViewModel, List<dynamic>, String>(
  () => HereViewModel(),
);
