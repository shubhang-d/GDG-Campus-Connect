import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gdg_campus_connect/app/controllers/auth_controller.dart';
import 'package:gdg_campus_connect/app/routes/app_pages.dart';

class NotificationService extends GetxService {
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  final AuthController _authController = Get.find();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> initNotifications() async {
    await _fcm.requestPermission();
    
    final fcmToken = await _fcm.getToken();
    if (fcmToken != null) {
      await saveTokenToDatabase(fcmToken);
      _fcm.onTokenRefresh.listen(saveTokenToDatabase);
    }
    
    await _fcm.subscribeToTopic('global_chat');
    
    if (_authController.user != null) {
      await _fcm.subscribeToTopic('user_${_authController.user!.uid}');
    }

    _setupInteractedMessage();
  }

  Future<void> saveTokenToDatabase(String token) async {
    if (_authController.user == null) return;
    
    final userId = _authController.user!.uid;
    final userRef = _firestore.collection('users').doc(userId);

    await userRef.update({
      'fcmTokens': FieldValue.arrayUnion([token])
    });
  }

  Future<void> _setupInteractedMessage() async {
    RemoteMessage? initialMessage = await _fcm.getInitialMessage();
    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }

    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  }

  void _handleMessage(RemoteMessage message) {
    final type = message.data['type'];
    if (type == 'chat') {
      final channelId = message.data['channelId'];
      if (channelId != null) {
        if(channelId == 'global_chat') {
          Get.toNamed(Routes.NAVIGATION, arguments: 2);
        } else {
          Get.toNamed(Routes.CHAT_SCREEN, arguments: channelId);
        }
      }
    }
  }
}