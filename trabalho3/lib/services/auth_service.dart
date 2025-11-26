import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> registerWithEmailAndPassword(String email, String password, String nickname) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = result.user;

      await user?.updateDisplayName(nickname);
      await user?.reload();

      return _auth.currentUser;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message);
    }
  }

  Future<User?> signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message);
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
  
  Stream<User?> get user {
    return _auth.authStateChanges();
  }
}