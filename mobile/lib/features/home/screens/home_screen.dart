import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../shared/constants/app_colors.dart';
import '../../../shared/models/offer_model.dart';
import '../widgets/offer_card.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  bool _isLoading = false;

  // TODO: Replace with Firestore stream
  final List<OfferModel> _offers = [
    OfferModel(
      offerId: '1',
      titleAr: 'فرصة استثمارية في قطاع التقنية',
      titleEn: 'Investment Opportunity in Tech Sector',
      bodyAr: 'تفاصيل الفرصة الاستثمارية الكاملة...',
      bodyEn: 'Full investment opportunity details...',
      summaryAr: 'شركة تقنية ناشئة تبحث عن مستثمرين',
      summaryEn: 'A tech startup looking for investors',
      category: 'تقنية',
      images: [],
      links: [],
      isVIP: true,
      status: 'published',
      publishDate: DateTime(2026, 3, 22),
      createdAt: DateTime(2026, 3, 22),
      updatedAt: DateTime(2026, 3, 22),
    ),
    OfferModel(
      offerId: '2',
      titleAr: 'مشروع عقاري في الرياض',
      titleEn: 'Real Estate Project in Riyadh',
      bodyAr: 'تفاصيل المشروع العقاري...',
      bodyEn: 'Real estate project details...',
      summaryAr: 'مشروع سكني متكامل بعائد متوقع ممتاز',
      summaryEn: 'Integrated residential project with excellent ROI',
      category: 'عقارات',
      images: [],
      links: [],
      isVIP: false,
      status: 'published',
      publishDate: DateTime(2026, 3, 20),
      createdAt: DateTime(2026, 3, 20),
      updatedAt: DateTime(2026, 3, 20),
    ),
    OfferModel(
      offerId: '3',
      titleAr: 'فرنشايز مطاعم - امتياز تجاري',
      titleEn: 'Restaurant Franchise Opportunity',
      bodyAr: 'تفاصيل فرصة الامتياز التجاري...',
      bodyEn: 'Franchise opportunity details...',
      summaryAr: 'علامة تجارية سعودية تبحث عن شركاء امتياز',
      summaryEn: 'Saudi brand seeking franchise partners',
      category: 'أغذية',
      images: [],
      links: [],
      isVIP: false,
      status: 'published',
      publishDate: DateTime(2026, 3, 15),
      createdAt: DateTime(2026, 3, 15),
      updatedAt: DateTime(2026, 3, 15),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      body: CustomScrollView(
        slivers: [
          // Custom App Bar
          SliverAppBar(
            expandedHeight: 200,
            floating: false,
            pinned: true,
            backgroundColor: AppColors.primaryDark,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFF0d0d1a),
                      AppColors.primaryDark,
                    ],
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            // Logo
                            Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.primaryGold
                                        .withOpacity(0.2),
                                    blurRadius: 10,
                                  ),
                                ],
                              ),
                              child: ClipOval(
                                child: Image.asset(
                                  'assets/images/logo.png',
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => Container(
                                    color: AppColors.primaryGold,
                                    child: const Icon(
                                      Icons.account_balance,
                                      color: AppColors.primaryDark,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'أهلاً بك في',
                                    style: TextStyle(
                                      fontFamily: 'IBMPlexSansArabic',
                                      fontSize: 13,
                                      color: Colors.white54,
                                    ),
                                  ),
                                  const Text(
                                    'نادي المستثمرين',
                                    style: TextStyle(
                                      fontFamily: 'IBMPlexSansArabic',
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.primaryGold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Notification bell
                            IconButton(
                              onPressed: () {
                                // TODO: Notifications
                              },
                              icon: Stack(
                                children: [
                                  Icon(
                                    Icons.notifications_outlined,
                                    color: Colors.white.withOpacity(0.7),
                                    size: 26,
                                  ),
                                  Positioned(
                                    right: 0,
                                    top: 0,
                                    child: Container(
                                      width: 8,
                                      height: 8,
                                      decoration: const BoxDecoration(
                                        color: AppColors.primaryGold,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        // Stats row
                        Row(
                          children: [
                            _buildStat('${_offers.length}', 'عروض متاحة'),
                            const SizedBox(width: 12),
                            _buildStat(
                              '${_offers.where((o) => o.isVIP).length}',
                              'عروض VIP',
                            ),
                            const SizedBox(width: 12),
                            _buildStat('3', 'أقسام'),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Section title
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
              child: Row(
                children: [
                  Container(
                    width: 4,
                    height: 18,
                    decoration: BoxDecoration(
                      color: AppColors.primaryGold,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'أحدث الفرص الاستثمارية',
                    style: TextStyle(
                      fontFamily: 'IBMPlexSansArabic',
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Offers list
          _offers.isEmpty
              ? SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.inbox_outlined,
                          size: 60,
                          color: Colors.white.withOpacity(0.2),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'لا توجد عروض حالياً',
                          style: TextStyle(
                            fontFamily: 'IBMPlexSansArabic',
                            fontSize: 16,
                            color: Colors.white.withOpacity(0.4),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final offer = _offers[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: OfferCard(
                            offer: offer,
                            onTap: () => context.push('/offer/${offer.offerId}'),
                          ),
                        );
                      },
                      childCount: _offers.length,
                    ),
                  ),
                ),

          // Bottom spacing
          const SliverToBoxAdapter(
            child: SizedBox(height: 80),
          ),
        ],
      ),
    );
  }

  Widget _buildStat(String value, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.primaryGold.withOpacity(0.1),
          ),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: const TextStyle(
                fontFamily: 'IBMPlexSansArabic',
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppColors.primaryGold,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'IBMPlexSansArabic',
                fontSize: 11,
                color: Colors.white.withOpacity(0.5),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
