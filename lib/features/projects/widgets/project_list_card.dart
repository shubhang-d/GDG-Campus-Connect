import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gdg_campus_connect/app/data/models/project_model.dart';
import 'package:gdg_campus_connect/app/routes/app_pages.dart';

class ProjectListCard extends StatelessWidget {
  final ProjectModel project;
  const ProjectListCard({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: () {
          Get.toNamed(Routes.PROJECT_DETAIL, arguments: project.id);
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(project.projectName, style: Get.textTheme.titleLarge),
              const SizedBox(height: 8),
              Text(
                project.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Get.textTheme.bodyMedium,
              ),
              const SizedBox(height: 12),
              Column(
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Wrap(
                          spacing: 8,
                          children: project.requiredSkills
                              .take(3)
                              .map((skill) => Chip(label: Text(skill)))
                              .toList(),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: project.status == 'Recruiting' ? Colors.green : Colors.blue,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(project.status, style: const TextStyle(color: Colors.white)),
                          ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}