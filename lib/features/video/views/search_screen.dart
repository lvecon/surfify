import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:surfify/features/video/view_models/search_condition_view_model.dart';

import '../../../constants/gaps.dart';
import '../../../constants/sizes.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  SearchScreenState createState() => SearchScreenState();
}

class SearchScreenState extends ConsumerState<SearchScreen> {
  final TextEditingController _textController = TextEditingController();

  final hotSurfer = ["@rabbit2(서울토끼)", "@kingzo(식객조사장)"];
  final hotSurfingPoint = ["#맛집", "#드립커피", "#만화책방", "#모텔", "#당구장", "#노래방"];
  List<String> searchCondition = [];

  // 유저가 제일 앞으로 오도록 수정하고 return
  void _returnValue(BuildContext context) {
    List<String> modifiedCondition = List.from(searchCondition); // 배열 복사

    for (String condition in searchCondition) {
      if (condition.startsWith('@')) {
        modifiedCondition.remove(condition);
        modifiedCondition.insert(0, condition);
        break;
      }
    }
    ref.read(searchConditionProvider.notifier).setCondition(modifiedCondition);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    searchCondition = ref.watch(searchConditionProvider).searchCondition;
    return Container(
      height: size.height * 0.7,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Sizes.size14),
      ),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: false,
          centerTitle: false,
          elevation: 0,
          title: const Text(
            '탐색',
            style: TextStyle(
              fontSize: Sizes.size18,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {
                _returnValue(context);
              },
              icon: const FaIcon(
                FontAwesomeIcons.xmark,
                size: Sizes.size24,
                color: Colors.black,
              ),
            )
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _textController,
                      cursorColor: Theme.of(context).primaryColor,
                      decoration: InputDecoration(
                        hintText: "@서피네임, #키워드",
                        filled: true,
                        fillColor: Colors.grey.shade200,
                        enabledBorder: const UnderlineInputBorder(
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  Gaps.h12,
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        if (!searchCondition.contains(_textController.text)) {
                          if (_textController.text.isNotEmpty) {
                            if (_textController.text.startsWith('@') |
                                (_textController.text.startsWith('#'))) {
                              searchCondition.add(_textController.text);
                            }
                          }
                        }
                      });
                      _textController.clear();
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(
                        color: Theme.of(context).primaryColor,
                      )),
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          '추가',
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
              Gaps.v12,
              SizedBox(
                child: Wrap(children: [
                  for (var keyword in searchCondition)
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            16,
                          ),
                          color: keyword.toString().contains('@')
                              ? Theme.of(context).primaryColor
                              : Colors.red,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                keyword,
                                style: const TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              Gaps.h6,
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    searchCondition.removeWhere(
                                        (element) => element == keyword);
                                  });
                                },
                                child: const FaIcon(
                                  FontAwesomeIcons.xmark,
                                  size: Sizes.size12,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                ]),
              ),
              Gaps.v12,
              SizedBox(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Hot Surfer',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Gaps.v12,
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          for (var surfer in hotSurfer) Text(surfer),
                        ],
                      ),
                      Gaps.v24,
                    ]),
              ),
              Gaps.v12,
              SizedBox(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Hot Surfing Point',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Gaps.v12,
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          for (var surfingPoint in hotSurfingPoint)
                            Text(surfingPoint),
                        ],
                      ),
                    ]),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
