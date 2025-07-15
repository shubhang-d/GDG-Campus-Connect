import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gdg_campus_connect/features/ai_generator/controllers/ai_generator_controller.dart';

class AiGeneratorView extends StatelessWidget {
  const AiGeneratorView({super.key});

  @override
  Widget build(BuildContext context) {
    final AiGeneratorController controller = Get.put(AiGeneratorController());

    return Scaffold(
      appBar: AppBar(title: const Text("AI Project Idea Generator")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildInputSection(controller),
            const SizedBox(height: 20),
            Expanded(child: _buildResultsSection(controller)),
          ],
        ),
      ),
    );
  }

  Widget _buildInputSection(AiGeneratorController controller) {
    return Column(
      children: [
        TextField(
          controller: controller.keywordController,
          decoration: const InputDecoration(
            labelText: "Enter Keywords",
            hintText: "e.g., health, students, data",
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 12),
        Obx(() => SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 12)),
                onPressed: controller.isLoading.value ? null : controller.generateIdeas,
                icon: const Icon(Icons.auto_awesome),
                label: Text(controller.isLoading.value ? "Generating..." : "Generate Ideas"),
              ),
            )),
      ],
    );
  }

    Widget _buildResultsSection(AiGeneratorController controller) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }
      if (controller.ideas.isEmpty) {
        return const Center(child: Text("Enter keywords above to generate project ideas."));
      }
      return ListView.builder(
        itemCount: controller.ideas.length,
        itemBuilder: (context, index) {
          final idea = controller.ideas[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: ExpansionTile(
              title: Text(idea.projectName, style: Get.textTheme.titleLarge),
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildDetail("Problem", idea.problemStatement),
                      _buildDetail("Solution", idea.proposedSolution),
                      _buildDetail("Key Features", ""),
                      ...idea.keyFeatures.map((f) => Text("• $f")).toList(),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: Obx(() => ElevatedButton.icon(
                              onPressed: controller.isCreatingProject.value
                                  ? null
                                  : () => controller.createProjectFromIdea(idea),
                              icon: controller.isCreatingProject.value
                                  ? const SizedBox(
                                      width: 18,
                                      height: 18,
                                      child: CircularProgressIndicator(strokeWidth: 2),
                                    )
                                  : const Icon(Icons.add_circle_outline),
                              label: Text(
                                controller.isCreatingProject.value
                                    ? "Creating..."
                                    : "Create this Project",
                              ),
                            )),
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
        },
      );
    });
  }

  Widget _buildDetail(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          if (content.isNotEmpty) Text(content),
        ],
      ),
    );
  }
}