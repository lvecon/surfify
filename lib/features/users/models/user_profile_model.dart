class UserProfileModel {
  final String uid;
  final String name;
  final String profileAddress;
  final String link;
  final String intro;
  final bool hasAvatar;

  UserProfileModel({
    required this.uid,
    required this.name,
    required this.profileAddress,
    required this.link,
    required this.intro,
    required this.hasAvatar,
  });
  UserProfileModel.empty()
      : uid = "",
        name = "",
        profileAddress = "",
        link = "",
        intro = "",
        hasAvatar = false;

  UserProfileModel.fromJson(Map<String, dynamic> json)
      : uid = json["uid"],
        profileAddress = json["profileAddress"],
        name = json["name"],
        intro = json["intro"],
        link = json["link"],
        hasAvatar = json['hasAvatar'];

  Map<String, dynamic> toJson() {
    return {
      "uid": uid,
      "profileAddress": profileAddress,
      "name": name,
      "intro": intro,
      "link": link,
      "hasAvatar": hasAvatar,
    };
  }

  UserProfileModel copyWith({
    String? uid,
    String? profileAddress,
    String? name,
    String? intro,
    String? link,
    bool? hasAvatar,
  }) {
    return UserProfileModel(
      uid: uid ?? this.uid,
      profileAddress: profileAddress ?? this.profileAddress,
      name: name ?? this.name,
      intro: intro ?? this.intro,
      link: link ?? this.link,
      hasAvatar: hasAvatar ?? this.hasAvatar,
    );
  }
}
