import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gdg_campus_connect/app/data/models/user_model.dart';
import 'package:gdg_campus_connect/app/data/providers/user_service.dart';

class MessageBubble extends StatelessWidget {
  final String text;
  final String senderId;
  final bool isMe;

  const MessageBubble({
    super.key,
    required this.text,
    required this.senderId,
    required this.isMe,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Column(
        // Align sender name based on who sent the message
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          // Show sender's name if it's not me
          if (!isMe)
            Padding(
              padding: const EdgeInsets.only(left: 16, bottom: 2),
              // Use a FutureBuilder to fetch user details on-the-fly
              child: FutureBuilder<UserModel?>(
                future: Get.find<UserService>().getUserById(senderId),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done &&
                      snapshot.hasData) {
                    return Text(
                      snapshot.data!.displayName,
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    );
                  }
                  return const SizedBox.shrink(); // Return empty space while loading
                },
              ),
            ),
          Row(
            mainAxisAlignment:
                isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
              Container(
                constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.7),
                decoration: BoxDecoration(
                  color: isMe ? Colors.blue : Colors.grey[800],
                  borderRadius: BorderRadius.circular(12),
                ),
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                margin: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(text, style: const TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}