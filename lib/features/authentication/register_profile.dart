import 'package:flutter/material.dart';

class RegisterProfile extends StatefulWidget {
  const RegisterProfile({super.key});

  @override
  State<RegisterProfile> createState() => _RegisterProfileState();
}

class _RegisterProfileState extends State<RegisterProfile> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(child: Text('프로필 등록')),
    );
  }
}
