import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../shared/constants/app_colors.dart';
import '../../../shared/models/offer_model.dart';
import '../../../app/providers.dart';
import '../widgets/offer_card.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  // TODO: Replace with Firestore stream
  final List<OfferModel> _mockOffers = [
    OfferModel(
      offerId: '1',
      titleAr: 'مبادرة 5 دقائق – الموسم الثاني',
      titleEn: '5 Minutes Initiative – Season 2',
      bodyAr: 'قريباً انطلاق الموسم الثاني من مبادرة "5 دقائق". هذه المرة التجربة مختلفة تماماً، وصوتك أنت سيصنع قائمة المشاريع المختارة. ستتاح الفرصة لجميع الأعضاء لاختيار 10 مشاريع من أصل 150 مشروعاً معتمداً في بنك المشاريع.',
      bodyEn: 'Coming soon: Season 2 of the "5 Minutes" initiative. This time the experience is completely different, and your voice will shape the list of selected projects.',
      summaryAr: 'قريباً انطلاق الموسم الثاني من مبادرة "5 دقائق" — صوتك يصنع قائمة المشاريع المختارة',
      summaryEn: 'Season 2 of "5 Minutes" initiative is coming — your voice shapes the selected projects',
      category: 'مبادرات',
      images: [],
      links: ['https://vcmem.com/5min'],
      isVIP: false,
      status: 'published',
      publishDate: DateTime(2026, 3, 22),
      createdAt: DateTime(2026, 3, 22),
      updatedAt: DateTime(2026, 3, 22),
    ),
    OfferModel(
      offerId: '2',
      titleAr: 'بنك المشاريع – اختر مشروعك المفضل',
      titleEn: 'Projects Bank – Choose Your Favorite Project',
      bodyAr: 'قاعدة بيانات أونلاين تحوي مئات المشاريع المنتقاة بضوابط ومقاييس محددة، تتيح لكل من يهمه أمر الشراكة من الأعضاء المسجلين أن يختار ما يناسبه.',
      bodyEn: 'An online database containing hundreds of selected projects with specific criteria, allowing registered members to choose suitable partnerships.',
      summaryAr: 'اختر من بين مئات المشاريع المنتقاة وتواصل مباشرة مع مؤسس المشروع',
      summaryEn: 'Choose from hundreds of curated projects and connect directly with founders',
      category: 'فرص استثمارية',
      images: [],
      links: ['https://vibesholding.com/pb'],
      isVIP: false,
      status: 'published',
      publishDate: DateTime(2026, 3, 20),
      createdAt: DateTime(2026, 3, 20),
      updatedAt: DateTime(2026, 3, 20),
    ),
    OfferModel(
      offerId: '3',
      titleAr: 'فرصة استثمارية – شركة أبعاد الابتكار',
      titleEn: 'Investment Opportunity – Innovation Dimensions',
      bodyAr: 'يسرّ نادي المستثمرين استضافة د. ريم النفيسة مؤسسة شركة أبعاد الابتكار. الشركة متخصصة في قيادة الابتكار والتحول المؤسسي مع خطط توسع طموحة نحو الإمارات وقطر بحلول 2026.',
      bodyEn: 'The Investors Club is pleased to host Dr. Reem Al-Nafisah, founder of Innovation Dimensions – specialists in innovation leadership and organizational transformation.',
      summaryAr: 'فرصة شراكة مع شركة متخصصة في الابتكار والتحول المؤسسي — 10% من حصة الشركة مطروحة للشراكة',
      summaryEn: 'Partnership opportunity with an innovation company – 10% equity offered for strategic partners',
      category: 'فرص استثمارية',
      images: [],
      links: [],
      isVIP: true,
      status: 'published',
      publishDate: DateTime(2026, 3, 15),
      createdAt: DateTime(2026, 3, 15),
      updatedAt: DateTime(2026, 3, 15),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final locale = ref.watch(languageProvider);
    final langCode = locale.languageCode;

    return Scaffold(
      // ── App Bar ──────────────────────────────────
      appBar: AppBar(
        title: Text(
          langCode == 'ar' ? 'نادي المستثمرين' : 'Investors Club',
        ),
        leading: Padding(
          padding: const EdgeInsets.all(10),
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.primaryGold, width: 1.5),
            ),
            child: const Icon(
              Icons.account_balance,
              size: 20,
              color: AppColors.primaryGold,
            ),
            // TODO: Replace with logo
          ),
        ),
        actions: [
          // زر الإشعارات (مستقبلي)
          IconButton(
            onPressed: () {
              // TODO: Notifications
            },
            icon: const Icon(Icons.notifications_outlined),
          ),
        ],
      ),

      body: RefreshIndicator(
        color: AppColors.primaryGold,
        onRefresh: () async {
          // TODO: Refresh offers from Firestore
          await Future.delayed(const Duration(seconds: 1));
        },
        child: CustomScrollView(
          slivers: [
            // ── Welcome Banner ────────────────────
            SliverToBoxAdapter(
              child: Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      langCode == 'ar' ? 'مرحباً بك 👋' : 'Welcome 👋',
                      style: const TextStyle(
                        fontFamily: 'IBMPlexSansArabic',
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primaryGold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      langCode == 'ar'
                          ? 'اكتشف أحدث الفرص الاستثمارية المتاحة لأعضاء النادي'
                          : 'Discover the latest investment opportunities for club members',
                      style: TextStyle(
                        fontFamily: 'IBMPlexSansArabic',
                        fontSize: 13,
                        color: AppColors.textOnDark.withValues(alpha: 0.8),
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 14),
                    // Quick stats
                    Row(
                      children: [
                        _buildStatChip(
                          Icons.trending_up,
                          langCode == 'ar' ? '${_mockOffers.length} عروض' : '${_mockOffers.length} Offers',
                        ),
                        const SizedBox(width: 10),
                        _buildStatChip(
                          Icons.star,
                          langCode == 'ar'
                              ? '${_mockOffers.where((o) => o.isVIP).length} VIP'
                              : '${_mockOffers.where((o) => o.isVIP).length} VIP',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // ── Section Header ────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
                child: Row(
                  children: [
                    Container(
                      width: 4,
                      height: 22,
                      decoration: BoxDecoration(
                        color: AppColors.primaryGold,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      langCode == 'ar'
                          ? 'أحدث العروض الاستثمارية'
                          : 'Latest Investment Offers',
                      style: const TextStyle(
                        fontFamily: 'IBMPlexSansArabic',
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ── Offers List ───────────────────────
            _mockOffers.isEmpty
                ? SliverFillRemaining(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.inbox_outlined,
                            size: 60,
                            color: AppColors.textHint.withValues(alpha: 0.5),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            langCode == 'ar'
                                ? 'لا توجد عروض حالياً'
                                : 'No offers available',
                            style: const TextStyle(
                              fontFamily: 'IBMPlexSansArabic',
                              fontSize: 16,
                              color: AppColors.textHint,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final offer = _mockOffers[index];
                        return OfferCard(
                          offer: offer,
                          langCode: langCode,
                          onTap: () {
                            context.push('/offer/${offer.offerId}');
                          },
                        );
                      },
                      childCount: _mockOffers.length,
                    ),
                  ),

            // Bottom spacing
            const SliverToBoxAdapter(
              child: SizedBox(height: 20),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.primaryGold.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppColors.primaryGold),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'IBMPlexSansArabic',
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.primaryGold,
            ),
          ),
        ],
      ),
    );
  }
}
