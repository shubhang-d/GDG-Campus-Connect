import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gdg_campus_connect/app/data/models/message_model.dart';
import 'package:gdg_campus_connect/app/data/providers/chat_service.dart';

class GlobalChatController extends GetxController {
  static const String globalChannelId = "global_chat";

  final ChatService _chatService = Get.find<ChatService>();
  final messages = <MessageModel>[].obs;
  final textController = TextEditingController();
  final isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    messages.bindStream(_chatService.getMessagesStream(globalChannelId));
    messages.listen((_) => isLoading.value = false);
  }

  void sendMessage() {
    final messageText = textController.text.trim();
    if (messageText.isEmpty) return;

    _chatService.sendMessage(globalChannelId, messageText);

    _chatService.updateChannelMetadata(
      channelId: globalChannelId,
      lastMessage: messageText,
    );
    
    textController.clear();
  }
}