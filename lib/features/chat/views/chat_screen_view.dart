import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gdg_campus_connect/app/controllers/auth_controller.dart';
import 'package:gdg_campus_connect/features/chat/controllers/chat_screen_controller.dart';
import 'package:gdg_campus_connect/features/chat/widgets/message_bubble.dart';

class ChatScreenView extends StatelessWidget {
  const ChatScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    final ChatScreenController controller = Get.put(ChatScreenController());
    final AuthController authController = Get.find();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Chat"),
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              if (controller.messages.isEmpty) {
                return const Center(child: Text("Say hi!"));
              }
              return ListView.builder(
                reverse: true,
                itemCount: controller.messages.length,
                itemBuilder: (context, index) {
                  final message = controller.messages[index];
                  // --- THIS IS THE CORRECTED WIDGET CALL ---
                  return MessageBubble(
                    text: message.text,
                    senderId: message.senderId, // We were missing this parameter
                    isMe: message.senderId == authController.user!.uid,
                  );
                  // ------------------------------------------
                },
              );
            }),
          ),
          _buildMessageInput(controller),
        ],
      ),
    );
  }

  Widget _buildMessageInput(ChatScreenController controller) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller.textController,
              decoration: InputDecoration(
                hintText: "Type a message...",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
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