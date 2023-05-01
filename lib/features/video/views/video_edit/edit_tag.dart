import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:surfify/constants/gaps.dart';
import 'package:surfify/constants/sizes.dart';

class EditTag extends StatefulWidget {
  final String originalTag;
  const EditTag({
    super.key,
    required this.originalTag,
  });

  @override
  State<EditTag> createState() => EditTagState();
}

class EditTagState extends State<EditTag> {
  bool _isWriting = false;
  final TextEditingController _textEditingController = TextEditingController();

  final ScrollController _scrollController = ScrollController();
  String inputValue = "";

  void _onClosePressed() {
    Navigator.pop(context, widget.originalTag);
  }

  void _stopWriting() {
    FocusScope.of(context).unfocus();
    setState(() {
      _isWriting = false;
    });
  }

  void _onStartWriting() {
    setState(() {
      _isWriting = true;
    });
  }

  void _returnValue(BuildContext context) {
    Navigator.pop(context, inputValue);
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
          preferredSize: const Size.fromHeight(Sizes.size96),
          child: GestureDetector(
            onTap: _stopWriting,
            child: AppBar(
              toolbarHeight: Sizes.size96,
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
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: Sizes.size24,
                vertical: Sizes.size12,
              ),
              child: TextFormField(
                textInputAction: TextInputAction.done,
                maxLines: 18,
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
            Gaps.v10,
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: Sizes.size16,
                vertical: Sizes.size10,
              ),
              child: SizedBox(
                width: 330,
                height: Sizes.size64,
                child: CupertinoButton(
                  onPressed: () => _returnValue(context),
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
            )
          ],
        ),
      ),
    );
  }
}
