import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gdg_campus_connect/app/controllers/auth_controller.dart';
import 'package:gdg_campus_connect/features/chat/controllers/chat_channels_controller.dart';
import 'package:gdg_campus_connect/app/routes/app_pages.dart';
import 'package:intl/intl.dart';

class ChatChannelsView extends StatelessWidget {
  const ChatChannelsView({super.key});

  @override
  Widget build(BuildContext context) {
    final ChatChannelsController controller = Get.put(ChatChannelsController());
    final AuthController authController = Get.find();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Chats"),
      ),
      body: Obx(() {
        if (controller.channels.isEmpty) {
          return const Center(
            child: Text("No chats yet. Start a conversation!"),
          );
        }
        return ListView.builder(
          itemCount: controller.channels.length,
          itemBuilder: (context, index) {
            final channel = controller.channels[index];
            final lastMessageTime = channel.lastMessageTimestamp.toDate();
            // This is a simplified way to get the other user's name
            // A better way would be to fetch user profiles and cache them
            final otherUserId = channel.members
                .firstWhere((id) => id != authController.user!.uid, orElse: () => 'User');

            return ListTile(
              leading: const CircleAvatar(child: Icon(Icons.person)),
              title: Text("Chat with ${otherUserId.substring(0,6)}..."), // Placeholder name
              subtitle: Text(
                channel.lastMessage,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: Text(DateFormat('h:mm a').format(lastMessageTime)),
              onTap: () {
                Get.toNamed(Routes.CHAT_SCREEN, arguments: channel.id);
              },
            );
          },
        );
      }),
    );
  }
}