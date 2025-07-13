import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:gdg_campus_connect/app/data/models/user_model.dart';

class UserService extends GetxService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Fetches a list of all users from the 'users' collection.
  Future<List<UserModel>> getAllUsers() async {
    try {
      final snapshot = await _firestore.collection('users').get();
      return snapshot.docs
          .map((doc) => UserModel.fromSnapshot(doc))
          .toList();
    } catch (e) {
      print("Error fetching all users: $e");
      return []; // Return an empty list on error
    }
  }

  // Fetches a single user by their UID.
  Future<UserModel?> getUserById(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      if(doc.exists) {
        return UserModel.fromSnapshot(doc);
      }
    } catch (e) {
       print("Error fetching user by ID: $e");
    }
    return null;
  }
}