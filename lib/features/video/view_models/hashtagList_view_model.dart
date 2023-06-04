import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import 'package:http/http.dart' as http;
import '../../../constants/configs.dart';
import '../models/hashtagList_model.dart';

class HashTagListViewModel extends Notifier<HashTagListModel> {
  HashTagListViewModel();

  void setTags(String resStr) {
    state = HashTagListModel(hashtag: resStr);
  }

  void setInitial() {
    state = HashTagListModel(hashtag: "initial");
  }

  Future<void> setVideo(XFile video) async {
    List<int> videoBytes = await video.readAsBytes();
    var mFile = http.MultipartFile.fromBytes(
      'video',
      videoBytes,
      filename: 'video.mp4',
    );
    var request = http.MultipartRequest(
        'POST', Uri.parse('${Configs.INFERENCE_SERVER_IP}/predict_video'));
    request.files.add(mFile);

    String resStr;
    try {
      var res = await request.send();
      if (res.statusCode == 200) {
        resStr = await res.stream.bytesToString();
        setTags(resStr);
      } else {
        resStr = "Empty";
        setTags(resStr);
        print("Failed with $res.statusCode");
      }
    } catch (e) {
      resStr = "Empty";
      setTags(resStr);
      print(e);
    }
  }

  @override
  HashTagListModel build() {
    return HashTagListModel(
      hashtag: "initial",
    );
  }
}

final hashtagListProvider =
    NotifierProvider<HashTagListViewModel, HashTagListModel>(() {
  return HashTagListViewModel();
});
