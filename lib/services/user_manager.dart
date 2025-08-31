import 'package:firebase_auth/firebase_auth.dart';

class UserManager {
  UserManager._();
  static final UserManager instance = UserManager._();

  String? _currentUserId;

  String get currentUserId {
    if (_currentUserId != null) {
      return _currentUserId!;
    }

    // Fallback to Firebase user ID or generate a temporary one
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      _currentUserId = user.uid;
      return _currentUserId!;
    }

    // For development/testing, use a default user ID
    _currentUserId = 'default_user_${DateTime.now().millisecondsSinceEpoch}';
    return _currentUserId!;
  }

  void setCurrentUserId(String userId) {
    _currentUserId = userId;
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    _currentUserId = null;
  }

  bool get isSignedIn {
    return FirebaseAuth.instance.currentUser != null;
  }

  User? get currentUser {
    return FirebaseAuth.instance.currentUser;
  }
}
