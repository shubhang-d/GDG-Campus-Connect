import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gdg_campus_connect/app/controllers/auth_controller.dart';
import 'package:gdg_campus_connect/features/chat/widgets/message_bubble.dart'; // We can reuse the same bubble!
import 'package:gdg_campus_connect/features/global_chat/controllers/global_chat_controller.dart';

class GlobalChatView extends StatelessWidget {
  const GlobalChatView({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalChatController controller = Get.put(GlobalChatController());
    final AuthController authController = Get.find();

    return Scaffold(
      appBar: AppBar(title: const Text("Community Chat"), centerTitle: true),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }
              if (controller.messages.isEmpty) {
                return const Center(
                  child: Text("Welcome! Be the first to say something."),
                );
              }
              return ListView.builder(
                reverse: true,
                padding: const EdgeInsets.all(10),
                itemCount: controller.messages.length,
                itemBuilder: (context, index) {
                  final message = controller.messages[index];
                  // We can re-use the MessageBubble widget perfectly.
                  return MessageBubble(
                    text: message.text,
                    senderId: message.senderId, // Pass the senderId
                    isMe: message.senderId == authController.user!.uid,
                  );
                },
              );
            }),
          ),
          _buildMessageInput(controller),
        ],
      ),
    );
  }

  Widget _buildMessageInput(GlobalChatController controller) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller.textController,
              decoration: InputDecoration(
                hintText: "Type a message to the community...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              onSubmitted: (_) => controller.sendMessage(),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: controller.sendMessage,
          ),
        ],
      ),
    );
  }
}
