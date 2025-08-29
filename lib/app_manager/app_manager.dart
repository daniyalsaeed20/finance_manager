import 'dart:math';
import 'package:flutter/foundation.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/user_model.dart';

class AppManager {
  AppManager._privateConstructor() {
    _initializeAuthListener();
  }

  static final AppManager _instance = AppManager._privateConstructor();
  static AppManager get instance => _instance;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  UserModel? currentUser;
  bool get isLoggedIn => currentUser != null;

  void clearSession() {
    currentUser = null;
  }

  void _initializeAuthListener() {
    _auth.authStateChanges().listen((User? firebaseUser) async {
      if (firebaseUser != null) {
        // Fetch user data from Firestore
        await _fetchUserData(firebaseUser.uid);
      } else {
        // User is signed out
        clearSession();
      }
    });
  }

  Future<void> _fetchUserData(String uid, {int attempt = 0}) async {
    const maxAttempts = 3;
    const retryDelayMs = 500;

    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        currentUser = UserModel.fromDocument(doc);
        debugPrint('User data loaded for UID: $uid');
      } else if (attempt < maxAttempts) {
        debugPrint(
          'User data not yet available, retrying... attempt: ${attempt + 1}',
        );
        await Future.delayed(
          Duration(milliseconds: retryDelayMs * (attempt + 1)),
        );
        await _fetchUserData(uid, attempt: attempt + 1);
      } else {
        debugPrint(
          'User data not found after $maxAttempts attempts for UID: $uid',
        );
        clearSession();
      }
    } catch (e) {
      debugPrint('Failed to fetch user data: $e');
      clearSession();
    }
  }

  Future<void> setCurrentUser(UserModel updatedUser) async {
    try {
      final docRef = _firestore.collection('users').doc(updatedUser.id);
      await docRef.update(updatedUser.toMap());
      currentUser = updatedUser;
      debugPrint('User updated in Firestore and AppManager.');
    } catch (e) {
      debugPrint('Failed to update user: $e');
      rethrow;
    }
  }
}

Future<void> populateDummyPosts() async {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final random = Random();

  for (int i = 0; i < 20; i++) {
    final String postId = firestore.collection('posts').doc().id;

    final postData = {
      'username': 'User $i',
      'userHandle': 'user_$i',
      'userImageUrl': '',
      'description': 'This is a dummy description for post number $i.',
      'audioUrl': 'https://example.com/audio$i.mp3',
      'timestamp': Timestamp.now(),
      'likeCount': random.nextInt(200),
      'commentCount': random.nextInt(10) + 1, // At least 1 comment
      'shareCount': random.nextInt(50),
    };

    await firestore.collection('posts').doc(postId).set(postData);

    final int commentCount = postData['commentCount'] as int;

    for (int j = 0; j < commentCount; j++) {
      final commentData = {
        'username': 'Commenter $j',
        'userHandle': 'commenter_$j',
        'userImageUrl': '',
        'text': 'This is a dummy comment number $j on post $i.',
        'timestamp': Timestamp.now(),
      };

      await firestore
          .collection('posts')
          .doc(postId)
          .collection('comments')
          .add(commentData);
    }

    debugPrint('Post $i with $commentCount comments added.');
  }

  debugPrint('Dummy data population completed.');
}
