class UserRepository {}

final userRepo = Provider(
  (ref) => UserRepository(),
);
