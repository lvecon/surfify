import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:surfify/constants/gaps.dart';
import 'package:surfify/constants/sizes.dart';
import 'package:surfify/features/message/view_model/message_view_model.dart';
import 'package:surfify/features/users/view_models/user_view_model.dart';
import 'package:surfify/features/video/view_models/commets_view_model.dart';

import '../../../../normalize/time.dart';
import '../../../authentication/repos/authentication_repo.dart';
import '../../../users/user_profile_screen.dart';

class VideoComments extends ConsumerStatefulWidget {
  final String videoId;
  final String creatorId;
  const VideoComments({
    super.key,
    required this.videoId,
    required this.creatorId,
  });

  @override
  createState() => _VideoCommentsState();
}

class _VideoCommentsState extends ConsumerState<VideoComments> {
  final TextEditingController _textController = TextEditingController();

  bool _isWriting = false;

  final ScrollController _scrollController = ScrollController();

  void _onClosePressed() {
    Navigator.of(context).pop();
  }

  void _stopWriting() {
    setState(() {
      _isWriting = false;
    });
  }

  Future<void> _postComment() async {
    ref.read(commentsProvider(widget.videoId).notifier).uploadComment(
          videoId: widget.videoId,
          comment: _textController.text,
        );
    _onRefresh();
    FocusScope.of(context).unfocus();
    _textController.clear();
    setState(() {
      _isWriting = false;
    });
    ref.read(messageProvider.notifier).addMessage(
          videoId: widget.videoId,
          comment: "당신이 만든 기록에 댓글을 달았어요!",
          receiverId: widget.creatorId,
        );
  }

  Future<void> _deleteComment(comemntModel) async {
    ref
        .read(commentsProvider(widget.videoId).notifier)
        .deleteComment(comemntModel);
    _onRefresh();
  }

  void _onStartWriting() {
    setState(() {
      _isWriting = true;
    });
  }

  Future<void> _onRefresh() {
    return ref
        .watch(commentsProvider(widget.videoId).notifier)
        .refresh(widget.videoId);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    //_onRefresh();
    return Container(
      height: size.height * 0.75,
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
          title: Padding(
            padding: const EdgeInsets.only(
              top: Sizes.size8,
              left: Sizes.size8,
            ),
            child: ref.watch(commentsProvider(widget.videoId)).when(
                  error: (error, stackTrace) => Center(
                    child: Text(error.toString()),
                  ),
                  loading: () => const Center(
                    child: CircularProgressIndicator.adaptive(),
                  ),
                  data: (data) => Text(
                    "댓글 ${data.length}개",
                    style: const TextStyle(
                      fontSize: Sizes.size20,
                      color: Colors.black,
                    ),
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
        body: GestureDetector(
          onTap: _stopWriting,
          child: Stack(
            children: [
              RefreshIndicator(
                onRefresh: _onRefresh,
                child: Scrollbar(
                  controller: _scrollController,
                  child: ref.watch(commentsProvider(widget.videoId)).when(
                        error: (error, stackTrace) => Center(
                          child: Text(error.toString()),
                        ),
                        loading: () => const Center(
                          child: CircularProgressIndicator.adaptive(),
                        ),
                        data: (data) => (data.isEmpty)
                            ? const Center(
                                child: Text(
                                  '1등으로 댓글을\n달 수 있는 기회입니다!\n\n\n\n\n',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: Sizes.size24,
                                  ),
                                ),
                              )
                            : ListView.separated(
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
                                  return ListTile(
                                    leading: GestureDetector(
                                      onTap: () async {
                                        await showModalBottomSheet(
                                            context: context,
                                            isScrollControlled: true,
                                            backgroundColor: Colors.transparent,
                                            builder: (context) =>
                                                UserProfileScreen(
                                                    uid:
                                                        data[index].creatorId));
                                      },
                                      child: FutureBuilder(builder:
                                          (BuildContext context,
                                              AsyncSnapshot snapshot) {
                                        if (ref
                                                .read(usersProvider(
                                                    data[index].creatorId))
                                                .value ==
                                            null) {
                                          return const Text(
                                            '...',
                                            style: TextStyle(
                                              fontSize: Sizes.size20,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          );
                                        } else {
                                          if (ref
                                              .read(usersProvider(
                                                  data[index].creatorId))
                                              .value!
                                              .hasAvatar) {
                                            return CircleAvatar(
                                              radius: 28,
                                              foregroundImage: NetworkImage(
                                                  "https://firebasestorage.googleapis.com/v0/b/surfify.appspot.com/o/avatars%2F${data[index].creatorId}?alt=media"),
                                              child: null,
                                            );
                                          } else {
                                            return CircleAvatar(
                                                radius: 28,
                                                foregroundImage: null,
                                                child: Text(
                                                  ref
                                                      .read(usersProvider(
                                                          data[index]
                                                              .creatorId))
                                                      .value!
                                                      .name,
                                                ));
                                          }
                                        }
                                      }),
                                    ),
                                    title: RichText(
                                      text: TextSpan(
                                        text:
                                            '${ref.watch(usersProvider(data[index].creatorId)).value?.name}  ',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black,
                                        ),
                                        children: [
                                          TextSpan(
                                              text: nomarlizeTime(
                                                  data[index].createdAt),
                                              style: TextStyle(
                                                fontWeight: FontWeight.normal,
                                                color: Colors.black
                                                    .withOpacity(0.8),
                                              )),
                                        ],
                                      ),
                                    ),
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(data[index].comment),
                                        if (data[index].creatorId ==
                                            ref.read(authRepo).user!.uid)
                                          GestureDetector(
                                            onTap: () {},
                                            child: Text(
                                              "삭제",
                                              style: TextStyle(
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  );
                                }),
                      ),
                ),
              ),
              Positioned(
                bottom: 0,
                width: size.width,
                child: BottomAppBar(
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: Sizes.size16,
                      vertical: Sizes.size10,
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: Sizes.size18,
                          child: SizedBox(
                            child: ClipOval(
                              child: Image.network(
                                'https://firebasestorage.googleapis.com/v0/b/surfify.appspot.com/o/avatars%2F${ref.read(authRepo).user!.uid}?alt=media',
                              ),
                            ),
                          ),
                        ),
                        Gaps.h10,
                        Expanded(
                          child: SizedBox(
                            height: Sizes.size44,
                            child: TextField(
                              controller: _textController,
                              onTap: _onStartWriting,
                              expands: true,
                              minLines: null,
                              maxLines: null,
                              textInputAction: TextInputAction.newline,
                              cursorColor: Theme.of(context).primaryColor,
                              decoration: InputDecoration(
                                  hintText: "기분 좋은 응원 한마디~",
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
                                    padding: const EdgeInsets.only(
                                        right: Sizes.size8),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        if (_isWriting)
                                          GestureDetector(
                                            onTap: _postComment,
                                            child: const FaIcon(
                                              FontAwesomeIcons.paperPlane,
                                              color: Colors.grey,
                                            ),
                                          ),
                                      ],
                                    ),
                                  )),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
