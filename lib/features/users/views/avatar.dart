import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../view_models/avatar_view_model.dart';

class Avatar extends ConsumerWidget {
  final String name;
  final bool hasAvatar;
  final String uid;

  const Avatar({
    super.key,
    required this.name,
    required this.hasAvatar,
    required this.uid,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(avatarProvider).isLoading;
    return isLoading
        ? Container(
            width: 50,
            height: 50,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
            ),
            child: const CircularProgressIndicator(),
          )
        : CircleAvatar(
            radius: 50,
            foregroundImage: hasAvatar
                ? NetworkImage(
                    "https://firebasestorage.googleapis.com/v0/b/surfify.appspot.com/o/avatars%2F$uid?alt=media&haha=${DateTime.now().toString()}")
                : null,
            child: Text(name),
          );
  }
}
