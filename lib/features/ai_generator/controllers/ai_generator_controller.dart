import 'package:flutter/material.dart';
import 'package:gdg_campus_connect/app/data/providers/project_service.dart';
import 'package:gdg_campus_connect/features/navigation/navigation_controller.dart';
import 'package:get/get.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:gdg_campus_connect/app/data/models/project_idea_model.dart';

class AiGeneratorController extends GetxController {
  final FirebaseFunctions _functions = FirebaseFunctions.instance;
  final ProjectService _projectService = Get.find<ProjectService>();

  final keywordController = TextEditingController();
  final isLoading = false.obs;
  final ideas = <ProjectIdeaModel>[].obs;

  final isCreatingProject = false.obs;

  Future<void> createProjectFromIdea(ProjectIdeaModel idea) async {
    isCreatingProject.value = true;
    try {
      final projectData = {
        'projectName': idea.projectName,
        'description': idea.proposedSolution,
        'problemStatement': idea.problemStatement,
        'requiredSkills': idea.keyFeatures,
        'status': 'Recruiting',
        'repoLink': '',
      };

      await _projectService.createProject(projectData);

      Get.snackbar(
        "Success!",
        "'${idea.projectName}' has been created.",
        snackPosition: SnackPosition.BOTTOM,
      );

      Get.find<MainNavigationController>().changePage(1);

    } catch (e) {
      Get.snackbar("Error", "Could not create the project. Please try again.");
    } finally {
      isCreatingProject.value = false;
    }
  }


  Future<void> generateIdeas() async {
    final keywords = keywordController.text.trim();
    if (keywords.isEmpty) {
      Get.snackbar("Input Required", "Please enter some keywords.");
      return;
    }

    isLoading.value = true;
    ideas.clear();

    try {
      final HttpsCallable callable = _functions.httpsCallable('generateProjectIdeas');
      final result = await callable.call<Map<String, dynamic>>({'keywords': keywords});

      final dynamic rawIdeasData = result.data['ideas'];

      if (rawIdeasData is List) {
        ideas.value = rawIdeasData
            .map((data) => ProjectIdeaModel.fromJson(Map<String, dynamic>.from(data)))
            .toList();
      } else {
        throw Exception("Received data is not in the expected list format.");
      }
      
    } on FirebaseFunctionsException catch (e) {
      Get.snackbar("Function Error", e.message ?? "An unknown error occurred.");
    } catch (e) {
      print("Failed to parse ideas: $e");
      Get.snackbar("Error", "Failed to process the generated ideas.");
    } finally {
      isLoading.value = false;
    }
  }
}