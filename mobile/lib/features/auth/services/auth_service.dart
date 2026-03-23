import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import '../../../shared/models/member_model.dart';

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<UserCredential> signIn({
    required String email,
    required String password,
  }) async {
    final credential = await _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );

    final uid = credential.user!.uid;
    final doc = await _firestore.collection('members').doc(uid).get();
    if (doc.exists) {
      final status = doc.data()?['status'] ?? 'active';
      if (status == 'suspended') {
        await _auth.signOut();
        throw Exception('account-suspended');
      }
    }

    return credential;
  }

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
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );

    final uid = credential.user!.uid;
    final fullName = '${firstName.trim()} ${lastName.trim()}';

    await credential.user!.updateDisplayName(fullName);

    final referralCode =
        'INV-${const Uuid().v4().substring(0, 5).toUpperCase()}';

    await _firestore.collection('members').doc(uid).set({
      'uid': uid,
      'fullName': fullName,
      'email': email.trim(),
      'phone': phone.trim(),
      'nationalId': nationalId.trim(),
      'city': city.trim(),
      'jobTitle': '',
      'investmentLevel': financialCapacity,
      'interests': [],
      'howDidYouKnow': '',
      'role': 'member',
      'status': 'active',
      'invitedBy': inviteCode?.trim() ?? '',
      'referralCode': referralCode,
      'language': language,
      'agreedToTerms': agreedToTerms,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });

    return credential;
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<void> resetPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email.trim());
  }

  Stream<MemberModel?> currentMemberStream(String uid) {
    return _firestore.collection('members').doc(uid).snapshots().map((doc) {
      if (!doc.exists) return null;
      return MemberModel.fromFirestore(doc);
    });
  }

  User? get currentUser => _auth.currentUser;
}
