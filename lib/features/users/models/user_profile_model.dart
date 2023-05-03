class UserProfileModel {
  final String uid;
  final String name;
  final String profileAddress;
  final String link;
  final String intro;
  final int follower;
  final int likes;
  final bool hasAvatar;
  final bool serviceAgree;
  final String serviceAgreeDate;
  final bool privacyAgree;
  final String privacyAgreeDate;
  final bool marketingAgree;
  final String marketingAgreeDate;

  UserProfileModel({
    required this.uid,
    required this.name,
    required this.profileAddress,
    required this.link,
    required this.intro,
    required this.follower,
    required this.likes,
    required this.hasAvatar,
    required this.serviceAgree,
    required this.serviceAgreeDate,
    required this.privacyAgree,
    required this.privacyAgreeDate,
    required this.marketingAgree,
    required this.marketingAgreeDate,
  });
  UserProfileModel.empty()
      : uid = "",
        name = "",
        profileAddress = "",
        link = "",
        intro = "",
        follower = 0,
        likes = 0,
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
        likes = json['likes'],
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
      "likes": likes,
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
    int? likes,
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
      likes: likes ?? this.likes,
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
