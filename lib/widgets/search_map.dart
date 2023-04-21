import 'dart:convert';
import 'package:http/http.dart' as http;

const String kakaoApiKey =
    'd43af3068ed5e0ac396d89f7ba84b965'; // 본인의 API KEY로 변경하세요.
const String kakaoUrl = 'https://dapi.kakao.com/v2/local/search/keyword.json';

Future<Map<String, dynamic>> searchPlaces(
    String query, double x, double y) async {
  final response = await http.get(
      Uri.parse('$kakaoUrl?query=$query&x=$x&y=$y&sort=distance'),
      headers: {'Authorization': 'KakaoAK $kakaoApiKey'});
  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Failed to search places');
  }
}

String createGoogleMap(double lat, double lon, int mag) {
  return "https://google.co.kr/maps/@$lat,$lon,${mag}z";
}

String createKakaoMap(String name, double lat, double lon) {
  return "https://map.kakao.com/link/map/$name,$lat,$lon";
}
