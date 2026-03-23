import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  final String messageId;
  final String senderId;
  final String senderRole;
  final String text;
  final DateTime timestamp;
  final bool isRead;

  MessageModel({
    required this.messageId,
    required this.senderId,
    required this.senderRole,
    required this.text,
    required this.timestamp,
    required this.isRead,
  });

  // ── From Firestore ────────────────────────────────
  factory MessageModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return MessageModel(
      messageId: doc.id,
      senderId: data['senderId'] ?? '',
      senderRole: data['senderRole'] ?? 'member',
      text: data['text'] ?? '',
      timestamp: (data['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
      isRead: data['isRead'] ?? false,
    );
  }

  // ── To Firestore ──────────────────────────────────
  Map<String, dynamic> toFirestore() {
    return {
      'senderId': senderId,
      'senderRole': senderRole,
      'text': text,
      'timestamp': Timestamp.fromDate(timestamp),
      'isRead': isRead,
    };
  }

  // ── Helper Getters ────────────────────────────────
  bool get isFromMember => senderRole == 'member';
  bool get isFromAdmin => senderRole == 'admin';
}
