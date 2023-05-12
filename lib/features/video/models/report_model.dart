class ReportModel {
  final creatorId;
  final contents;
  final createdAt;
  final videoId;
  final type;

  ReportModel({
    required this.creatorId,
    required this.contents,
    required this.createdAt,
    required this.videoId,
    required this.type,
  });

  Map<String, dynamic> toJson() {
    return {
      "creatorId": creatorId,
      "contents": contents,
      "createdAt": createdAt,
      "videoId": videoId,
      "type": type,
    };
  }
}
