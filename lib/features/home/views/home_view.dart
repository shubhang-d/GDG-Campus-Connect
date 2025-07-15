import 'package:flutter/material.dart';
import 'package:gdg_campus_connect/app/data/providers/chat_service.dart';
import 'package:get/get.dart';
import 'package:gdg_campus_connect/app/controllers/auth_controller.dart';
import 'package:gdg_campus_connect/features/home/controllers/home_controller.dart';
import 'package:gdg_campus_connect/features/home/widgets/project_card.dart';
import 'package:intl/intl.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.put(HomeController());
    final ChatService chatService = Get.put(ChatService());
    final AuthController authController = Get.find();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Sign Out',
            onPressed: () {
              authController.signOut();
            },
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        return RefreshIndicator(
          onRefresh: () => controller.fetchAllData(),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionTitle('Announcements'),
                _buildAnnouncementsSection(controller),
                const SizedBox(height: 24),

                _buildSectionTitle('Featured Projects'),
                _buildFeaturedProjectsSection(controller),
                const SizedBox(height: 24),

                _buildSectionTitle('Upcoming Events'),
                _buildUpcomingEventsSection(controller),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text(
        title,
        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildAnnouncementsSection(HomeController controller) {
    if (controller.announcements.isEmpty) {
      return const Card(child: ListTile(title: Text("No new announcements.")));
    }
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: controller.announcements.length,
      itemBuilder: (context, index) {
        final announcement = controller.announcements[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 8.0),
          child: ListTile(
            title: Text(announcement['title'] ?? 'No Title'),
            subtitle: Text(announcement['content'] ?? 'No Content'),
            isThreeLine: true,
          ),
        );
      },
    );
  }

  Widget _buildFeaturedProjectsSection(HomeController controller) {
    if (controller.featuredProjects.isEmpty) {
      return const Card(child: ListTile(title: Text("No completed projects yet.")));
    }
    return SizedBox(
      height: 180,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: controller.featuredProjects.length,
        itemBuilder: (context, index) {
          final project = controller.featuredProjects[index];
          final skills = (project['requiredSkills'] as List<dynamic>?)
                  ?.map((e) => e.toString())
                  .toList() ??
              [];
          return ProjectCard(
            title: project['projectName'] ?? 'No Name',
            description: project['description'] ?? 'No Description',
            skills: skills,
          );
        },
      ),
    );
  }

  Widget _buildUpcomingEventsSection(HomeController controller) {
    if (controller.upcomingEvents.isEmpty) {
      return const Card(child: ListTile(title: Text("No upcoming events.")));
    }
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: controller.upcomingEvents.length,
      itemBuilder: (context, index) {
        final event = controller.upcomingEvents[index];
        final eventDate = (event['date'])?.toDate();
        final formattedDate = eventDate != null
            ? DateFormat('EEE, MMM d, yyyy').format(eventDate)
            : 'No Date';

        return Card(
          margin: const EdgeInsets.only(bottom: 8.0),
          child: ListTile(
            leading: const Icon(Icons.event),
            title: Text(event['eventName'] ?? 'No Name'),
            subtitle: Text(event['location'] ?? 'No Location'),
            trailing: Text(formattedDate),
          ),
        );
      },
    );
  }
}