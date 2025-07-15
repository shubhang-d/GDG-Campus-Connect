import 'package:get/get.dart';
import 'package:gdg_campus_connect/app/data/models/chat_channel_model.dart';
import 'package:gdg_campus_connect/app/data/providers/chat_service.dart';

class ChatChannelsController extends GetxController {
  final ChatService _chatService = Get.put(ChatService());
  final channels = <ChatChannelModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    channels.bindStream(_chatService.getChatChannelsStream());
  }
}