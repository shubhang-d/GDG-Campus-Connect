import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gdg_campus_connect/features/edit_profile/controllers/edit_profile_controller.dart';

class EditProfileView extends StatelessWidget {
  const EditProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final EditProfileController controller = Get.put(EditProfileController());

    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Your Profile"),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        return Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildBioSection(controller),
                  const SizedBox(height: 24),
                  _buildEditableChipList(
                    "Your Skills",
                    controller.skills,
                    controller.skillController,
                    controller.addSkill,
                    controller.removeSkill,
                  ),
                  const SizedBox(height: 24),
                  _buildEditableChipList(
                    "Your Interests",
                    controller.interests,
                    controller.interestController,
                    controller.addInterest,
                    controller.removeInterest,
                  ),
                  const SizedBox(height: 80), // Space for the save button
                ],
              ),
            ),
            _buildSaveButton(controller),
          ],
        );
      }),
    );
  }

  Widget _buildBioSection(EditProfileController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Your Bio", style: Get.textTheme.titleLarge),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller.bioController,
          maxLines: 4,
          decoration: const InputDecoration(
            hintText: "Tell the community a little about yourself...",
            border: OutlineInputBorder(),
          ),
        ),
      ],
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
        const SizedBox(height: 8),
        // Display the chips
        Obx(() => Wrap(
              spacing: 8.0,
              runSpacing: 4.0,
              children: items.map((item) => Chip(
                    label: Text(item),
                    onDeleted: () => onRemove(item),
                  )).toList(),
            )),
        const SizedBox(height: 8),
        // Input field to add new items
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: textController,
                decoration: InputDecoration(hintText: 'Add a ${title.singularize()}...'),
                onFieldSubmitted: (_) => onAdd(),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: onAdd,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSaveButton(EditProfileController controller) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        padding: const EdgeInsets.all(20),
        width: double.infinity,
        child: Obx(() => ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              onPressed: controller.isSaving.value ? null : () => controller.saveProfile(),
              child: controller.isSaving.value
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    )
                  : const Text("Save Profile"),
            )),
      ),
    );
  }
}

// A simple extension to get the singular form of a word
extension StringExtension on String {
  String singularize() {
    if (endsWith('s')) {
      return substring(0, length - 1);
    }
    return this;
  }
}