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
    // Put the HomeController into memory
    final HomeController controller = Get.put(HomeController());
    final ChatService chatService = Get.put(ChatService());
    // Find the already existing AuthController
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
      // Obx wraps the widget and rebuilds it automatically when reactive variables change
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
                // --- ANNOUNCEMENTS SECTION ---
                _buildSectionTitle('Announcements'),
                _buildAnnouncementsSection(controller),
                const SizedBox(height: 24),

                // --- FEATURED PROJECTS SECTION ---
                _buildSectionTitle('Featured Projects'),
                _buildFeaturedProjectsSection(controller),
                const SizedBox(height: 24),

                // --- UPCOMING EVENTS SECTION ---
                _buildSectionTitle('Upcoming Events'),
                _buildUpcomingEventsSection(controller),
              ],
            ),
          ),
        );
      }),
      // floatingActionButton: FloatingActionButton(
      //   tooltip: 'Start a Test Chat',
      //   child: const Icon(Icons.message),
      //   onPressed: () {
      //     // --- THIS IS THE CORRECTED LOGIC ---
      //     // Use Get.find() here to get the ChatService instance
      //     // This ensures it's available right when we need it.
      //     final ChatService chatService = Get.find();
      //     final AuthController authController = Get.find();

      //     // IMPORTANT: Replace with a real user's UID from your Firestore 'users' collection.
      //     // You CANNOT chat with yourself.
      //     String otherUserId = "XB7APiMQRObtTpxVJz9WxpUHFZx1";
      //     final String? currentUserId = authController.user?.uid;

      //     if (currentUserId == null) {
      //       Get.snackbar("Error", "You are not logged in.");
      //       return;
      //     }

      //     if (otherUserId == "PASTE_ANOTHER_USER_UID_HERE" || otherUserId.isEmpty) {
      //       Get.snackbar(
      //         "Test Chat Setup",
      //         "Please open home_view.dart and replace the placeholder with a real User ID from another test account.",
      //         snackPosition: SnackPosition.BOTTOM,
      //         duration: const Duration(seconds: 6),
      //       );
      //       return;
      //     }
          
      //     if (otherUserId == currentUserId) {
      //       Get.snackbar("Error", "You cannot start a chat with yourself.");
      //       return;
      //     }

      //     // Now, this call will work perfectly.
      //     chatService.createOrGetChatChannel(otherUserId);
      //   },
      // ),
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
          // Safely cast the skills list
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