class ThumbnailModel {
  final String thumbnailUrl;
  final String videoId;

  ThumbnailModel({
    required this.thumbnailUrl,
    required this.videoId,
  });
  ThumbnailModel.empty()
      : thumbnailUrl = "",
        videoId = "";

  ThumbnailModel.fromJson(Map<String, dynamic> json)
      : thumbnailUrl = json["thumbnailUrl"],
        videoId = json["videoId"];

  Map<String, dynamic> toJson() {
    return {
      "thumbnailUrl": thumbnailUrl,
      "videoId": videoId,
    };
  }
}
