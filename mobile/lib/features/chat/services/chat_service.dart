import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/models/message_model.dart';

// ═══════════════════════════════════════════════════════
// Chat Service Provider
// ═══════════════════════════════════════════════════════
final chatServiceProvider = Provider<ChatService>((ref) {
  return ChatService();
});

// Messages stream for a specific member
final memberMessagesProvider =
    StreamProvider.family<List<MessageModel>, String>((ref, memberId) {
  return ref.watch(chatServiceProvider).getMessages(memberId);
});

// Unread count for a member
final unreadCountProvider =
    StreamProvider.family<int, String>((ref, memberId) {
  return ref.watch(chatServiceProvider).getUnreadCount(memberId, 'member');
});

// All chats for admin (list of members with last message)
final allChatsProvider = StreamProvider<List<Map<String, dynamic>>>((ref) {
  return ref.watch(chatServiceProvider).getAllChatsForAdmin();
});

// ═══════════════════════════════════════════════════════
// Chat Service
// ═══════════════════════════════════════════════════════
class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference _messagesRef(String memberId) {
    return _firestore
        .collection('supportChats')
        .doc(memberId)
        .collection('messages');
  }

  // ── Get Messages (real-time) ────────────────
  Stream<List<MessageModel>> getMessages(String memberId) {
    return _messagesRef(memberId)
        .orderBy('timestamp', descending: false)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => MessageModel.fromFirestore(doc))
          .toList();
    });
  }

  // ── Send Message ────────────────────────────
  Future<void> sendMessage({
    required String memberId,
    required String senderId,
    required String senderRole,
    required String text,
  }) async {
    final now = DateTime.now();
    final messageData = {
      'senderId': senderId,
      'senderRole': senderRole,
      'text': text.trim(),
      'timestamp': Timestamp.fromDate(now),
      'isRead': false,
    };

    await _messagesRef(memberId).add(messageData);

    // Update the supportChats parent doc with last message info
    await _firestore.collection('supportChats').doc(memberId).set({
      'lastMessage': text.trim(),
      'lastMessageTime': Timestamp.fromDate(now),
      'lastSenderRole': senderRole,
      'memberId': memberId,
    }, SetOptions(merge: true));
  }

  // ── Mark Messages as Read ───────────────────
  Future<void> markAsRead({
    required String memberId,
    required String readerRole,
  }) async {
    // Mark all messages from the OTHER role as read
    final otherRole = readerRole == 'member' ? 'admin' : 'member';

    final unreadMessages = await _messagesRef(memberId)
        .where('senderRole', isEqualTo: otherRole)
        .where('isRead', isEqualTo: false)
        .get();

    final batch = _firestore.batch();
    for (final doc in unreadMessages.docs) {
      batch.update(doc.reference, {'isRead': true});
    }
    await batch.commit();
  }

  // ── Get Unread Count ────────────────────────
  Stream<int> getUnreadCount(String memberId, String readerRole) {
    final otherRole = readerRole == 'member' ? 'admin' : 'member';
    return _messagesRef(memberId)
        .where('senderRole', isEqualTo: otherRole)
        .where('isRead', isEqualTo: false)
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }

  // ── Get All Chats for Admin ─────────────────
  Stream<List<Map<String, dynamic>>> getAllChatsForAdmin() {
    return _firestore
        .collection('supportChats')
        .orderBy('lastMessageTime', descending: true)
        .snapshots()
        .asyncMap((snapshot) async {
      final chats = <Map<String, dynamic>>[];

      for (final doc in snapshot.docs) {
        final data = doc.data();
        final memberId = doc.id;

        // Get member name
        final memberDoc = await _firestore
            .collection('members')
            .doc(memberId)
            .get();
        final memberName = memberDoc.exists
            ? (memberDoc.data()?['fullName'] ?? 'عضو')
            : 'عضو محذوف';

        // Get unread count
        final unreadSnapshot = await _messagesRef(memberId)
            .where('senderRole', isEqualTo: 'member')
            .where('isRead', isEqualTo: false)
            .get();

        chats.add({
          'memberId': memberId,
          'name': memberName,
          'lastMessage': data['lastMessage'] ?? '',
          'lastMessageTime': data['lastMessageTime'],
          'unread': unreadSnapshot.docs.length,
        });
      }

      return chats;
    });
  }

  // ── Get Total Unread for Admin ──────────────
  Future<int> getTotalUnreadForAdmin() async {
    final chatsSnapshot = await _firestore.collection('supportChats').get();
    int total = 0;
    for (final chat in chatsSnapshot.docs) {
      final unread = await _messagesRef(chat.id)
          .where('senderRole', isEqualTo: 'member')
          .where('isRead', isEqualTo: false)
          .get();
      total += unread.docs.length;
    }
    return total;
  }
}
