import 'package:get/get.dart';
import 'package:gdg_campus_connect/app/data/models/project_model.dart';
import 'package:gdg_campus_connect/app/data/providers/project_service.dart';

class ProjectsController extends GetxController {
  final ProjectService _projectService = Get.put(ProjectService());

  final _projects = <ProjectModel>[].obs;
  final isLoading = true.obs;
  final searchTerm = ''.obs;

  List<ProjectModel> get filteredProjects {
    if (searchTerm.value.isEmpty) {
      return _projects;
    }
    return _projects
        .where((p) => p.projectName
            .toLowerCase()
            .contains(searchTerm.value.toLowerCase()))
        .toList();
  }

  @override
  void onInit() {
    super.onInit();
    _projects.bindStream(_projectService.getProjectsStream());
    debounce(searchTerm, (_) => update(), time: const Duration(milliseconds: 400));
    _projects.listen((_) => isLoading.value = false);
  }

  void onSearchChanged(String value) {
    searchTerm.value = value;
  }
}