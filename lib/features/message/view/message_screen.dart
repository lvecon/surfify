import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:surfify/features/message/view_model/message_view_model.dart';

import '../../../constants/gaps.dart';
import '../../../constants/sizes.dart';
import '../../../normalize/time.dart';
import '../../../widgets/form_button.dart';
import '../../users/user_profile_screen.dart';
import '../../users/view_models/user_view_model.dart';

class MessageScreen extends ConsumerStatefulWidget {
  const MessageScreen({super.key});

  @override
  ConsumerState<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends ConsumerState<MessageScreen> {
  final List<String> _notifications = List.generate(5, (index) => "$index 개월전");
  bool messageAlarm = true;
  void _onDismissed(String notification) {
    _notifications.remove(notification);
    setState(() {});
  }

  Future<void> _deleteMessage(message) async {
    ref.read(messageProvider.notifier).deleteMessage(message);
    _onRefresh();
  }

  Future<void> _addMessage() async {
    ref.read(messageProvider.notifier).addMessage(
        comment: "안녕",
        videoId: "1",
        receiverId: "9OwBI6OFzSfPP5fWrIWb3EpWWPD2");
    _onRefresh();
  }

  Future<void> _onRefresh() {
    return ref.watch(messageProvider.notifier).refresh();
  }

  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    void _onClosePressed() {
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
              onPressed: _onClosePressed,
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
            data: (data) => (data.isEmpty)
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
                        child: CircleAvatar(
                          radius: Sizes.size18,
                          child: SizedBox(
                            child: ClipOval(
                              child: Image.network(
                                'https://firebasestorage.googleapis.com/v0/b/surfify.appspot.com/o/avatars%2F${data[index].creatorId}?alt=media',
                              ),
                            ),
                          ),
                        ),
                      ),
                      title: RichText(
                        text: TextSpan(
                          text: ref
                                  .watch(usersProvider(data[index].creatorId))
                                  .value
                                  ?.name ??
                              '로딩중...',
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
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("${data[index].comment}"),
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
                  )),
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
                      _addMessage();
                    },
                    child: const FormButton(able: true, text: '메세지 하나 만들기')),
                GestureDetector(
                    onTap: () {
                      setState(() {
                        _notifications.clear();
                      });
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
