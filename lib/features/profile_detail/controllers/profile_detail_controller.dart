import 'package:get/get.dart';
import 'package:gdg_campus_connect/app/data/models/user_model.dart';
import 'package:gdg_campus_connect/app/data/providers/chat_service.dart';
import 'package:gdg_campus_connect/app/data/providers/user_service.dart';

class ProfileDetailController extends GetxController {
  final String uid = Get.arguments;
  final UserService _userService = Get.find();
  final ChatService _chatService = Get.find();

  final Rx<UserModel?> user = Rx<UserModel?>(null);
  final isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchUserProfile();
  }

  Future<void> fetchUserProfile() async {
    isLoading.value = true;
    user.value = await _userService.getUserById(uid);
    isLoading.value = false;
  }
  
  void startChat() {
    if (user.value != null) {
      _chatService.createOrGetChatChannel(user.value!.uid);
    }
  }
}