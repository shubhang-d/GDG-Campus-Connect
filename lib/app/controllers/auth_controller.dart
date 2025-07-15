import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gdg_campus_connect/app/routes/app_pages.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final Rx<User?> _firebaseUser = Rx<User?>(null);
  User? get user => _firebaseUser.value;

  @override
  void onReady() {
    super.onReady();
    _firebaseUser.bindStream(_auth.authStateChanges());
    ever(_firebaseUser, _setInitialScreen);
  }

  _setInitialScreen(User? user) {
    Future.delayed(const Duration(milliseconds: 500), () {
      if (user == null) {
        Get.offAllNamed(Routes.LOGIN);
      } else {
        Get.offAllNamed(Routes.NAVIGATION);
      }
    });
  }

  void signInWithGoogle() async {
    try {
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        Get.back();
        return;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await _auth.signInWithCredential(credential);
      final User? newUser = userCredential.user;

      Get.back();

      if (newUser != null) {
        final docRef = _firestore.collection('users').doc(newUser.uid);
        final docSnapshot = await docRef.get();

        if (!docSnapshot.exists) {
          final userData = {
            'uid': newUser.uid,
            'displayName': newUser.displayName,
            'email': newUser.email,
            'photoURL': newUser.photoURL,
            'createdAt': Timestamp.now(),
            'skills': [],
            'interests': [],
            'bio': 'A new member of the GDG community!',
            'activeProjects': [],
          };
          await docRef.set(userData);
          Get.offAllNamed(Routes.EDIT_PROFILE);
        }
      }
    } catch (e) {
      Get.back();
      Get.snackbar(
        "Sign-in Failed",
        "An error occurred. Please try again.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    }
  }

  void signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }
}