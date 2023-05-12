class UserProfileModel {
  final String uid;
  final String name;
  final String profileAddress;
  final String link;
  final String intro;
  final int follower;
  final int following;
  final int likes;
  final bool hasAvatar;
  final bool serviceAgree;
  final String serviceAgreeDate;
  final bool privacyAgree;
  final String privacyAgreeDate;
  final bool marketingAgree;
  final String marketingAgreeDate;
  final int surfingPoints;

  UserProfileModel({
    required this.uid,
    required this.name,
    required this.profileAddress,
    required this.link,
    required this.intro,
    required this.follower,
    required this.following,
    required this.likes,
    required this.hasAvatar,
    required this.serviceAgree,
    required this.serviceAgreeDate,
    required this.privacyAgree,
    required this.privacyAgreeDate,
    required this.marketingAgree,
    required this.marketingAgreeDate,
    required this.surfingPoints,
  });
  UserProfileModel.empty()
      : uid = "",
        name = "",
        profileAddress = "",
        link = "",
        intro = "",
        follower = 0,
        following = 0,
        likes = 0,
        surfingPoints = 0,
        hasAvatar = false,
        serviceAgree = false,
        privacyAgree = false,
        marketingAgree = false,
        serviceAgreeDate = "",
        privacyAgreeDate = "",
        marketingAgreeDate = "";

  UserProfileModel.fromJson(Map<String, dynamic> json)
      : uid = json["uid"],
        profileAddress = json["profileAddress"],
        name = json["name"],
        intro = json["intro"],
        link = json["link"],
        follower = json['follower'],
        following = json['following'],
        likes = json['likes'],
        surfingPoints = json['surfingPoints'],
        hasAvatar = json['hasAvatar'],
        serviceAgree = json['serviceAgree'],
        privacyAgree = json['privacyAgree'],
        marketingAgree = json['marketingAgree'],
        serviceAgreeDate = json['serviceAgreeDate'],
        privacyAgreeDate = json['privacyAgreeDate'],
        marketingAgreeDate = json['marketingAgreeDate'];

  Map<String, dynamic> toJson() {
    return {
      "uid": uid,
      "profileAddress": profileAddress,
      "name": name,
      "intro": intro,
      "link": link,
      "follower": follower,
      "following": following,
      "likes": likes,
      "surfingPoints": surfingPoints,
      "hasAvatar": hasAvatar,
      "serviceAgree": serviceAgree,
      "privacyAgree": privacyAgree,
      "marketingAgree": marketingAgree,
      "serviceAgreeDate": serviceAgreeDate,
      "privacyAgreeDate": privacyAgreeDate,
      "marketingAgreeDate": marketingAgreeDate,
    };
  }

  UserProfileModel copyWith({
    String? uid,
    String? profileAddress,
    String? name,
    String? intro,
    String? link,
    int? follower,
    int? following,
    int? likes,
    int? surfingPoints,
    bool? hasAvatar,
    bool? serviceAgree,
    String? serviceAgreeDate,
    bool? privacyAgree,
    String? privacyAgreeDate,
    bool? marketingAgree,
    String? marketingAgreeDate,
  }) {
    return UserProfileModel(
      uid: uid ?? this.uid,
      profileAddress: profileAddress ?? this.profileAddress,
      name: name ?? this.name,
      intro: intro ?? this.intro,
      link: link ?? this.link,
      follower: follower ?? this.follower,
      following: following ?? this.following,
      likes: likes ?? this.likes,
      surfingPoints: surfingPoints ?? this.surfingPoints,
      hasAvatar: hasAvatar ?? this.hasAvatar,
      serviceAgree: serviceAgree ?? this.serviceAgree,
      serviceAgreeDate: serviceAgreeDate ?? this.serviceAgreeDate,
      privacyAgree: privacyAgree ?? this.privacyAgree,
      privacyAgreeDate: privacyAgreeDate ?? this.privacyAgreeDate,
      marketingAgree: marketingAgree ?? this.marketingAgree,
      marketingAgreeDate: marketingAgreeDate ?? this.marketingAgreeDate,
    );
  }
}
