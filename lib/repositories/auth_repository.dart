import 'package:firebase_auth/firebase_auth.dart';

class AuthRepository {
  final FirebaseAuth _firebaseAuth;
  AuthRepository({FirebaseAuth? firebaseAuth})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  User? getCurrentUser() {
    return _firebaseAuth.currentUser;
  }

  Future<User?> signIn({required String email, required String password}) async {
    UserCredential cred = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
    return cred.user;
  }

  Future<User?> signUp({required String name, required String email, required String password}) async {
    UserCredential cred = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
    User? user = cred.user;
    if (user != null) {
      // Update the user's display name
      if (name.isNotEmpty) {
        await user.updateDisplayName(name);
      }
      // Send a verification email
      await user.sendEmailVerification();
    }
    return user;
  }

  Future<void> sendPasswordReset({required String email}) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  Future<void> sendEmailVerification() async {
    User? user = _firebaseAuth.currentUser;
    if (user != null && !user.emailVerified) {
      await user.sendEmailVerification();
    }
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}
