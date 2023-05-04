import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:surfify/constants/sizes.dart';
import 'package:surfify/features/video/views/video_create/video_select_tag.dart';
import 'package:surfify/widgets/search_map.dart';

import '../../../../constants/gaps.dart';

class VideoSelectLocation extends StatefulWidget {
  final XFile video;
  const VideoSelectLocation({
    super.key,
    required this.video,
  });

  @override
  State<VideoSelectLocation> createState() => VideoSelectLocationState();
}

class VideoSelectLocationState extends State<VideoSelectLocation> {
  bool _isWriting = false;
  final TextEditingController _textEditingController = TextEditingController();
  late double longitude;
  late double latitude;
  Map locationDict = {
    "address": [],
    "name": [],
    "distance": [],
    "latitude": [],
    "longitude": [],
    "url": [],
  };
  // List<String> addressList = [];
  // List<String> nameList = [];
  // List<int> distanceList = [];
  // List<double> latitudeList = [];
  // List<double> longitudeList = [];
  int _selectedIndex = -1;

  Future<void> getCurrentLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    // print(permission);
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      latitude = position.latitude;
      longitude = position.longitude;
    } catch (e) {
      print(e);
    }
    setState(() {});
  }

  void _onSearchChanged(String value) {
    print("Searching form $value");
  }

  Future<void> _onSearchSubmitted(String value) async {
    await getCurrentLocation();
    //initialize
    locationDict.forEach((key, value) {
      locationDict[key] = [];
    });

    final places = await searchPlaces(value, longitude, latitude);
    final documents = places['documents'];

    for (final document in documents) {
      final address = document['address_name'];
      final name = document['place_name'];
      final distance = int.parse(document['distance']);
      final lat = document['y'];
      final lon = document['x'];
      final url = document['place_url'];

      locationDict['distance'].add(distance);
      locationDict['address'].add(address);
      locationDict['name'].add(name);
      locationDict['longitude'].add(lon);
      locationDict['latitude'].add(lat);
      locationDict['url'].add(url);
      print(locationDict);
    }
    setState(() {});
  }

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

  void _onCreateTag(BuildContext context) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => VideoSelectTag(
        video: widget.video,
        address: locationDict['address'][_selectedIndex],
        name: locationDict['name'][_selectedIndex],
        lat: locationDict['latitude'][_selectedIndex],
        lon: locationDict['longitude'][_selectedIndex],
        url: locationDict['url'][_selectedIndex],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
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
          preferredSize: const Size.fromHeight(Sizes.size96 + Sizes.size16),
          child: AppBar(
            toolbarHeight: Sizes.size96,
            elevation: 0,
            centerTitle: false,
            backgroundColor: Colors.grey.shade50,
            automaticallyImplyLeading: false,
            title: Padding(
              padding: const EdgeInsets.only(
                top: Sizes.size8,
                left: Sizes.size8,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Gaps.v10,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text(
                        "지금 여기는 어디인가요?",
                        style: TextStyle(
                          fontSize: Sizes.size20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      // IconButton(
                      //   onPressed: _onClosePressed,
                      //   icon: const FaIcon(FontAwesomeIcons.xmark,
                      //       color: Colors.black),
                      // ),
                    ],
                  ),
                  Gaps.v10,
                  CupertinoSearchTextField(
                    style: const TextStyle(fontSize: Sizes.size16),
                    placeholder: "내가 있는 곳 찾기 ",
                    padding: const EdgeInsetsDirectional.fromSTEB(6, 12, 0, 12),
                    suffixMode: OverlayVisibilityMode.always,
                    prefixIcon: Icon(
                      CupertinoIcons.search,
                      size: Sizes.size28,
                      color: Theme.of(context).primaryColor,
                      // 돋보기 아이콘 두께 조정
                    ),
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.circular(0), // 검색어 입력창 모서리를 둥글게 조정
                      color: Colors.grey[200], // placeholder와 검색어 입력창의 배경 색상
                    ),
                    controller: _textEditingController,
                    onChanged: _onSearchChanged,
                    onSubmitted: _onSearchSubmitted,
                  ),
                ],
              ),
            ),
          ),
        ),
        body: GestureDetector(
          onTap: _stopWriting,
          child: Stack(
            children: [
              Scrollbar(
                controller: _scrollController,
                child: ListView.separated(
                  controller: _scrollController,
                  padding: const EdgeInsets.only(
                    bottom: Sizes.size96 + Sizes.size20,
                    left: Sizes.size20,
                    right: Sizes.size16,
                  ),
                  separatorBuilder: (context, index) => Gaps.v2,
                  itemCount: locationDict['address'].length,
                  itemBuilder: (context, index) => GestureDetector(
                    onTap: () => _onCreateTag(context),
                    onTapDown: (TapDownDetails details) => setState(() {
                      _selectedIndex = index;
                    }),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      decoration: BoxDecoration(
                          color: (_selectedIndex == index)
                              ? Colors.grey.shade200
                              : Colors.white24),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: Sizes.size8,
                          horizontal: Sizes.size6,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ConstrainedBox(
                              constraints: const BoxConstraints(
                                maxWidth: 260,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    locationDict['name'][index],
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: Sizes.size18,
                                        color: Colors.black54),
                                  ),
                                  Gaps.v3,
                                  Text(
                                    locationDict['address'][index],
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: Sizes.size16,
                                        color: Colors.black45),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              (locationDict['distance'][index] >= 1000)
                                  ? "${(locationDict['distance'][index] / 1000).toStringAsFixed(1)}km"
                                  : "${locationDict['distance'][index]}m",
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: Sizes.size14,
                                color: Theme.of(context).primaryColor,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
