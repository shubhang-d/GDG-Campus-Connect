import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gdg_campus_connect/features/projects/controllers/create_project_controller.dart';
import 'package:gdg_campus_connect/features/edit_profile/views/edit_profile_view.dart';

class CreateProjectView extends StatelessWidget {
  const CreateProjectView({super.key});

  @override
  Widget build(BuildContext context) {
    final CreateProjectController controller = Get.put(CreateProjectController());
    return Scaffold(
      appBar: AppBar(title: const Text("Create New Project")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: controller.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: controller.nameController,
                decoration: const InputDecoration(labelText: "Project Name"),
                validator: (v) => v!.isEmpty ? "Cannot be empty" : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: controller.descriptionController,
                decoration: const InputDecoration(labelText: "Short Description"),
                maxLines: 3,
                validator: (v) => v!.isEmpty ? "Cannot be empty" : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: controller.problemController,
                decoration: const InputDecoration(labelText: "Problem Statement"),
                maxLines: 5,
                validator: (v) => v!.isEmpty ? "Cannot be empty" : null,
              ),
              const SizedBox(height: 24),
              _buildEditableChipList(
                "Required Skills",
                controller.requiredSkills,
                controller.skillController,
                controller.addSkill,
                controller.removeSkill,
              ),
              const SizedBox(height: 24),
              Obx(() => ElevatedButton(
                    onPressed: controller.isSaving.value ? null : controller.createProject,
                    child: controller.isSaving.value
                        ? const CircularProgressIndicator()
                        : const Text("Create Project"),
                  )),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEditableChipList(
    String title,
    RxList<String> items,
    TextEditingController textController,
    VoidCallback onAdd,
    Function(String) onRemove,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Get.textTheme.titleLarge),
        Obx(() => Wrap(
              spacing: 8.0,
              children: items.map((item) => Chip(
                    label: Text(item),
                    onDeleted: () => onRemove(item),
                  )).toList(),
            )),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: textController,
                decoration: InputDecoration(hintText: 'Add a ${title.singularize()}...'),
                onFieldSubmitted: (_) => onAdd(),
              ),
            ),
            IconButton(icon: const Icon(Icons.add), onPressed: onAdd),
          ],
        ),
      ],
    );
  }
}