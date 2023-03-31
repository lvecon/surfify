import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../authentication/repos/authentication_repo.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("프로필"),
      ),
      body: GestureDetector(
          onTap: () {
            ref.read(authRepo).signOut();
            context.go("/");
          },
          child: const Text('로그아웃')),
    );
  }
}
