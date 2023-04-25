import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../constants/gaps.dart';
import '../../constants/sizes.dart';
import '../../widgets/form_button.dart';

class MessageScreen extends StatefulWidget {
  const MessageScreen({super.key});

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  final List<String> _notifications = List.generate(5, (index) => "$index 개월전");
  bool messageAlarm = true;
  void _onDismissed(String notification) {
    _notifications.remove(notification);
    setState(() {});
  }

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
        body: _notifications.isEmpty
            ? const Center(
                child: Text(
                  '깨끗한 책상처럼 \n메세지가 없어요!',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: Sizes.size24,
                  ),
                ),
              )
            : ListView(
                children: [
                  Gaps.v14,
                  for (var notification in _notifications)
                    Dismissible(
                      key: Key(notification),
                      onDismissed: (direction) => _onDismissed(notification),
                      background: Container(
                        alignment: Alignment.centerLeft,
                        color: Colors.green,
                        child: const Padding(
                          padding: EdgeInsets.only(
                            left: Sizes.size10,
                          ),
                          child: FaIcon(
                            FontAwesomeIcons.checkDouble,
                            color: Colors.white,
                            size: Sizes.size32,
                          ),
                        ),
                      ),
                      secondaryBackground: Container(
                        alignment: Alignment.centerRight,
                        color: Colors.red,
                        child: const Padding(
                          padding: EdgeInsets.only(
                            right: Sizes.size10,
                          ),
                          child: FaIcon(
                            FontAwesomeIcons.trashCan,
                            color: Colors.white,
                            size: Sizes.size32,
                          ),
                        ),
                      ),
                      child: ListTile(
                        leading: const CircleAvatar(),
                        title: RichText(
                          text: TextSpan(
                            text: "캡틴초이(@captainchoi)",
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                            children: [
                              TextSpan(
                                  text: " 3개월전",
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
                            const Text("당신이 만든 기록을 좋아해요!"),
                            GestureDetector(
                              onTap: () {
                                _onDismissed(notification);
                              },
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
                    )
                ],
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
