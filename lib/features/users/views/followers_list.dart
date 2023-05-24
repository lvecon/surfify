import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:surfify/constants/gaps.dart';
import 'package:surfify/constants/sizes.dart';
import 'package:surfify/features/users/view_models/user_view_model.dart';

import '../user_profile_screen.dart';
import '../view_models/follower_list_view_model.dart';

class FollowersList extends ConsumerStatefulWidget {
  final String uid;

  const FollowersList({
    super.key,
    required this.uid,
  });

  @override
  createState() => _FollowersListState();
}

class _FollowersListState extends ConsumerState<FollowersList> {
  final TextEditingController _textController = TextEditingController();

  final ScrollController _scrollController = ScrollController();

  void _onClosePressed() {
    Navigator.of(context).pop();
  }

  void _onStartWriting() {
    setState(() {});
  }

  void _onRefresh() {
    ref.watch(followerListProvider(widget.uid).notifier).refresh(widget.uid);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    _onRefresh();
    return Container(
        height: size.height * 0.95,
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Sizes.size14),
        ),
        child: Scaffold(
          backgroundColor: Colors.grey.shade50,
          appBar: AppBar(
            elevation: 0.3,
            centerTitle: false,
            backgroundColor: Colors.grey.shade50,
            automaticallyImplyLeading: false,
            title: const Padding(
              padding: EdgeInsets.only(
                top: Sizes.size8,
                left: Sizes.size8,
              ),
              child: Text(
                "Followers",
                style: TextStyle(
                  fontSize: Sizes.size20,
                  color: Colors.black,
                ),
              ),
            ),
            actions: [
              IconButton(
                onPressed: _onClosePressed,
                icon: const FaIcon(FontAwesomeIcons.xmark, color: Colors.black),
              ),
            ],
          ),
          body: ref.watch(followerListProvider(widget.uid)).when(
                error: (error, stackTrace) => Center(
                  child: Text(error.toString()),
                ),
                loading: () => const Center(
                  child: CircularProgressIndicator.adaptive(),
                ),
                data: (data) => (data.isEmpty)
                    ? const Center(
                        child: Text(
                          '아직 팔로워가 없어요',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: Sizes.size24,
                          ),
                        ),
                      )
                    : Column(children: [
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: TextField(
                            controller: _textController,
                            onTap: _onStartWriting,
                            textInputAction: TextInputAction.newline,
                            cursorColor: Theme.of(context).primaryColor,
                            decoration: InputDecoration(
                                hintText: "팔로워 찾기",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                    Sizes.size12,
                                  ),
                                  borderSide: BorderSide.none,
                                ),
                                filled: true,
                                fillColor: Colors.grey.shade200,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: Sizes.size12,
                                ),
                                suffixIcon: Padding(
                                  padding:
                                      const EdgeInsets.only(right: Sizes.size8),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      FaIcon(
                                        FontAwesomeIcons.magnifyingGlass,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                    ],
                                  ),
                                )),
                          ),
                        ),
                        Expanded(
                          child: ListView.separated(
                            controller: _scrollController,
                            padding: const EdgeInsets.only(
                              top: Sizes.size10,
                              bottom: Sizes.size96 + Sizes.size20,
                              left: Sizes.size16,
                              right: Sizes.size16,
                            ),
                            separatorBuilder: (context, index) => Gaps.v20,
                            itemCount: data.length,
                            itemBuilder: (context, index) {
                              return ref.watch(usersProvider(data[index])).when(
                                    loading: () => const Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                    error: (error, stackTrace) => Center(
                                      child: Text(
                                        'Could not load videos: $error',
                                        style: const TextStyle(
                                            color: Colors.white),
                                      ),
                                    ),
                                    data: (data) {
                                      if (data.name
                                          .contains(_textController.text)) {
                                        return ListTile(
                                          leading: GestureDetector(
                                            onTap: () async {
                                              await showModalBottomSheet(
                                                  context: context,
                                                  isScrollControlled: true,
                                                  backgroundColor:
                                                      Colors.transparent,
                                                  builder: (context) =>
                                                      UserProfileScreen(
                                                          uid: data.uid));
                                            },
                                            child: CircleAvatar(
                                              radius: Sizes.size24,
                                              child: SizedBox(
                                                child: ClipOval(
                                                  child: Image.network(
                                                    'https://firebasestorage.googleapis.com/v0/b/surfify.appspot.com/o/avatars%2F${data.uid}?alt=media',
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          title: RichText(
                                            text: TextSpan(
                                              text: data.name,
                                              style: const TextStyle(
                                                fontSize: Sizes.size16,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                          subtitle: Text(
                                            '@${data.profileAddress}',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w300,
                                              color: Colors.black,
                                            ),
                                          ),
                                          trailing: Text(
                                            'Follow',
                                            style: TextStyle(
                                              color: Theme.of(context)
                                                  .primaryColor,
                                            ),
                                          ),
                                        );
                                      }
                                      return null;
                                    },
                                  );
                            },
                          ),
                        ),
                      ]),
              ),
        ));
  }
}
