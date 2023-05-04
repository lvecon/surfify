class VideoModel {
  final String title;
  final String description;
  final String fileUrl;
  final String thumbnailUrl;
  final String creatorUid;
  final String creator;
  final String id;
  final int likes;
  final int comments;
  final int createdAt;
  final String location;
  final String address;
  final double longitude;
  final double latitude;
  final String kakaomapId;
  final List<String> hashtag;
  final String geoHash;

  VideoModel({
    required this.id,
    required this.title,
    required this.description,
    required this.fileUrl,
    required this.thumbnailUrl,
    required this.creatorUid,
    required this.likes,
    required this.comments,
    required this.creator,
    required this.createdAt,
    required this.location,
    required this.address,
    required this.longitude,
    required this.latitude,
    required this.kakaomapId,
    required this.hashtag,
    required this.geoHash,
  });

  VideoModel.fromJson({
    required Map<String, dynamic> json,
    required String videoId,
  })  : title = json["title"],
        description = json["description"],
        fileUrl = json["fileUrl"],
        thumbnailUrl = json["thumbnailUrl"],
        creatorUid = json["creatorUid"],
        likes = json["likes"],
        comments = json["comments"],
        createdAt = json["createdAt"],
        id = videoId,
        creator = json["creator"],
        location = json['location'],
        latitude = 0.0,
        longitude = 0.0,
        kakaomapId = json['kakaomapId'],
        hashtag = [],
        geoHash = json['geoHash'],
        address = json['address'];

  Map<String, dynamic> toJson() {
    return {
      "title": title,
      "description": description,
      "fileUrl": fileUrl,
      "thumbnailUrl": thumbnailUrl,
      "creatorUid": creatorUid,
      "likes": likes,
      "comments": comments,
      "createdAt": createdAt,
      "creator": creator,
      "id": id,
      "address": address,
      "location": location,
      "logitude": longitude,
      "latitude": latitude,
      "kakaomapId": kakaomapId,
      "geoHash": geoHash,
      "hashtag": hashtag,
    };
  }
}
