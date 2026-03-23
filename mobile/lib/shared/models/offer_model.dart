import 'package:cloud_firestore/cloud_firestore.dart';

class OfferModel {
  final String offerId;
  final String titleAr;
  final String titleEn;
  final String bodyAr;
  final String bodyEn;
  final String summaryAr;
  final String summaryEn;
  final String category;
  final List<String> images;
  final List<String> links;
  final bool isVIP;
  final String status;
  final DateTime publishDate;
  final DateTime createdAt;
  final DateTime updatedAt;

  OfferModel({
    required this.offerId,
    required this.titleAr,
    required this.titleEn,
    required this.bodyAr,
    required this.bodyEn,
    required this.summaryAr,
    required this.summaryEn,
    required this.category,
    required this.images,
    required this.links,
    required this.isVIP,
    required this.status,
    required this.publishDate,
    required this.createdAt,
    required this.updatedAt,
  });

  // ── From Firestore ────────────────────────────────
  factory OfferModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return OfferModel(
      offerId: doc.id,
      titleAr: data['title_ar'] ?? '',
      titleEn: data['title_en'] ?? '',
      bodyAr: data['body_ar'] ?? '',
      bodyEn: data['body_en'] ?? '',
      summaryAr: data['summary_ar'] ?? '',
      summaryEn: data['summary_en'] ?? '',
      category: data['category'] ?? '',
      images: List<String>.from(data['images'] ?? []),
      links: List<String>.from(data['links'] ?? []),
      isVIP: data['isVIP'] ?? false,
      status: data['status'] ?? 'draft',
      publishDate: (data['publishDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  // ── To Firestore ──────────────────────────────────
  Map<String, dynamic> toFirestore() {
    return {
      'title_ar': titleAr,
      'title_en': titleEn,
      'body_ar': bodyAr,
      'body_en': bodyEn,
      'summary_ar': summaryAr,
      'summary_en': summaryEn,
      'category': category,
      'images': images,
      'links': links,
      'isVIP': isVIP,
      'status': status,
      'publishDate': Timestamp.fromDate(publishDate),
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  // ── Copy With ─────────────────────────────────────
  OfferModel copyWith({
    String? titleAr,
    String? titleEn,
    String? bodyAr,
    String? bodyEn,
    String? summaryAr,
    String? summaryEn,
    String? category,
    List<String>? images,
    List<String>? links,
    bool? isVIP,
    String? status,
    DateTime? publishDate,
    DateTime? updatedAt,
  }) {
    return OfferModel(
      offerId: offerId,
      titleAr: titleAr ?? this.titleAr,
      titleEn: titleEn ?? this.titleEn,
      bodyAr: bodyAr ?? this.bodyAr,
      bodyEn: bodyEn ?? this.bodyEn,
      summaryAr: summaryAr ?? this.summaryAr,
      summaryEn: summaryEn ?? this.summaryEn,
      category: category ?? this.category,
      images: images ?? this.images,
      links: links ?? this.links,
      isVIP: isVIP ?? this.isVIP,
      status: status ?? this.status,
      publishDate: publishDate ?? this.publishDate,
      createdAt: createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }

  // ── Helper Getters ────────────────────────────────
  bool get isPublished => status == 'published';
  bool get isDraft => status == 'draft';
  bool get isHidden => status == 'hidden';

  /// Returns title based on language code
  String title(String langCode) => langCode == 'ar' ? titleAr : titleEn;

  /// Returns summary based on language code
  String summary(String langCode) => langCode == 'ar' ? summaryAr : summaryEn;

  /// Returns body based on language code
  String body(String langCode) => langCode == 'ar' ? bodyAr : bodyEn;
}
