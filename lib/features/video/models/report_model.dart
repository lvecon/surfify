class ReportModel {
  final String creatorId;
  final String contents;
  final int createdAt;
  final String videoId;
  final int type;

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
