import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/models/member_model.dart';

// ═══════════════════════════════════════════════════════
// Profile Service Provider
// ═══════════════════════════════════════════════════════
final profileServiceProvider = Provider<ProfileService>((ref) {
  return ProfileService();
});

// Current member profile stream (real-time updates)
final memberProfileProvider = StreamProvider<MemberModel?>((ref) {
  final uid = FirebaseAuth.instance.currentUser?.uid;
  if (uid == null) return Stream.value(null);
  return ref.watch(profileServiceProvider).getMemberStream(uid);
});

// ═══════════════════════════════════════════════════════
// Profile Service
// ═══════════════════════════════════════════════════════
class ProfileService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  CollectionReference get _membersRef => _firestore.collection('members');

  // ── Get Current UID ─────────────────────────
  String? get currentUid => _auth.currentUser?.uid;

  // ── Get Member (one-time) ───────────────────
  Future<MemberModel?> getMember(String uid) async {
    final doc = await _membersRef.doc(uid).get();
    if (!doc.exists) return null;
    return MemberModel.fromFirestore(doc);
  }

  // ── Get Member Stream (real-time) ───────────
  Stream<MemberModel?> getMemberStream(String uid) {
    return _membersRef.doc(uid).snapshots().map((doc) {
      if (!doc.exists) return null;
      return MemberModel.fromFirestore(doc);
    });
  }

  // ── Update Profile ──────────────────────────
  Future<void> updateProfile({
    required String uid,
    String? fullName,
    String? phone,
    String? city,
    String? jobTitle,
    String? language,
  }) async {
    final updates = <String, dynamic>{
      'updatedAt': Timestamp.fromDate(DateTime.now()),
    };

    if (fullName != null) updates['fullName'] = fullName;
    if (phone != null) updates['phone'] = phone;
    if (city != null) updates['city'] = city;
    if (jobTitle != null) updates['jobTitle'] = jobTitle;
    if (language != null) updates['language'] = language;

    await _membersRef.doc(uid).update(updates);

    // Update display name in Firebase Auth if changed
    if (fullName != null) {
      await _auth.currentUser?.updateDisplayName(fullName);
    }
  }

  // ── Update Language Preference ──────────────
  Future<void> updateLanguage(String uid, String language) async {
    await _membersRef.doc(uid).update({
      'language': language,
      'updatedAt': Timestamp.fromDate(DateTime.now()),
    });
  }

  // ── Admin: Get All Members ──────────────────
  Stream<List<MemberModel>> getAllMembers() {
    return _membersRef
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => MemberModel.fromFirestore(doc))
          .toList();
    });
  }

  // ── Admin: Get Members by Status ────────────
  Stream<List<MemberModel>> getMembersByStatus(String status) {
    return _membersRef
        .where('status', isEqualTo: status)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => MemberModel.fromFirestore(doc))
          .toList();
    });
  }

  // ── Admin: Update Member Status ─────────────
  Future<void> updateMemberStatus(String uid, String newStatus) async {
    await _membersRef.doc(uid).update({
      'status': newStatus,
      'updatedAt': Timestamp.fromDate(DateTime.now()),
    });
  }

  // ── Admin: Reset Member Password ────────────
  Future<void> resetMemberPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  // ── Admin: Get Members Count ────────────────
  Future<Map<String, int>> getMembersCounts() async {
    final snapshot = await _membersRef.get();
    final members = snapshot.docs;
    return {
      'total': members.length,
      'active': members.where((d) =>
          (d.data() as Map)['status'] == 'active').length,
      'vip': members.where((d) =>
          (d.data() as Map)['status'] == 'vip').length,
      'suspended': members.where((d) =>
          (d.data() as Map)['status'] == 'suspended').length,
    };
  }

  // ── Admin: Delete Member ────────────────────
  Future<void> deleteMember(String uid) async {
    await _membersRef.doc(uid).delete();
    // Note: This doesn't delete the Firebase Auth user
    // For that you'd need Cloud Functions
  }
}
