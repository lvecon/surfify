class MessageModel {
  final receiverId;
  final creatorId;
  final comment;
  final createdAt;
  final videoId;

  MessageModel({
    required this.creatorId,
    required this.comment,
    required this.createdAt,
    required this.receiverId,
    required this.videoId,
  });

  MessageModel.fromJson({
    required Map<String, dynamic> json,
    required String videoId,
  })  : creatorId = json["creatorId"],
        receiverId = json["receivedId"],
        comment = json["comment"],
        createdAt = json["createdAt"],
        videoId = json["videoId"];

  Map<String, dynamic> toJson() {
    return {
      "creatorId": creatorId,
      "comment": comment,
      "createdAt": createdAt,
      "receiverId": receiverId,
      "videoId": videoId,
    };
  }
}
