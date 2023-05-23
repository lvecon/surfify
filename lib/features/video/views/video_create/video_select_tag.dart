import 'dart:convert';

import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:surfify/constants/gaps.dart';
import 'package:surfify/constants/sizes.dart';
import 'package:surfify/features/video/views/video_create/video_uploaded_screen.dart';
import 'package:surfify/keyMap.dart';

class VideoSelectTag extends StatefulWidget {
  final XFile video;
  final String address;
  final String name;
  final String lat;
  final String lon;
  final String url;
  final String resStr;
  const VideoSelectTag({
    super.key,
    required this.video,
    required this.address,
    required this.name,
    required this.lat,
    required this.lon,
    required this.url,
    required this.resStr,
  });

  @override
  State<VideoSelectTag> createState() => VideoSelectTagState();
}

class VideoSelectTagState extends State<VideoSelectTag> {
  bool _isWriting = false;
  final TextEditingController _textEditingController = TextEditingController();

  final ScrollController _scrollController = ScrollController();
  String inputValue = "";
  List<String> resultsText = [];

  void _onClosePressed() {
    Navigator.of(context).pop();
  }

  void _stopWriting() {
    FocusScope.of(context).unfocus();
    setState(() {
      _isWriting = false;
    });
  }

  // void _onStartWriting() {
  //   setState(() {
  //     _isWriting = true;
  //   });
  // }

  void _setTextToFormField(String text) {
    _textEditingController.text += text;
    inputValue = _textEditingController.text;
    _textEditingController.selection = TextSelection.fromPosition(
        TextPosition(offset: _textEditingController.text.length));
    setState(() {});
  }

  Future<void> _saveToGallery() async {
    setState(() {});
    if (!mounted) return;
    Navigator.of(context).pop();
    Navigator.of(context).pop();
    Navigator.of(context).pop();
    Navigator.of(context).pop();

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => VideoUploadedScreen(
          video: widget.video,
          address: widget.address,
          name: widget.name,
          tags: inputValue,
          lat: widget.lat,
          lon: widget.lon,
          url: widget.url,
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    if (widget.resStr != "Empty") {
      List<dynamic> resJson = jsonDecode(widget.resStr);
      for (List<dynamic> result in resJson) {
        String label = result[0];
        resultsText.add(KeyMap().translations[label]!);
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      height: size.height * 0.75,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Sizes.size14),
      ),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.grey.shade50,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(80),
          child: GestureDetector(
            onTap: _stopWriting,
            child: AppBar(
              toolbarHeight: 100,
              elevation: 0,
              centerTitle: false,
              backgroundColor: Colors.grey.shade50,
              automaticallyImplyLeading: false,
              title: Padding(
                padding: const EdgeInsets.only(
                  left: Sizes.size8,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "기록 설명 변경",
                          style: TextStyle(
                            fontSize: Sizes.size20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        IconButton(
                          onPressed: _onClosePressed,
                          icon: const FaIcon(FontAwesomeIcons.xmark,
                              color: Colors.black),
                        ),
                      ],
                    ),
                    const Text(
                      "해쉬태그#를 써서 사람들이 쉽게 발견하게 해봐요",
                      style: TextStyle(
                        fontSize: Sizes.size16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black45,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(children: [
                for (var keyword in resultsText)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 4.0, horizontal: 3),
                    child: GestureDetector(
                      onTap: () => {
                        _setTextToFormField("#$keyword"),
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                              16,
                            ),
                            color: Theme.of(context)
                                .primaryColor
                                .withOpacity(0.7)),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 8, bottom: 8, left: 8, right: 5),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "#$keyword +",
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              ),
                              Gaps.h6,
                              // const FaIcon(
                              //   FontAwesomeIcons.plus,
                              //   size: Sizes.size14,
                              //   color: Colors.white,
                              // ),
                              // Gaps.h2,
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
              ]),
              Gaps.v6,
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: Sizes.size4,
                    vertical: Sizes.size2,
                  ),
                  child: TextFormField(
                    controller: _textEditingController,
                    textInputAction: TextInputAction.done,
                    maxLines: 25,
                    cursorColor: Theme.of(context).primaryColor,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey.shade200,
                      enabledBorder: const UnderlineInputBorder(
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onChanged: (value) => setState(() {
                      inputValue = value;
                    }),
                  ),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: Sizes.size16,
            vertical: 40,
          ),
          child: SizedBox(
            width: 330,
            height: Sizes.size64,
            child: CupertinoButton(
              onPressed: () => _saveToGallery(),
              color: Theme.of(context).primaryColor,
              child: const Text(
                "입력 완료",
                style: TextStyle(
                  fontSize: Sizes.size20,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
