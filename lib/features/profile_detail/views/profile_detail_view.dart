import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gdg_campus_connect/features/profile_detail/controllers/profile_detail_controller.dart';

class ProfileDetailView extends StatelessWidget {
  const ProfileDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final ProfileDetailController controller = Get.put(ProfileDetailController());
    return Scaffold(
      appBar: AppBar(title: const Text("Member Profile")),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.user.value == null) {
          return const Center(child: Text("User not found."));
        }
        final user = controller.user.value!;
        return SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Column(
                  children: [
                    CircleAvatar(radius: 50, backgroundImage: NetworkImage(user.photoURL)),
                    const SizedBox(height: 16),
                    Text(user.displayName, style: Get.textTheme.headlineSmall),
                    const SizedBox(height: 8),
                    ElevatedButton.icon(
                      onPressed: controller.startChat,
                      icon: const Icon(Icons.chat_bubble_outline),
                      label: const Text("Start Chat"),
                    ),
                  ],
                ),
              ),
              const Divider(height: 48),
              _buildSection("Bio", user.bio),
              _buildChipSection("Skills", user.skills),
              _buildChipSection("Interests", user.interests),
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
        Text(title, style: Get.textTheme.titleLarge),
        const SizedBox(height: 8),
        Text(content),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildChipSection(String title, List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Get.textTheme.titleLarge),
        const SizedBox(height: 8),
        if (items.isEmpty) const Text("Not specified"),
        if (items.isNotEmpty) Wrap(
          spacing: 8,
          children: items.map((item) => Chip(label: Text(item))).toList(),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}