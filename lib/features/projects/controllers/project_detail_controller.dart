import 'package:gdg_campus_connect/app/data/providers/project_service.dart';
import 'package:get/get.dart';
import 'package:gdg_campus_connect/app/controllers/auth_controller.dart';
import 'package:gdg_campus_connect/app/data/models/project_model.dart';

class ProjectDetailController extends GetxController {
  final ProjectService _projectService = Get.find();
  final AuthController _authController = Get.find();

  final String projectId = Get.arguments;
  final Rx<ProjectModel?> project = Rx<ProjectModel?>(null);
  final isLoading = true.obs;
  final isRequesting = false.obs;

  String get userId => _authController.user!.uid;
  RxBool get isTeamMember => (project.value?.teamMembers.contains(userId) ?? false).obs;
  RxBool get hasRequested => (project.value?.pendingMembers.contains(userId) ?? false).obs;

  @override
  void onInit() {
    super.onInit();
    fetchProject();
  }

  Future<void> fetchProject() async {
    isLoading.value = true;
    project.value = await _projectService.getProjectById(projectId);
    isLoading.value = false;
  }

  Future<void> requestToJoin() async {
    isRequesting.value = true;
    try {
      await _projectService.requestToJoinProject(projectId);
      // Optimistically update the UI
      project.value?.pendingMembers.add(userId);
      project.refresh(); // Tell GetX to rebuild widgets
      Get.snackbar("Success", "Your request to join has been sent.");
    } catch (e) {
      Get.snackbar("Error", "Failed to send request.");
    } finally {
      isRequesting.value = false;
    }
  }
}