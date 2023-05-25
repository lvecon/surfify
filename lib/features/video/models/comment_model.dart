class CommentModel {
  final String creatorId;
  final String comment;
  final int createdAt;
  final int likes;
  final String videoId;
  final String commentId;

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
