import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gdg_campus_connect/features/projects/controllers/project_detail_controller.dart';

class ProjectDetailView extends StatelessWidget {
  const ProjectDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final ProjectDetailController controller = Get.put(ProjectDetailController());

    return Scaffold(
      appBar: AppBar(title: const Text("Project Details")),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.project.value == null) {
          return const Center(child: Text("Project not found."));
        }
        final project = controller.project.value!;
        return SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(project.projectName, style: Get.textTheme.headlineMedium),
              const SizedBox(height: 16),
              _buildStatusChip(project.status),
              const SizedBox(height: 16),
              _buildSection("Description", project.description),
              _buildSection("Problem Statement", project.problemStatement),
              _buildSectionTitle("Required Skills"),
              Wrap(spacing: 8, children: project.requiredSkills.map((s) => Chip(label: Text(s))).toList()),
              const SizedBox(height: 24),
              _buildSection("Team Members", project.teamMembers.join('\n')),
              const SizedBox(height: 32),
              Center(child: _buildJoinButton(controller)),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(title),
        Text(content, style: Get.textTheme.bodyLarge),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(title, style: Get.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold));
  }
  
  Widget _buildStatusChip(String status) {
     return Chip(
        label: Text(status),
        backgroundColor: status == 'Recruiting' ? Colors.green : Colors.blue,
        labelStyle: const TextStyle(color: Colors.white),
      );
  }

  Widget _buildJoinButton(ProjectDetailController controller) {
    return Obx(() {
      if (controller.isTeamMember.value) {
        return const ElevatedButton(onPressed: null, child: Text("You are on the team"));
      }
      if (controller.hasRequested.value) {
        return const ElevatedButton(onPressed: null, child: Text("Request Sent"));
      }
      if (controller.isRequesting.value) {
        return const ElevatedButton(onPressed: null, child: CircularProgressIndicator());
      }
      return ElevatedButton(
        onPressed: controller.requestToJoin,
        child: const Text("Request to Join"),
      );
    });
  }
}