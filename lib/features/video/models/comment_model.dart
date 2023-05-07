class CommentModel {
  final creatorId;
  final comment;
  final createdAt;
  final likes;
  final videoId;
  final commentId;

  CommentModel({
    required this.creatorId,
    required this.comment,
    required this.createdAt,
    required this.likes,
    required this.videoId,
    required this.commentId,
  });

  CommentModel.fromJson({
    required Map<String, dynamic> json,
    required String videoId,
  })  : creatorId = json["creatorId"],
        comment = json["comment"],
        createdAt = json["createdAt"],
        likes = json["likes"],
        videoId = json["videoId"],
        commentId = json['commentId'];

  Map<String, dynamic> toJson() {
    return {
      "creatorId": creatorId,
      "comment": comment,
      "createdAt": createdAt,
      "likes": likes,
      "videoId": videoId,
      "commentId": commentId,
    };
  }
}
