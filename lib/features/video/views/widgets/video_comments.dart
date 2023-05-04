import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:surfify/constants/gaps.dart';
import 'package:surfify/constants/sizes.dart';
import 'package:surfify/features/video/view_models/commets_view_model.dart';

class VideoComments extends ConsumerStatefulWidget {
  final String videoId;
  const VideoComments({super.key, required this.videoId});

  @override
  createState() => _VideoCommentsState();
}

class _VideoCommentsState extends ConsumerState<VideoComments> {
  bool _isWriting = false;

  final ScrollController _scrollController = ScrollController();

  void _onClosePressed() {
    Navigator.of(context).pop();
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
              "댓글 701개",
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
        body: GestureDetector(
          onTap: _stopWriting,
          child: Stack(
            children: [
              Scrollbar(
                  controller: _scrollController,
                  child: ref.read(commentsProvider(widget.videoId)).when(
                        error: (error, stackTrace) => Center(
                          child: Text(error.toString()),
                        ),
                        loading: () => const Center(
                          child: CircularProgressIndicator.adaptive(),
                        ),
                        data: (data) => ListView.separated(
                          controller: _scrollController,
                          padding: const EdgeInsets.only(
                            top: Sizes.size10,
                            bottom: Sizes.size96 + Sizes.size20,
                            left: Sizes.size16,
                            right: Sizes.size16,
                          ),
                          separatorBuilder: (context, index) => Gaps.v20,
                          itemCount: data.length,
                          itemBuilder: (context, index) => Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CircleAvatar(
                                radius: 18,
                                child: Text('${data[index].creatorId}'),
                              ),
                              Gaps.h10,
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '훈',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: Sizes.size14,
                                          color: Colors.grey.shade500),
                                    ),
                                    Gaps.v3,
                                    Text("${data[index].comment}")
                                  ],
                                ),
                              ),
                              Gaps.h10,
                              Column(
                                children: [
                                  FaIcon(
                                    FontAwesomeIcons.heart,
                                    size: Sizes.size20,
                                    color: Colors.grey.shade500,
                                  ),
                                  Gaps.v2,
                                  Text(
                                    '52.2K',
                                    style: TextStyle(
                                      color: Colors.grey.shade500,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      )),
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
                              child: Image.asset(
                                'assets/images/user.png',
                              ),
                            ),
                          ),
                        ),
                        Gaps.h10,
                        Expanded(
                          child: SizedBox(
                            height: Sizes.size44,
                            child: TextField(
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
                                            onTap: _stopWriting,
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
