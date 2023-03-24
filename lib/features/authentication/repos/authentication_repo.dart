import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthenticaitonRepository {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  bool get isLoggedIn => user != null;
  User? get user => _firebaseAuth.currentUser;

  Future<void> googleSignIn() async {
    await _firebaseAuth.signInWithProvider(GoogleAuthProvider());
  }
}

final authRepo = Provider((ref) => AuthenticaitonRepository());
