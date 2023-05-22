import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:surfify/constants/gaps.dart';
import 'package:surfify/features/video/views/widgets/video_compass_overview.dart';
import 'package:surfify/features/video/views/widgets/video_post.dart';

import '../../../../constants/sizes.dart';
import '../../../../normalize/distance.dart';
import '../../view_models/place_view_model.dart';

class Overview extends StatelessWidget {
  const Overview({
    super.key,
    required this.ref,
    required this.data,
  });

  final WidgetRef ref;
  final List<dynamic> data;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor.withOpacity(1),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                Theme.of(context).primaryColor,
                const Color.fromARGB(255, 168, 222, 229),
                // const Color.fromARGB(255, 180, 224, 216),
              ],
            )),
          ),
          if (data.isEmpty)
            Container(
              alignment: Alignment.center,
              child: const Text(
                '이 방향으로는 서핑포인트가 없어요',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: Sizes.size24,
                ),
              ),
            ),
          Column(
            children: [
              Expanded(
                child: ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ref.watch(placeProvider(data[index])).when(
                            loading: () => const Center(
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            ),
                            error: (error, stackTrace) => Center(
                              child: Text(
                                'Could not load videos: $error',
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                            data: (pics) {
                              return Column(
                                children: [
                                  Text(
                                    pics[0].location,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    distance(
                                      pics[0].longitude,
                                      pics[0].latitude,
                                      126.95236219241595,
                                      37.458938402839834,
                                    ),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Gaps.v5,
                                  CarouselSlider(
                                    options: CarouselOptions(
                                      aspectRatio: 16 / 9,
                                      enlargeCenterPage:
                                          true, // 가운데 이미지 크게 보여주기
                                      enableInfiniteScroll:
                                          false, // 무한 스크롤 비활성화
                                      viewportFraction: 0.42,
                                      autoPlay: true,
                                    ),
                                    items: [
                                      for (var pic in pics)
                                        GestureDetector(
                                          onTap: () async {
                                            await showModalBottomSheet(
                                              context: context,
                                              isScrollControlled: true,
                                              backgroundColor:
                                                  Colors.transparent,
                                              builder: (context) => Container(
                                                height: size.height * 0.9,
                                                clipBehavior: Clip.hardEdge,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          Sizes.size24),
                                                ),
                                                child: VideoPost(
                                                  videoData: pic,
                                                  onVideoFinished: () {},
                                                  index: 0,
                                                  radar: false,
                                                  now: false,
                                                  luckyMode: false,
                                                ),
                                              ),
                                            );
                                          },
                                          child: Container(
                                            width: 150,
                                            height: 150 * (16 / 9),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              border: Border.all(
                                                color: Colors.white54,
                                                width: 2,
                                              ),
                                            ),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              child: FadeInImage.assetNetwork(
                                                fit: BoxFit.cover,
                                                placeholder:
                                                    "assets/images/App_Icon.png",
                                                image: pic.thumbnailUrl,
                                              ),
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                  Gaps.v8,
                                ],
                              );
                            },
                          );
                    }),
              ),
            ],
          ),
          const Positioned(
            top: 50,
            right: 20,
            child: VideoCompassOverView(
              latitude: 37.458938402839834,
              longitude: 126.95236219241595,
            ),
          ),
        ],
      ),
    );
  }
}
