import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gdg_campus_connect/app/data/models/message_model.dart';
import 'package:gdg_campus_connect/app/data/providers/chat_service.dart';

class ChatScreenController extends GetxController {
  final ChatService _chatService = Get.find();
  final String channelId = Get.arguments;

  final messages = <MessageModel>[].obs;
  final textController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    messages.bindStream(_chatService.getMessagesStream(channelId));
  }

  void sendMessage() {
    final messageText = textController.text.trim();
    if (messageText.isEmpty) return;

    _chatService.sendMessage(channelId, messageText);
    
    _chatService.updateChannelMetadata(
      channelId: channelId,
      lastMessage: messageText,
    );
    
    textController.clear();
  }
}