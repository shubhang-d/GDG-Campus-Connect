import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gdg_campus_connect/app/data/models/message_model.dart';
import 'package:gdg_campus_connect/app/data/providers/chat_service.dart';

class GlobalChatController extends GetxController {
  // Hardcode the ID for our single global channel
  static const String globalChannelId = "global_chat";

  final ChatService _chatService = Get.find<ChatService>();
  final messages = <MessageModel>[].obs;
  final textController = TextEditingController();
  final isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    // Bind the stream directly to our global channel ID
    messages.bindStream(_chatService.getMessagesStream(globalChannelId));
    messages.listen((_) => isLoading.value = false);
  }

  void sendMessage() {
    final messageText = textController.text.trim();
    if (messageText.isEmpty) return;

    // 1. Send the message to the global channel subcollection
    _chatService.sendMessage(globalChannelId, messageText);

    // 2. Update the global channel's metadata (creates it if it doesn't exist)
    _chatService.updateChannelMetadata(
      channelId: globalChannelId,
      lastMessage: messageText,
    );
    
    textController.clear();
  }
}