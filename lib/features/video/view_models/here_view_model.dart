import 'dart:async';

import 'package:dart_geohash/dart_geohash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

import '../repo/videos_repo.dart';

class HereViewModel extends FamilyAsyncNotifier<List<dynamic>, String> {
  late final VideosRepository _repository;
  List<dynamic> _list = [];
  var geoHasher = GeoHasher();

  //return sorted GeoHash List
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
        "longitude": doc.data()['longitude'],
      },
    );
    var list = videos.toList();

    var location = geoHasher.decode(hash!);
    print(location);
    list.sort((m1, m2) {
      return (Geolocator.distanceBetween(
            m1['latitude'],
            m1['longitude'],
            location[1],
            location[0],
          ).round() -
          Geolocator.distanceBetween(
            m2['latitude'],
            m2['longitude'],
            location[1],
            location[0],
          ).round());
    });
    // print(list);
    var sol = list.map((element) => element['geoHash']).toList();
    // print(sol);
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
    // print(_list);
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
