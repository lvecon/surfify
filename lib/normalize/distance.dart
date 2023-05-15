import 'package:geolocator/geolocator.dart';

String normalizeDistance(int distance) {
  if (distance < 10) {
    return 'Here';
  } else if (distance < 1000) {
    return '${distance}m';
  } else if (distance < 10000) {
    distance = (distance / 100).round();
    var first = distance ~/ 10;
    var second = distance % 10;
    return '$first.${second}km';
  } else {
    distance = (distance / 1000).round();
    return '${distance}km';
  }
}

String distance(double long1, double lat1, double long2, double lat2) {
  double distance = Geolocator.distanceBetween(
    lat1,
    long1,
    lat2,
    long2,
  );
  int result = distance.round();
  return normalizeDistance(result);
}
