import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/models/offer_model.dart';

// ═══════════════════════════════════════════════════════
// Offers Service Provider
// ═══════════════════════════════════════════════════════
final offersServiceProvider = Provider<OffersService>((ref) {
  return OffersService();
});

// Stream of published offers (real-time)
final publishedOffersProvider = StreamProvider<List<OfferModel>>((ref) {
  return ref.watch(offersServiceProvider).getPublishedOffers();
});

// Stream of VIP offers only
final vipOffersProvider = StreamProvider<List<OfferModel>>((ref) {
  return ref.watch(offersServiceProvider).getVIPOffers();
});

// Single offer by ID
final offerByIdProvider =
    FutureProvider.family<OfferModel?, String>((ref, offerId) {
  return ref.watch(offersServiceProvider).getOfferById(offerId);
});

// All offers for admin (includes drafts, hidden)
final allOffersProvider = StreamProvider<List<OfferModel>>((ref) {
  return ref.watch(offersServiceProvider).getAllOffers();
});

// ═══════════════════════════════════════════════════════
// Offers Service
// ═══════════════════════════════════════════════════════
class OffersService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  CollectionReference get _offersRef => _firestore.collection('offers');

  // ── Get Published Offers (for members) ──────
  Stream<List<OfferModel>> getPublishedOffers() {
    return _offersRef
        .where('status', isEqualTo: 'published')
        .orderBy('publishDate', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => OfferModel.fromFirestore(doc))
          .toList();
    });
  }

  // ── Get VIP Offers ──────────────────────────
  Stream<List<OfferModel>> getVIPOffers() {
    return _offersRef
        .where('status', isEqualTo: 'published')
        .where('isVIP', isEqualTo: true)
        .orderBy('publishDate', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => OfferModel.fromFirestore(doc))
          .toList();
    });
  }

  // ── Get All Offers (admin) ──────────────────
  Stream<List<OfferModel>> getAllOffers() {
    return _offersRef
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => OfferModel.fromFirestore(doc))
          .toList();
    });
  }

  // ── Get Single Offer ────────────────────────
  Future<OfferModel?> getOfferById(String offerId) async {
    final doc = await _offersRef.doc(offerId).get();
    if (!doc.exists) return null;
    return OfferModel.fromFirestore(doc);
  }

  // ── Create Offer (admin) ────────────────────
  Future<String> createOffer(OfferModel offer) async {
    final docRef = await _offersRef.add(offer.toFirestore());
    return docRef.id;
  }

  // ── Update Offer (admin) ────────────────────
  Future<void> updateOffer(OfferModel offer) async {
    await _offersRef.doc(offer.offerId).update(
      offer.copyWith(updatedAt: DateTime.now()).toFirestore(),
    );
  }

  // ── Toggle Offer Status (admin) ─────────────
  Future<void> toggleOfferStatus(String offerId, String newStatus) async {
    await _offersRef.doc(offerId).update({
      'status': newStatus,
      'updatedAt': Timestamp.fromDate(DateTime.now()),
    });
  }

  // ── Delete Offer (admin) ────────────────────
  Future<void> deleteOffer(String offerId) async {
    await _offersRef.doc(offerId).delete();
  }

  // ── Get Offers Count ────────────────────────
  Future<Map<String, int>> getOffersCounts() async {
    final snapshot = await _offersRef.get();
    final offers = snapshot.docs;
    return {
      'total': offers.length,
      'published': offers.where((d) =>
          (d.data() as Map)['status'] == 'published').length,
      'draft': offers.where((d) =>
          (d.data() as Map)['status'] == 'draft').length,
      'hidden': offers.where((d) =>
          (d.data() as Map)['status'] == 'hidden').length,
      'vip': offers.where((d) =>
          (d.data() as Map)['isVIP'] == true).length,
    };
  }

  // ── Get Offers by Category ──────────────────
  Stream<List<OfferModel>> getOffersByCategory(String category) {
    return _offersRef
        .where('status', isEqualTo: 'published')
        .where('category', isEqualTo: category)
        .orderBy('publishDate', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => OfferModel.fromFirestore(doc))
          .toList();
    });
  }
}
