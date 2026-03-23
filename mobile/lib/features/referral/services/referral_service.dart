import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/models/member_model.dart';

// ═══════════════════════════════════════════════════════
// Referral Service Provider
// ═══════════════════════════════════════════════════════
final referralServiceProvider = Provider<ReferralService>((ref) {
  return ReferralService();
});

// Referrals for current member
final myReferralsProvider =
    StreamProvider.family<List<MemberModel>, String>((ref, uid) {
  return ref.watch(referralServiceProvider).getMyReferrals(uid);
});

// Referral stats for current member
final myReferralStatsProvider =
    FutureProvider.family<Map<String, dynamic>, String>((ref, uid) {
  return ref.watch(referralServiceProvider).getReferralStats(uid);
});

// All referrals for admin
final allReferralsProvider =
    StreamProvider<List<Map<String, dynamic>>>((ref) {
  return ref.watch(referralServiceProvider).getAllReferralsForAdmin();
});

// ═══════════════════════════════════════════════════════
// Referral Service
// ═══════════════════════════════════════════════════════
class ReferralService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  CollectionReference get _membersRef => _firestore.collection('members');

  // ── Get Member's Referral Code ──────────────
  Future<String?> getReferralCode(String uid) async {
    final doc = await _membersRef.doc(uid).get();
    if (!doc.exists) return null;
    return (doc.data() as Map<String, dynamic>)['referralCode'];
  }

  // ── Get Members Invited by Me ───────────────
  Stream<List<MemberModel>> getMyReferrals(String uid) {
    return _membersRef
        .where('invitedBy', isEqualTo: uid)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => MemberModel.fromFirestore(doc))
          .toList();
    });
  }

  // ── Get Referral Stats for a Member ─────────
  Future<Map<String, dynamic>> getReferralStats(String uid) async {
    final referralSnapshot = await _membersRef
        .where('invitedBy', isEqualTo: uid)
        .get();

    final referrals = referralSnapshot.docs;
    final activeCount = referrals.where((d) {
      final status = (d.data() as Map)['status'];
      return status == 'active' || status == 'vip';
    }).length;

    // Get my referral code
    final myDoc = await _membersRef.doc(uid).get();
    final referralCode = myDoc.exists
        ? (myDoc.data() as Map<String, dynamic>)['referralCode'] ?? ''
        : '';

    return {
      'referralCode': referralCode,
      'totalInvited': referrals.length,
      'activeInvited': activeCount,
      'referralLink': 'https://vcmem.com/investors-club/?ref=$referralCode',
    };
  }

  // ── Validate Referral Code ──────────────────
  Future<bool> isValidReferralCode(String code) async {
    final query = await _membersRef
        .where('referralCode', isEqualTo: code.toUpperCase())
        .limit(1)
        .get();
    return query.docs.isNotEmpty;
  }

  // ── Get Referrer Info ───────────────────────
  Future<MemberModel?> getReferrerByCode(String code) async {
    final query = await _membersRef
        .where('referralCode', isEqualTo: code.toUpperCase())
        .limit(1)
        .get();
    if (query.docs.isEmpty) return null;
    return MemberModel.fromFirestore(query.docs.first);
  }

  // ── Admin: Get All Referrals Summary ────────
  Stream<List<Map<String, dynamic>>> getAllReferralsForAdmin() {
    return _membersRef
        .where('invitedBy', isNull: false)
        .snapshots()
        .asyncMap((snapshot) async {
      // Group by inviter
      final Map<String, List<MemberModel>> grouped = {};

      for (final doc in snapshot.docs) {
        final member = MemberModel.fromFirestore(doc);
        final inviterId = member.invitedBy;
        if (inviterId != null && inviterId.isNotEmpty) {
          grouped.putIfAbsent(inviterId, () => []);
          grouped[inviterId]!.add(member);
        }
      }

      // Build result with inviter names
      final result = <Map<String, dynamic>>[];
      for (final entry in grouped.entries) {
        final inviterDoc = await _membersRef.doc(entry.key).get();
        final inviterName = inviterDoc.exists
            ? (inviterDoc.data() as Map)['fullName'] ?? 'غير معروف'
            : 'عضو محذوف';
        final inviterCode = inviterDoc.exists
            ? (inviterDoc.data() as Map)['referralCode'] ?? ''
            : '';

        result.add({
          'inviterUid': entry.key,
          'inviterName': inviterName,
          'inviterCode': inviterCode,
          'count': entry.value.length,
          'members': entry.value
              .map((m) => {
                    'name': m.fullName,
                    'date': m.createdAt.toString().substring(0, 10),
                    'status': m.status,
                  })
              .toList(),
        });
      }

      // Sort by count descending
      result.sort((a, b) =>
          (b['count'] as int).compareTo(a['count'] as int));

      return result;
    });
  }

  // ── Admin: Export Referrals Data ─────────────
  Future<List<List<String>>> exportReferralsCSV() async {
    final snapshot = await _membersRef
        .where('invitedBy', isNull: false)
        .get();

    final rows = <List<String>>[
      ['اسم المدعو', 'البريد', 'الجوال', 'المدينة', 'الحالة', 'مدعو بواسطة', 'تاريخ الانضمام'],
    ];

    for (final doc in snapshot.docs) {
      final data = doc.data() as Map<String, dynamic>;
      final inviterId = data['invitedBy'] as String?;

      String inviterName = '-';
      if (inviterId != null) {
        final inviterDoc = await _membersRef.doc(inviterId).get();
        if (inviterDoc.exists) {
          inviterName =
              (inviterDoc.data() as Map)['fullName'] ?? '-';
        }
      }

      rows.add([
        data['fullName'] ?? '',
        data['email'] ?? '',
        data['phone'] ?? '',
        data['city'] ?? '',
        data['status'] ?? '',
        inviterName,
        (data['createdAt'] as Timestamp?)
                ?.toDate()
                .toString()
                .substring(0, 10) ??
            '',
      ]);
    }

    return rows;
  }
}
