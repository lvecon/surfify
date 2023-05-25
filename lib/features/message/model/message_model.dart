class MessageModel {
  final String receiverId;
  final String creatorId;
  final String comment;
  final int createdAt;
  final String videoId;
  final String messageId;

  MessageModel({
    required this.creatorId,
    required this.comment,
    required this.createdAt,
    required this.receiverId,
    required this.videoId,
    required this.messageId,
  });

  MessageModel.fromJson({
    required Map<String, dynamic> json,
  })  : creatorId = json["creatorId"],
        receiverId = json["receiverId"],
        comment = json["comment"],
        createdAt = json["createdAt"],
        messageId = json['messageId'],
        videoId = json["videoId"];

  Map<String, dynamic> toJson() {
    return {
      "creatorId": creatorId,
      "comment": comment,
      "createdAt": createdAt,
      "messageId": messageId,
      "receiverId": receiverId,
      "videoId": videoId,
    };
  }
}
