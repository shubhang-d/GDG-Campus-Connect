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
      // Map the AI idea data to the format our ProjectService expects
      final projectData = {
        'projectName': idea.projectName,
        'description': idea.proposedSolution, // Map solution to description
        'problemStatement': idea.problemStatement,
        'requiredSkills': idea.keyFeatures, // Map features to skills
        'status': 'Recruiting', // Default status
        'repoLink': '', // Default to empty
      };

      await _projectService.createProject(projectData);

      Get.snackbar(
        "Success!",
        "'${idea.projectName}' has been created.",
        snackPosition: SnackPosition.BOTTOM,
      );

      // Automatically switch to the Projects tab (index 1)
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

      // --- START OF THE FIX ---

      // 1. Safely access the 'ideas' list from the returned data.
      final dynamic rawIdeasData = result.data['ideas'];

      // 2. Perform a type-safe check to ensure it's a list.
      if (rawIdeasData is List) {
        // 3. Map over the list and perform a SAFE conversion, not a blind cast.
        // Map.from() will safely convert each item into the format we need.
        ideas.value = rawIdeasData
            .map((data) => ProjectIdeaModel.fromJson(Map<String, dynamic>.from(data)))
            .toList();
      } else {
        // If the data for 'ideas' isn't a list, something is wrong with the response.
        throw Exception("Received data is not in the expected list format.");
      }
      
      // --- END OF THE FIX ---

    } on FirebaseFunctionsException catch (e) {
      // This catches specific errors from the Cloud Function itself (e.g., permissions)
      Get.snackbar("Function Error", e.message ?? "An unknown error occurred.");
    } catch (e) {
      // This catches all other errors, including our type parsing errors.
      print("Failed to parse ideas: $e"); // Add a print statement for better debugging!
      Get.snackbar("Error", "Failed to process the generated ideas.");
    } finally {
      isLoading.value = false;
    }
  }
}