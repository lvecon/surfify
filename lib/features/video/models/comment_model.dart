class CommentModel {
  final creatorId;
  final comment;
  final createdAt;
  final likes;
  final videoId;

  CommentModel({
    required this.creatorId,
    required this.comment,
    required this.createdAt,
    required this.likes,
    required this.videoId,
  });

  CommentModel.fromJson({
    required Map<String, dynamic> json,
    required String videoId,
  })  : creatorId = json["creatorId"],
        comment = json["comment"],
        createdAt = json["createdAt"],
        likes = json["likes"],
        videoId = json["videoId"];

  Map<String, dynamic> toJson() {
    return {
      "creatorId": creatorId,
      "comment": comment,
      "createdAt": createdAt,
      "likes": likes,
      "videoId": videoId,
    };
  }
}
