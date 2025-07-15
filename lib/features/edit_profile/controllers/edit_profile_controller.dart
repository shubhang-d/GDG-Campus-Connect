import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gdg_campus_connect/app/controllers/auth_controller.dart';
import 'package:gdg_campus_connect/app/data/models/user_model.dart';
import 'package:gdg_campus_connect/app/routes/app_pages.dart';

class EditProfileController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final AuthController _authController = Get.find();

  final isLoading = true.obs;
  final isSaving = false.obs;

  late TextEditingController bioController;
  late TextEditingController skillController;
  late TextEditingController interestController;

  final skills = <String>[].obs;
  final interests = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    bioController = TextEditingController();
    skillController = TextEditingController();
    interestController = TextEditingController();
    loadUserData();
  }

  Future<void> loadUserData() async {
    try {
      isLoading.value = true;
      final doc = await _firestore.collection('users').doc(_authController.user!.uid).get();
      if (doc.exists) {
        final user = UserModel.fromSnapshot(doc);
        bioController.text = user.bio;
        skills.assignAll(user.skills);
        interests.assignAll(user.interests);
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to load your profile data.");
    } finally {
      isLoading.value = false;
    }
  }

  void addSkill() {
    final skill = skillController.text.trim();
    if (skill.isNotEmpty && !skills.contains(skill)) {
      skills.add(skill);
      skillController.clear();
    }
  }

  void removeSkill(String skill) {
    skills.remove(skill);
  }

  void addInterest() {
    final interest = interestController.text.trim();
    if (interest.isNotEmpty && !interests.contains(interest)) {
      interests.add(interest);
      interestController.clear();
    }
  }

  void removeInterest(String interest) {
    interests.remove(interest);
  }

  Future<void> saveProfile() async {
    try {
      isSaving.value = true;
      final userRef = _firestore.collection('users').doc(_authController.user!.uid);

      await userRef.update({
        'bio': bioController.text.trim(),
        'skills': skills.toList(),
        'interests': interests.toList(),
      });

      Get.snackbar("Success", "Your profile has been updated!");
      Get.offAllNamed(Routes.HOME);

    } catch (e) {
      Get.snackbar("Error", "Failed to save profile. Please try again.");
    } finally {
      isSaving.value = false;
    }
  }

  @override
  void onClose() {
    bioController.dispose();
    skillController.dispose();
    interestController.dispose();
    super.onClose();
  }
}