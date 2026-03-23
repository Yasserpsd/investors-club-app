import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/models/member_model.dart';

// ═══════════════════════════════════════════════════════
// Auth Service Provider
// ═══════════════════════════════════════════════════════
final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});

// Current Firebase user stream
final authStateProvider = StreamProvider<User?>((ref) {
  return FirebaseAuth.instance.authStateChanges();
});

// Current member document from Firestore
final currentMemberProvider = FutureProvider<MemberModel?>((ref) async {
  final authState = ref.watch(authStateProvider);
  final user = authState.valueOrNull;
  if (user == null) return null;

  final doc = await FirebaseFirestore.instance
      .collection('members')
      .doc(user.uid)
      .get();

  if (!doc.exists) return null;
  return MemberModel.fromFirestore(doc);
});

// ═══════════════════════════════════════════════════════
// Auth Service
// ═══════════════════════════════════════════════════════
class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ── Current user ────────────────────────────
  User? get currentUser => _auth.currentUser;
  String? get currentUid => _auth.currentUser?.uid;
  bool get isLoggedIn => _auth.currentUser != null;

  // ── Sign In ─────────────────────────────────
  Future<UserCredential> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      // Verify member doc exists
      final memberDoc = await _firestore
          .collection('members')
          .doc(credential.user!.uid)
          .get();

      if (!memberDoc.exists) {
        await _auth.signOut();
        throw FirebaseAuthException(
          code: 'member-not-found',
          message: 'لم يتم العثور على بيانات العضوية',
        );
      }

      // Check if member is suspended
      final data = memberDoc.data()!;
      if (data['status'] == 'suspended') {
        await _auth.signOut();
        throw FirebaseAuthException(
          code: 'account-suspended',
          message: 'تم إيقاف حسابك. تواصل مع الإدارة',
        );
      }

      return credential;
    } on FirebaseAuthException {
      rethrow;
    } on FirebaseException catch (e) {
      throw _handleFirebaseError(e);
    }
  }

  // ── Sign Up ─────────────────────────────────
  Future<UserCredential> signUp({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String phone,
    required String nationalId,
    required String city,
    required String financialCapacity,
    String? inviteCode,
    required bool agreedToTerms,
    required String language,
  }) async {
    try {
      // 1. Create Firebase Auth user
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      final uid = credential.user!.uid;

      // 2. Generate referral code
      final referralCode = _generateReferralCode(uid);

      // 3. Resolve invitedBy from invite code
      String? invitedByUid;
      if (inviteCode != null && inviteCode.isNotEmpty) {
        final inviterQuery = await _firestore
            .collection('members')
            .where('referralCode', isEqualTo: inviteCode.toUpperCase())
            .limit(1)
            .get();
        if (inviterQuery.docs.isNotEmpty) {
          invitedByUid = inviterQuery.docs.first.id;
        }
      }

      // 4. Create member document in Firestore
      final now = DateTime.now();
      final memberData = {
        'uid': uid,
        'fullName': '$firstName $lastName',
        'email': email.trim(),
        'phone': '+966$phone',
        'nationalId': nationalId,
        'city': city,
        'jobTitle': '',
        'investmentLevel': financialCapacity,
        'interests': <String>[],
        'howDidYouKnow': '',
        'role': 'member',
        'status': financialCapacity == 'high' ? 'vip' : 'active',
        'invitedBy': invitedByUid,
        'referralCode': referralCode,
        'language': language,
        'agreedToTerms': agreedToTerms,
        'createdAt': Timestamp.fromDate(now),
        'updatedAt': Timestamp.fromDate(now),
      };

      await _firestore.collection('members').doc(uid).set(memberData);

      // 5. Update display name
      await credential.user!.updateDisplayName('$firstName $lastName');

      return credential;
    } on FirebaseAuthException {
      rethrow;
    } on FirebaseException catch (e) {
      throw _handleFirebaseError(e);
    }
  }

  // ── Sign Out ────────────────────────────────
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // ── Reset Password ──────────────────────────
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
    } on FirebaseAuthException {
      rethrow;
    }
  }

  // ── Get Member Data ─────────────────────────
  Future<MemberModel?> getMemberData(String uid) async {
    final doc = await _firestore.collection('members').doc(uid).get();
    if (!doc.exists) return null;
    return MemberModel.fromFirestore(doc);
  }

  // ── Check if Admin ──────────────────────────
  Future<bool> isAdmin() async {
    final uid = currentUid;
    if (uid == null) return false;
    final doc = await _firestore.collection('members').doc(uid).get();
    if (!doc.exists) return false;
    return doc.data()?['role'] == 'admin';
  }

  // ── Helpers ─────────────────────────────────
  String _generateReferralCode(String uid) {
    final chars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
    final hash = uid.hashCode.abs();
    final buffer = StringBuffer('INV-');
    for (int i = 0; i < 5; i++) {
      buffer.write(chars[(hash + i * 7) % chars.length]);
    }
    return buffer.toString();
  }

  Exception _handleFirebaseError(FirebaseException e) {
    switch (e.code) {
      case 'user-not-found':
        return Exception('البريد الإلكتروني غير مسجل');
      case 'wrong-password':
        return Exception('كلمة المرور غير صحيحة');
      case 'email-already-in-use':
        return Exception('البريد الإلكتروني مسجل مسبقاً');
      case 'weak-password':
        return Exception('كلمة المرور ضعيفة');
      case 'invalid-email':
        return Exception('البريد الإلكتروني غير صحيح');
      case 'too-many-requests':
        return Exception('محاولات كثيرة. حاول لاحقاً');
      case 'network-request-failed':
        return Exception('تحقق من اتصالك بالإنترنت');
      default:
        return Exception('حدث خطأ: ${e.message}');
    }
  }
}
