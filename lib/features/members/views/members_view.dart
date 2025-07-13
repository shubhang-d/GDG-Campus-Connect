import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gdg_campus_connect/features/members/controllers/members_controller.dart';
import 'package:gdg_campus_connect/features/members/widgets/member_card.dart';

class MembersView extends StatelessWidget {
  const MembersView({super.key});

  @override
  Widget build(BuildContext context) {
    final MembersController controller = Get.put(MembersController());

    return Scaffold(
      appBar: AppBar(title: const Text("Members")),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            _buildSearchAndFilter(controller),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (controller.filteredUsers.isEmpty) {
                  return const Center(child: Text("No members found."));
                }
                return GridView.builder(
                  padding: const EdgeInsets.only(top: 16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 0.8,
                  ),
                  itemCount: controller.filteredUsers.length,
                  itemBuilder: (context, index) {
                    final user = controller.filteredUsers[index];
                    return MemberCard(user: user);
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchAndFilter(MembersController controller) {
    return Column(
      children: [
        const SizedBox(height: 16),
        TextField(
          onChanged: (value) => controller.searchTerm.value = value,
          decoration: const InputDecoration(
            hintText: "Search by name...",
            prefixIcon: Icon(Icons.search),
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(vertical: 8)
          ),
        ),
        const SizedBox(height: 10),
        Obx(() => DropdownButtonFormField<String>(
          hint: const Text("Filter by skill..."),
          value: controller.selectedSkillFilter.value.isEmpty
              ? null
              : controller.selectedSkillFilter.value,
          onChanged: (value) => controller.selectedSkillFilter.value = value ?? '',
          items: [
            const DropdownMenuItem<String>(value: '', child: Text("All Skills")),
            ...controller.availableSkills.map((skill) =>
                DropdownMenuItem(value: skill, child: Text(skill))),
          ],
          decoration: const InputDecoration(border: OutlineInputBorder()),
        )),
      ],
    );
  }
}