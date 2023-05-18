import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:surfify/features/video/views/widgets/video_compass_overview.dart';

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
    return Scaffold(
      body: (data.isEmpty)
          ? const Center(
              child: Text(
                '이 방향으로는 서핑포인트가 없어요',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: Sizes.size24,
                ),
              ),
            )
          : Stack(
              children: [
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
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  data: (pics) {
                                    return Column(
                                      children: [
                                        SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: Row(
                                            children: [
                                              for (var pic in pics)
                                                FadeInImage.assetNetwork(
                                                  fit: BoxFit.cover,
                                                  placeholder:
                                                      "assets/images/App_Icon.png",
                                                  image: pic.thumbnailUrl,
                                                ),
                                            ],
                                          ),
                                        ),
                                        Text(pics[0].location),
                                        Text(distance(
                                          pics[0].longitude,
                                          pics[0].latitude,
                                          126.95236219241595,
                                          37.458938402839834,
                                        )),
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
