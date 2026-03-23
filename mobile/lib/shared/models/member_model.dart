import 'package:cloud_firestore/cloud_firestore.dart';

class MemberModel {
  final String uid;
  final String fullName;
  final String email;
  final String phone;
  final String nationalId;
  final String city;
  final String jobTitle;
  final String investmentLevel;
  final List<String> interests;
  final String howDidYouKnow;
  final String role;
  final String status;
  final String? invitedBy;
  final String referralCode;
  final String language;
  final bool agreedToTerms;
  final DateTime createdAt;
  final DateTime updatedAt;

  MemberModel({
    required this.uid,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.nationalId,
    required this.city,
    required this.jobTitle,
    required this.investmentLevel,
    required this.interests,
    required this.howDidYouKnow,
    required this.role,
    required this.status,
    this.invitedBy,
    required this.referralCode,
    required this.language,
    required this.agreedToTerms,
    required this.createdAt,
    required this.updatedAt,
  });

  // ── From Firestore ────────────────────────────────
  factory MemberModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return MemberModel(
      uid: doc.id,
      fullName: data['fullName'] ?? '',
      email: data['email'] ?? '',
      phone: data['phone'] ?? '',
      nationalId: data['nationalId'] ?? '',
      city: data['city'] ?? '',
      jobTitle: data['jobTitle'] ?? '',
      investmentLevel: data['investmentLevel'] ?? '',
      interests: List<String>.from(data['interests'] ?? []),
      howDidYouKnow: data['howDidYouKnow'] ?? '',
      role: data['role'] ?? 'member',
      status: data['status'] ?? 'active',
      invitedBy: data['invitedBy'],
      referralCode: data['referralCode'] ?? '',
      language: data['language'] ?? 'ar',
      agreedToTerms: data['agreedToTerms'] ?? false,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  // ── To Firestore ──────────────────────────────────
  Map<String, dynamic> toFirestore() {
    return {
      'fullName': fullName,
      'email': email,
      'phone': phone,
      'nationalId': nationalId,
      'city': city,
      'jobTitle': jobTitle,
      'investmentLevel': investmentLevel,
      'interests': interests,
      'howDidYouKnow': howDidYouKnow,
      'role': role,
      'status': status,
      'invitedBy': invitedBy,
      'referralCode': referralCode,
      'language': language,
      'agreedToTerms': agreedToTerms,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  // ── Copy With (for editing profile) ───────────────
  MemberModel copyWith({
    String? fullName,
    String? email,
    String? phone,
    String? city,
    String? jobTitle,
    String? investmentLevel,
    List<String>? interests,
    String? howDidYouKnow,
    String? role,
    String? status,
    String? invitedBy,
    String? language,
    DateTime? updatedAt,
  }) {
    return MemberModel(
      uid: uid,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      nationalId: nationalId, // لا يتغير أبداً
      city: city ?? this.city,
      jobTitle: jobTitle ?? this.jobTitle,
      investmentLevel: investmentLevel ?? this.investmentLevel,
      interests: interests ?? this.interests,
      howDidYouKnow: howDidYouKnow ?? this.howDidYouKnow,
      role: role ?? this.role,
      status: status ?? this.status,
      invitedBy: invitedBy ?? this.invitedBy,
      referralCode: referralCode, // لا يتغير
      language: language ?? this.language,
      agreedToTerms: agreedToTerms, // لا يتغير
      createdAt: createdAt, // لا يتغير
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }

  // ── Helper Getters ────────────────────────────────
  bool get isAdmin => role == 'admin';
  bool get isMember => role == 'member';
  bool get isActive => status == 'active';
  bool get isVip => status == 'vip';
  bool get isSuspended => status == 'suspended';
}
