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
    
    // Get the token and save it to Firestore
    final fcmToken = await _fcm.getToken();
    if (fcmToken != null) {
      await saveTokenToDatabase(fcmToken);
      // Listen for token refreshes and save the new one
      _fcm.onTokenRefresh.listen(saveTokenToDatabase);
    }
    
    // Subscribe the user to the 'global_chat' topic for global notifications
    await _fcm.subscribeToTopic('global_chat');
    
    // Subscribe the user to a personal topic to allow us to EXCLUDE them from notifications
    if (_authController.user != null) {
      await _fcm.subscribeToTopic('user_${_authController.user!.uid}');
    }

    // Handle what happens when a notification is tapped
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
    // Handles messages that are tapped when the app is terminated
    RemoteMessage? initialMessage = await _fcm.getInitialMessage();
    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }

    // Handles messages that are tapped when the app is in the background
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  }

  void _handleMessage(RemoteMessage message) {
    final type = message.data['type'];
    if (type == 'chat') {
      final channelId = message.data['channelId'];
      if (channelId != null) {
        if(channelId == 'global_chat') {
          // --- THIS IS THE CORRECTED NAVIGATION ---
          // Navigate to the main navigation screen, and pass '2' as an argument.
          // This tells the screen to open on the Chat tab (index 2).
          Get.toNamed(Routes.NAVIGATION, arguments: 2);
        } else {
          // One-on-one chat navigation is already correct.
          Get.toNamed(Routes.CHAT_SCREEN, arguments: channelId);
        }
      }
    }
  }
}