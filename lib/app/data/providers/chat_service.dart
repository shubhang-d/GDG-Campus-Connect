import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:gdg_campus_connect/app/controllers/auth_controller.dart';
import 'package:gdg_campus_connect/app/data/models/chat_channel_model.dart';
import 'package:gdg_campus_connect/app/data/models/message_model.dart';
import 'package:gdg_campus_connect/app/routes/app_pages.dart';

class ChatService extends GetxService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final AuthController _authController = Get.find();

  // Get a stream of all chat channels for the current user
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

  // Get a stream of messages for a specific chat channel
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

  // Send a message in a specific chat channel
  Future<void> sendMessage(String channelId, String text) async {
    if (text.trim().isEmpty) return;

    final currentUser = _authController.user!;
    final messageData = {
      'senderId': currentUser.uid,
      'text': text.trim(),
      'timestamp': Timestamp.now(),
    };

    // Directly add the new message. This is a simple, non-transactional write.
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
    await channelRef.set({ // Use set with merge:true to create if not exists
      'lastMessage': lastMessage,
      'lastMessageTimestamp': Timestamp.now(),
      'isGroupChat': true, // Mark it as a group chat
      'groupName': 'Community Chat',
    }, SetOptions(merge: true));
  }

  // Create or get a 1-on-1 chat channel and navigate to it
  Future<void> createOrGetChatChannel(String peerId) async {
    final currentUserId = _authController.user!.uid;

    // Create a predictable channel ID for 1-on-1 chats
    List<String> userIds = [currentUserId, peerId];
    userIds.sort(); // Sort to ensure the ID is always the same
    String channelId = userIds.join('_');

    final channelRef = _firestore.collection('chatChannels').doc(channelId);
    final docSnapshot = await channelRef.get();

    if (!docSnapshot.exists) {
      // Create the channel if it doesn't exist
      await channelRef.set({
        'isGroupChat': false,
        'members': userIds,
        'lastMessage': 'Chat created!',
        'lastMessageTimestamp': Timestamp.now(),
      });
    }

    // Navigate to the chat screen
    Get.toNamed(Routes.CHAT_SCREEN, arguments: channelId);
  }
}