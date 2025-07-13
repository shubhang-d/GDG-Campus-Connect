import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gdg_campus_connect/app/data/providers/project_service.dart';

class CreateProjectController extends GetxController {
  final ProjectService _projectService = Get.find();
  final formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final problemController = TextEditingController();
  final skillController = TextEditingController();

  final requiredSkills = <String>[].obs;
  final status = 'Recruiting'.obs; // Default status
  final isSaving = false.obs;

  void addSkill() {
    final skill = skillController.text.trim();
    if (skill.isNotEmpty && !requiredSkills.contains(skill)) {
      requiredSkills.add(skill);
      skillController.clear();
    }
  }

  void removeSkill(String skill) {
    requiredSkills.remove(skill);
  }

  Future<void> createProject() async {
    if (formKey.currentState!.validate()) {
      isSaving.value = true;
      try {
        await _projectService.createProject({
          'projectName': nameController.text,
          'description': descriptionController.text,
          'problemStatement': problemController.text,
          'requiredSkills': requiredSkills.toList(),
          'status': status.value,
        });
        Get.back(); // Go back to projects list
        Get.snackbar("Success", "Project created successfully!");
      } catch (e) {
        Get.snackbar("Error", "Failed to create project.");
      } finally {
        isSaving.value = false;
      }
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    descriptionController.dispose();
    problemController.dispose();
    skillController.dispose();
    super.onClose();
  }
}