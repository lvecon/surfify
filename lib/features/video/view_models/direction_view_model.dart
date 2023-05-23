import 'dart:async';

import 'package:dart_geohash/dart_geohash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

import '../repo/videos_repo.dart';

class DirectionViewModel extends FamilyAsyncNotifier<List<dynamic>, String> {
  late final VideosRepository _repository;
  List<dynamic> _list = [];
  var geoHasher = GeoHasher();

  //return sorted GeoHash List
  Future<List<dynamic>> _fetchLocations({
    String? hash,
    int? mode,
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
    final location = geoHasher.decode(hash!);

    var list = videos
        .where((doc) => checkBearing(
            location[1], location[0], doc['latitude'], doc['longitude'], mode!))
        .toList();

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
    //print(list);
    var sol = list.map((element) => element['geoHash']).toList();
    //print(sol);
    return sol;
  }

  @override
  FutureOr<List<dynamic>> build(String arg) async {
    var location = arg.split(',');
    var mode = location[2];
    final hash = geoHasher.encode(
      double.parse(location[0]),
      double.parse(location[1]),
      precision: 9,
    );
    _repository = ref.read(videosRepo);
    _list = await _fetchLocations(hash: hash, mode: int.parse(mode));
    // print(_list);
    return _list;
  }

  Future<void> fetchNextPage(String hash) async {
    final neighborNorth = geoHasher.neighbors(hash)['NORTH'];

    final nextPage = await _fetchLocations(hash: neighborNorth);
    state = AsyncValue.data([..._list, ...nextPage]);
    _list = [..._list, ...nextPage];
  }

  Future<void> refresh(int mode, String arg) async {
    var location = arg.split(',');
    final hash = geoHasher.encode(
      double.parse(location[0]),
      double.parse(location[1]),
      precision: 9,
    );
    final videos = await _fetchLocations(hash: hash, mode: mode);
    _list = videos;
    state = AsyncValue.data(videos);
  }
}

final directionProvider =
    AsyncNotifierProvider.family<DirectionViewModel, List<dynamic>, String>(
  () => DirectionViewModel(),
);

bool checkBearing(double lat, double lon, double lat2, double lon2, int mode) {
  double bearing = Geolocator.bearingBetween(
    lat,
    lon,
    lat2,
    lon2,
  );
  // print(bearing);
  if (mode == 1 && bearing >= -45 && bearing <= 45) {
    //north
    return true;
  }
  if (mode == 2 && bearing >= 45 && bearing <= 135) {
    //east
    return true;
  }
  if (mode == 3 && (bearing >= 135 || bearing <= -135)) {
    //south
    return true;
  }
  if (mode == 4 && bearing >= -135 && bearing <= -45) {
    //west
    return true;
  } else {
    return false;
  }
}
