import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gdg_campus_connect/app/routes/app_pages.dart';
import 'package:gdg_campus_connect/features/projects/controllers/projects_controller.dart';
import 'package:gdg_campus_connect/features/projects/widgets/project_list_card.dart';

class ProjectsView extends StatelessWidget {
  const ProjectsView({super.key});

  @override
  Widget build(BuildContext context) {
    final ProjectsController controller = Get.put(ProjectsController());

    return Scaffold(
      appBar: AppBar(
        title: const Text("Projects"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onChanged: controller.onSearchChanged,
              decoration: const InputDecoration(
                hintText: "Search by project name...",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }
              if (controller.filteredProjects.isEmpty) {
                return const Center(child: Text("No projects found."));
              }
              return ListView.builder(
                itemCount: controller.filteredProjects.length,
                itemBuilder: (context, index) {
                  final project = controller.filteredProjects[index];
                  return ProjectListCard(project: project);
                },
              );
            }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.toNamed(Routes.CREATE_PROJECT),
        child: const Icon(Icons.add),
        tooltip: "Create Project",
      ),
    );
  }
}