import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String displayName;
  final String email;
  final String photoURL;
  final String bio;
  final List<String> skills;
  final List<String> interests;
  final Timestamp createdAt;

  UserModel({
    required this.uid,
    required this.displayName,
    required this.email,
    required this.photoURL,
    required this.bio,
    required this.skills,
    required this.interests,
    required this.createdAt,
  });

  factory UserModel.fromSnapshot(DocumentSnapshot snap) {
    final data = snap.data() as Map<String, dynamic>;
    return UserModel(
      uid: data['uid'],
      displayName: data['displayName'],
      email: data['email'],
      photoURL: data['photoURL'],
      bio: data['bio'] ?? '',
      skills: List<String>.from(data['skills'] ?? []),
      interests: List<String>.from(data['interests'] ?? []),
      createdAt: data['createdAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'displayName': displayName,
      'email': email,
      'photoURL': photoURL,
      'bio': bio,
      'skills': skills,
      'interests': interests,
      'createdAt': createdAt,
    };
  }
}