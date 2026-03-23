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
    final trimmedText = text.trim();
    if (trimmedText.isEmpty) return;

    final now = DateTime.now();
    final messageData = {
      'senderId': senderId,
      'senderRole': senderRole,
      'text': trimmedText,
      'timestamp': Timestamp.fromDate(now),
      'isRead': false,
    };

    // استخدام batch write بدل كتابتين منفصلتين
    final batch = _firestore.batch();

    final messageRef = _messagesRef(memberId).doc();
    batch.set(messageRef, messageData);

    final chatDocRef = _firestore.collection('supportChats').doc(memberId);
    batch.set(chatDocRef, {
      'lastMessage': trimmedText,
      'lastMessageTime': Timestamp.fromDate(now),
      'lastSenderRole': senderRole,
      'memberId': memberId,
    }, SetOptions(merge: true));

    await batch.commit();
  }

  // ── Mark Messages as Read ───────────────────
  Future<void> markAsRead({
    required String memberId,
    required String readerRole,
  }) async {
    final otherRole = readerRole == 'member' ? 'admin' : 'member';

    final unreadMessages = await _messagesRef(memberId)
        .where('senderRole', isEqualTo: otherRole)
        .where('isRead', isEqualTo: false)
        .get();

    if (unreadMessages.docs.isEmpty) return;

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

  // ── Get All Chats for Admin (مُحسّن) ────────
  Stream<List<Map<String, dynamic>>> getAllChatsForAdmin() {
    return _firestore
        .collection('supportChats')
        .orderBy('lastMessageTime', descending: true)
        .snapshots()
        .asyncMap((snapshot) async {
      final chats = <Map<String, dynamic>>[];

      if (snapshot.docs.isEmpty) return chats;

      // جمع كل الـ member IDs مرة واحدة
      final memberIds = snapshot.docs.map((doc) => doc.id).toList();

      // جلب بيانات كل الأعضاء في طلبات batch (كل 10 في مجموعة بسبب حد Firestore)
      final Map<String, String> memberNames = {};
      for (var i = 0; i < memberIds.length; i += 10) {
        final batchIds = memberIds.sublist(
          i,
          i + 10 > memberIds.length ? memberIds.length : i + 10,
        );
        final membersSnapshot = await _firestore
            .collection('members')
            .where(FieldPath.documentId, whereIn: batchIds)
            .get();
        for (final memberDoc in membersSnapshot.docs) {
          memberNames[memberDoc.id] =
              (memberDoc.data()['fullName'] as String?) ?? 'عضو';
        }
      }

      // جلب عدد الرسائل غير المقروءة لكل chat
      for (final doc in snapshot.docs) {
        final data = doc.data();
        final memberId = doc.id;

        final unreadSnapshot = await _messagesRef(memberId)
            .where('senderRole', isEqualTo: 'member')
            .where('isRead', isEqualTo: false)
            .get();

        chats.add({
          'memberId': memberId,
          'name': memberNames[memberId] ?? 'عضو محذوف',
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
