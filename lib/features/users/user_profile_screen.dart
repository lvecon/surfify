import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:surfify/features/authentication/repos/authentication_repo.dart';
import 'package:surfify/features/message/view_model/message_view_model.dart';
import 'package:surfify/features/users/setting_screen.dart';
import 'package:surfify/features/users/view_models/profile_view_model.dart';
import 'package:surfify/features/users/view_models/user_view_model.dart';
import 'package:surfify/features/users/views/avatar.dart';
import 'package:surfify/features/users/view_models/following_view_model.dart';
import 'package:surfify/features/users/views/followers_list.dart';
import 'package:surfify/features/users/views/following_list.dart';

import '../../constants/gaps.dart';
import '../../constants/sizes.dart';
import 'edit_profile_scree.dart';

class UserProfileScreen extends ConsumerStatefulWidget {
  final String uid;

  const UserProfileScreen({super.key, required this.uid});

  @override
  createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends ConsumerState<UserProfileScreen> {
  bool pushFollow = true;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    var myProfile = (ref.read(authRepo).user!.uid == widget.uid);
    void _onClosePressed() {
      Navigator.of(context).pop();
    }

    return ref.watch(usersProvider(widget.uid)).when(
          error: (error, stackTrace) => Center(
            child: Text(error.toString()),
          ),
          loading: () => const Center(
            child: CircularProgressIndicator.adaptive(),
          ),
          data: (data) => Container(
            height: size.height * 0.95,
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Sizes.size14),
              color: Colors.white,
            ),
            child: Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: false,
                backgroundColor: const Color(0x00f5f5f5),
                elevation: 0,
                actions: [
                  IconButton(
                    onPressed: _onClosePressed,
                    icon: const FaIcon(
                      FontAwesomeIcons.xmark,
                      size: Sizes.size24,
                      color: Colors.black,
                    ),
                  )
                ],
              ),
              body: NestedScrollView(
                headerSliverBuilder: (context, innerBoxIsScrolled) {
                  return [
                    SliverToBoxAdapter(
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              GestureDetector(
                                onTap: () async {
                                  await showModalBottomSheet(
                                      context: context,
                                      isScrollControlled: true,
                                      backgroundColor: Colors.transparent,
                                      builder: (context) => FollowersList(
                                            uid: widget.uid,
                                          ));
                                },
                                child: Column(
                                  children: [
                                    Text(
                                      '${data.follower}',
                                      style: const TextStyle(
                                        fontSize: Sizes.size24,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const Text(
                                      'Followers',
                                      style: TextStyle(
                                        fontSize: Sizes.size16,
                                        fontWeight: FontWeight.w300,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Avatar(
                                uid: data.uid,
                                name: data.name,
                                hasAvatar: data.hasAvatar,
                              ),
                              GestureDetector(
                                onTap: () async {
                                  await showModalBottomSheet(
                                      context: context,
                                      isScrollControlled: true,
                                      backgroundColor: Colors.transparent,
                                      builder: (context) => FollowingsList(
                                            uid: widget.uid,
                                          ));
                                },
                                child: Column(
                                  children: [
                                    Text(
                                      '${data.following}',
                                      style: const TextStyle(
                                        fontSize: Sizes.size24,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const Text(
                                      'Following',
                                      style: TextStyle(
                                        fontSize: Sizes.size16,
                                        fontWeight: FontWeight.w300,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Gaps.v20,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '${data.name}(@${data.profileAddress})',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: Sizes.size18,
                                ),
                              ),
                            ],
                          ),
                          Gaps.v2,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '${data.likes}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: Sizes.size16,
                                ),
                              ),
                              const Text(
                                ' Surfing Points and ',
                                style: TextStyle(
                                  fontWeight: FontWeight.w200,
                                  fontSize: Sizes.size16,
                                ),
                              ),
                              Text(
                                '${data.likes}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: Sizes.size16,
                                ),
                              ),
                              const Text(
                                ' Likes',
                                style: TextStyle(
                                  fontWeight: FontWeight.w200,
                                  fontSize: Sizes.size16,
                                ),
                              ),
                            ],
                          ),
                          Gaps.v16,
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: Sizes.size32,
                            ),
                            child: Text(
                              data.intro,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: Sizes.size16,
                              ),
                            ),
                          ),
                          Gaps.v24,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              myProfile
                                  ? GestureDetector(
                                      onTap: () async {
                                        await showModalBottomSheet(
                                            context: context,
                                            isScrollControlled: true,
                                            backgroundColor: Colors.transparent,
                                            builder: (context) =>
                                                const SettingScreen());
                                      },
                                      child: FaIcon(
                                        FontAwesomeIcons.gear,
                                        color: Theme.of(context).primaryColor,
                                        size: Sizes.size24,
                                      ),
                                    )
                                  : const FaIcon(
                                      FontAwesomeIcons.gear,
                                      color: Colors.white,
                                      size: Sizes.size24,
                                    ),
                              Container(
                                  width: Sizes.size128 + Sizes.size64,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: Sizes.size12,
                                  ),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      width: 1,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  ),
                                  child: myProfile
                                      ? GestureDetector(
                                          onTap: () async {
                                            await showModalBottomSheet(
                                                context: context,
                                                isScrollControlled: true,
                                                backgroundColor:
                                                    Colors.transparent,
                                                builder: (context) =>
                                                    const EditProfileScreen());
                                          },
                                          child: Text(
                                            'Edit Profile',
                                            style: TextStyle(
                                              fontSize: Sizes.size16,
                                              fontWeight: FontWeight.w600,
                                              color: Theme.of(context)
                                                  .primaryColor,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        )
                                      : ref
                                          .watch(followProvider(widget.uid))
                                          .when(
                                              error: (error, stackTrace) =>
                                                  Center(
                                                    child:
                                                        Text(error.toString()),
                                                  ),
                                              loading: () => const Center(
                                                    child:
                                                        CircularProgressIndicator
                                                            .adaptive(),
                                                  ),
                                              data: (data) {
                                                return GestureDetector(
                                                    onTap: () {
                                                      ref
                                                          .watch(usersProvider(ref
                                                                  .read(
                                                                      authRepo)
                                                                  .user!
                                                                  .uid)
                                                              .notifier)
                                                          .followUser(
                                                              uid2: widget.uid);
                                                      setState(() {
                                                        pushFollow =
                                                            !pushFollow;
                                                      });
                                                      ref
                                                          .read(messageProvider
                                                              .notifier)
                                                          .addMessage(
                                                            videoId: null,
                                                            comment:
                                                                "당신을 Follow 합니다!",
                                                            receiverId:
                                                                widget.uid,
                                                          );
                                                    },
                                                    child: (data == pushFollow)
                                                        ? Text(
                                                            'Following',
                                                            style: TextStyle(
                                                              fontSize:
                                                                  Sizes.size16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              color: Theme.of(
                                                                      context)
                                                                  .primaryColor,
                                                            ),
                                                            textAlign: TextAlign
                                                                .center,
                                                          )
                                                        : Text(
                                                            '팔로우하기',
                                                            style: TextStyle(
                                                              fontSize:
                                                                  Sizes.size16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              color: Theme.of(
                                                                      context)
                                                                  .primaryColor,
                                                            ),
                                                            textAlign: TextAlign
                                                                .center,
                                                          ));
                                              })),
                              FaIcon(
                                FontAwesomeIcons.shareNodes,
                                color: Theme.of(context).primaryColor,
                                size: Sizes.size24,
                              ),
                            ],
                          ),
                          Gaps.v14,
                          Gaps.v20,
                        ],
                      ),
                    ),
                  ];
                },
                body: ref.read(profileProvider(widget.uid)).when(
                      error: (error, stackTrace) => Center(
                        child: Text(error.toString()),
                      ),
                      loading: () => const Center(
                        child: CircularProgressIndicator.adaptive(),
                      ),
                      data: (data) => (data.isEmpty)
                          ? const Center(
                              child: Text('아직 영상이 없습니다!'),
                            )
                          : GridView.builder(
                              itemCount: data.length,
                              padding: EdgeInsets.zero,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                crossAxisSpacing: Sizes.size2,
                                mainAxisSpacing: Sizes.size2,
                                childAspectRatio: 9 / 14,
                              ),
                              itemBuilder: (context, index) => Column(
                                children: [
                                  AspectRatio(
                                    aspectRatio: 9 / 14,
                                    child: FadeInImage.assetNetwork(
                                      fit: BoxFit.cover,
                                      placeholder: "assets/images/user.png",
                                      image: data[index].thumbnailUrl,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                    ),
              ),
            ),
          ),
        );
  }
}
