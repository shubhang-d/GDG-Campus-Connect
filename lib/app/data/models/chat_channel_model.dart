import 'package:cloud_firestore/cloud_firestore.dart';

class ChatChannelModel {
  final String id;
  final List<String> members;
  final String lastMessage;
  final Timestamp lastMessageTimestamp;
  final bool isGroupChat;
  final String? groupName;

  ChatChannelModel({
    required this.id,
    required this.members,
    required this.lastMessage,
    required this.lastMessageTimestamp,
    this.isGroupChat = false,
    this.groupName,
  });

  factory ChatChannelModel.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return ChatChannelModel(
      id: snapshot.id,
      members: List<String>.from(data['members'] ?? []),
      lastMessage: data['lastMessage'] ?? '',
      lastMessageTimestamp: data['lastMessageTimestamp'] ?? Timestamp.now(),
      isGroupChat: data['isGroupChat'] ?? false,
      groupName: data['groupName'],
    );
  }
}