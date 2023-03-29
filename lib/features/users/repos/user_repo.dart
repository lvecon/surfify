import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserRepository {}

final userRepo = Provider(
  (ref) => UserRepository(),
);
