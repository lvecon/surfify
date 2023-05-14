class ThumbnailModel {
  final String thumbnailUrl;
  final String id;

  ThumbnailModel({
    required this.thumbnailUrl,
    required this.id,
  });
  ThumbnailModel.empty()
      : thumbnailUrl = "",
        id = "";

  ThumbnailModel.fromJson(Map<String, dynamic> json)
      : thumbnailUrl = json["thumbnailUrl"],
        id = json["id"];

  Map<String, dynamic> toJson() {
    return {
      "thumbnailUrl": thumbnailUrl,
      "id": id,
    };
  }
}
