import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:gdg_campus_connect/app/controllers/auth_controller.dart';
import 'package:gdg_campus_connect/app/data/models/chat_channel_model.dart';
import 'package:gdg_campus_connect/app/data/models/message_model.dart';
import 'package:gdg_campus_connect/app/routes/app_pages.dart';

class ChatService extends GetxService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final AuthController _authController = Get.find();

  Stream<List<ChatChannelModel>> getChatChannelsStream() {
    return _firestore
        .collection('chatChannels')
        .where('members', arrayContains: _authController.user!.uid)
        .orderBy('lastMessageTimestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ChatChannelModel.fromSnapshot(doc))
            .toList());
  }

  Stream<List<MessageModel>> getMessagesStream(String channelId) {
    return _firestore
        .collection('chatChannels')
        .doc(channelId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => MessageModel.fromSnapshot(doc))
            .toList());
  }

  Future<void> sendMessage(String channelId, String text) async {
    if (text.trim().isEmpty) return;

    final currentUser = _authController.user!;
    final messageData = {
      'senderId': currentUser.uid,
      'text': text.trim(),
      'timestamp': Timestamp.now(),
    };

    await _firestore
        .collection('chatChannels')
        .doc(channelId)
        .collection('messages')
        .add(messageData);
  }

  Future<void> updateChannelMetadata({
    required String channelId,
    required String lastMessage,
  }) async {
    final channelRef = _firestore.collection('chatChannels').doc(channelId);
    await channelRef.set({ 
      'lastMessage': lastMessage,
      'lastMessageTimestamp': Timestamp.now(),
      'isGroupChat': true, 
      'groupName': 'Community Chat',
    }, SetOptions(merge: true));
  }

  Future<void> createOrGetChatChannel(String peerId) async {
    final currentUserId = _authController.user!.uid;

    List<String> userIds = [currentUserId, peerId];
    userIds.sort(); 
    String channelId = userIds.join('_');

    final channelRef = _firestore.collection('chatChannels').doc(channelId);
    final docSnapshot = await channelRef.get();

    if (!docSnapshot.exists) {
      await channelRef.set({
        'isGroupChat': false,
        'members': userIds,
        'lastMessage': 'Chat created!',
        'lastMessageTimestamp': Timestamp.now(),
      });
    }

    Get.toNamed(Routes.CHAT_SCREEN, arguments: channelId);
  }
}