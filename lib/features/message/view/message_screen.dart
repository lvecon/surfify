import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:surfify/features/message/view_model/message_view_model.dart';
import 'package:surfify/features/video/models/video_model.dart';
import 'package:surfify/features/video/repo/videos_repo.dart';

import '../../../constants/gaps.dart';
import '../../../constants/sizes.dart';
import '../../../normalize/time.dart';
import '../../../widgets/form_button.dart';
import '../../users/user_profile_screen.dart';
import '../../users/view_models/user_view_model.dart';
import '../../video/views/widgets/video_post.dart';

class MessageScreen extends ConsumerStatefulWidget {
  final double latitude;
  final double longitude;
  const MessageScreen({
    super.key,
    required this.latitude,
    required this.longitude,
  });

  @override
  ConsumerState<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends ConsumerState<MessageScreen> {
  bool messageAlarm = true;

  Future<void> _deleteMessage(message) async {
    ref.read(messageProvider.notifier).deleteMessage(message);
    _onRefresh();
  }

  Future<void> _deleteAllMessage() async {
    ref.read(messageProvider.notifier).deleteAllMessage();
    _onRefresh();
  }

  Future<void> _onRefresh() {
    return ref.watch(messageProvider.notifier).refresh();
  }

  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    _onRefresh();
    final size = MediaQuery.of(context).size;

    void onClosePressed() {
      Navigator.of(context).pop();
    }

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
          title: const Padding(
            padding: EdgeInsets.only(
              top: Sizes.size8,
              left: Sizes.size8,
            ),
            child: Text(
              "Messages",
              style: TextStyle(
                fontSize: Sizes.size20,
                color: Colors.black,
              ),
            ),
          ),
          actions: [
            IconButton(
              onPressed: onClosePressed,
              icon: const FaIcon(FontAwesomeIcons.xmark, color: Colors.black),
            ),
          ],
        ),
        body: ref.watch(messageProvider).when(
              error: (error, stackTrace) => Center(
                child: Text(error.toString()),
              ),
              loading: () => const Center(
                child: CircularProgressIndicator.adaptive(),
              ),
              data: (data) => RefreshIndicator(
                onRefresh: _onRefresh,
                child: (data.isEmpty || !messageAlarm)
                    ? const Center(
                        child: Text(
                          '깨끗한 책상처럼 \n메세지가 없어요!',
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
                        itemBuilder: (context, index) => ListTile(
                          leading: GestureDetector(
                            onTap: () async {
                              await showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  backgroundColor: Colors.transparent,
                                  builder: (context) => UserProfileScreen(
                                      uid: data[index].creatorId));
                            },
                            child: FutureBuilder(builder:
                                (BuildContext context, AsyncSnapshot snapshot) {
                              if (ref
                                      .read(
                                          usersProvider(data[index].creatorId))
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
                                    .read(usersProvider(data[index].creatorId))
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
                                                data[index].creatorId))
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
                                    text: nomarlizeTime(data[index].createdAt),
                                    style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      color: Colors.black.withOpacity(0.8),
                                    )),
                              ],
                            ),
                          ),
                          subtitle: GestureDetector(
                            onTap: () async {
                              if (data[index].comment == '유저가 당신을 팔로우합니다') {
                                await showModalBottomSheet(
                                    context: context,
                                    isScrollControlled: true,
                                    backgroundColor: Colors.transparent,
                                    builder: (context) => UserProfileScreen(
                                        uid: data[index].creatorId));
                              } else {
                                final video = await ref
                                    .read(videosRepo)
                                    .fetchSpecificVideos(
                                        id: data[index].videoId);
                                final videoModel = VideoModel.fromJson(
                                    json: video.data()!,
                                    videoId: data[index].videoId);
                                await showModalBottomSheet(
                                    context: context,
                                    isScrollControlled: true,
                                    backgroundColor: Colors.transparent,
                                    builder: (context) => Container(
                                        height: size.height * 0.9,
                                        clipBehavior: Clip.hardEdge,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                              Sizes.size14),
                                        ),
                                        child: VideoPost(
                                          videoData: videoModel,
                                          onVideoFinished: () {},
                                          index: 0,
                                          radar: false,
                                          now: false,
                                          luckyMode: false,
                                          currentLatitude: widget.latitude,
                                          currentLongitude:
                                              widget.longitude, //수정필요
                                        )));
                              }
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(data[index].comment),
                                GestureDetector(
                                  onTap: () => _deleteMessage(data[index]),
                                  child: Text(
                                    "삭제",
                                    style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
              ),
            ),
        bottomNavigationBar: BottomAppBar(
          elevation: 0,
          color: const Color(0x00fafafa),
          child: GestureDetector(
            onTap: () {},
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(
                        flex: 1,
                        child: Row(
                          children: [
                            Radio(
                                value: true,
                                activeColor: Theme.of(context).primaryColor,
                                groupValue: messageAlarm,
                                onChanged: (value) {
                                  setState(() {
                                    messageAlarm = true;
                                  });
                                }),
                            const Expanded(
                              child: Text(
                                '메세지 알림',
                                style: TextStyle(
                                  fontSize: Sizes.size16,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Row(
                          children: [
                            Radio(
                                value: false,
                                activeColor: Theme.of(context).primaryColor,
                                groupValue: messageAlarm,
                                onChanged: (value) {
                                  _deleteAllMessage();
                                  setState(() {
                                    messageAlarm = false;
                                  });
                                }),
                            const Expanded(
                              child: Text(
                                '메세지 알림 끄기',
                                style: TextStyle(
                                  fontSize: Sizes.size16,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                    onTap: () {
                      _deleteAllMessage();
                    },
                    child: const FormButton(able: true, text: '메세지 모두 삭제')),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
