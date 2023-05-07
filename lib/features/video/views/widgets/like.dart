import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:surfify/features/video/views/widgets/video_button.dart';

import '../../view_models/video_post_view_model.dart';

class Like extends ConsumerStatefulWidget {
  final bool originallyLiked;
  final int number;
  final String videoId;

  const Like({
    super.key,
    required this.originallyLiked,
    required this.number,
    required this.videoId,
  });

  @override
  createState() => _LikeState();
}

class _LikeState extends ConsumerState<Like> {
  var tapped = false;
  @override
  Widget build(BuildContext context) {
    final videoId = widget.videoId;
    final number = widget.number;
    final originallyLiked = widget.originallyLiked;

    return originallyLiked
        ? GestureDetector(
            onTap: () {
              ref.watch(videoPostProvider(videoId).notifier).toggleLikeVideo();
              setState(() {
                tapped = !tapped;
              });
            },
            child: VideoButton(
              icon: Icons.favorite,
              text: tapped ? '${number - 1}' : '$number',
              color: (!tapped) ? Colors.redAccent.shade400 : Colors.white,
            ))
        : GestureDetector(
            onTap: () {
              ref.watch(videoPostProvider(videoId).notifier).toggleLikeVideo();
              setState(() {
                tapped = !tapped;
              });
            },
            child: VideoButton(
              icon: Icons.favorite,
              text: tapped ? '${number + 1}' : '$number',
              color: (tapped) ? Colors.redAccent.shade400 : Colors.white,
            ));
  }
}
