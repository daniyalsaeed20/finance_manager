import 'package:cloud_firestore/cloud_firestore.dart';
/*
Below is an example of a user model which needs to be adjusted according to the requirements of the app.
*/
class UserModel {
  final String id;
  final String name;
  final String handle;
  final String emailAddress;
  final String profileImageUrl;
  final DateTime createdAt;

  UserModel({
    required this.id,
    required this.name,
    required this.handle,
    required this.emailAddress,
    required this.profileImageUrl,
    required this.createdAt,
  });

  factory UserModel.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>?;
    final Timestamp? ts = data?['createdAt'] as Timestamp?;

    return UserModel(
      id: doc.id,
      name: data?['name'] ?? '',
      handle: data?['handle'] ?? '',
      emailAddress: data?['emailAddress'] ?? '',
      profileImageUrl: data?['profileImageUrl'] ?? '',
      createdAt: ts != null ? ts.toDate() : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'handle': handle,
      'emailAddress': emailAddress,
      'profileImageUrl': profileImageUrl,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  UserModel copyWith({
    String? name,
    String? handle,
    String? bio,
    String? profileImageUrl,
  }) {
    return UserModel(
      id: id,
      name: name ?? this.name,
      handle: handle ?? this.handle,
      emailAddress: emailAddress,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      createdAt: createdAt,
    );
  }
}
