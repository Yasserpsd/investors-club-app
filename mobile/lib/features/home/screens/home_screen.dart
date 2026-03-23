import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../shared/constants/app_colors.dart';
import '../../../shared/widgets/loading_widget.dart';
import '../../../app/providers.dart';
import '../../home/services/offers_service.dart';
import '../../auth/services/auth_service.dart';
import '../widgets/offer_card.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final langCode = ref.watch(languageProvider).languageCode;
    final offersAsync = ref.watch(publishedOffersProvider);
    final memberAsync = ref.watch(currentMemberProvider);

    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      body: CustomScrollView(
        slivers: [
          // ── App Bar ──────────────────────────
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
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 10),
                      // Logo
                      Container(
                        width: 65,
                        height: 65,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primaryGold.withOpacity(0.15),
                              blurRadius: 15,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: ClipOval(
                          child: Image.asset(
                            'assets/images/logo.png',
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.primaryGold,
                                ),
                                child: const Icon(
                                  Icons.account_balance,
                                  size: 30,
                                  color: AppColors.primaryDark,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Welcome
                      memberAsync.when(
                        data: (member) => Text(
                          member != null
                              ? 'أهلاً بك ${member.fullName}'
                              : 'أهلاً بك في نادي المستثمرين',
                          style: TextStyle(
                            fontFamily: 'IBMPlexSansArabic',
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white.withOpacity(0.9),
                          ),
                        ),
                        loading: () => const SizedBox.shrink(),
                        error: (_, __) => const SizedBox.shrink(),
                      ),

                      const SizedBox(height: 12),

                      // Stats row
                      offersAsync.when(
                        data: (offers) => Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _StatChip(
                              label: langCode == 'ar'
                                  ? 'عروض متاحة'
                                  : 'Available',
                              value: '${offers.length}',
                            ),
                            const SizedBox(width: 12),
                            _StatChip(
                              label: langCode == 'ar'
                                  ? 'عروض VIP'
                                  : 'VIP',
                              value:
                                  '${offers.where((o) => o.isVIP).length}',
                            ),
                            const SizedBox(width: 12),
                            _StatChip(
                              label: langCode == 'ar'
                                  ? 'أقسام'
                                  : 'Categories',
                              value:
                                  '${offers.map((o) => o.category).toSet().length}',
                            ),
                          ],
                        ),
                        loading: () => const SizedBox.shrink(),
                        error: (_, __) => const SizedBox.shrink(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            actions: [
              IconButton(
                onPressed: () {
                  // TODO: Notifications
                },
                icon: Icon(
                  Icons.notifications_outlined,
                  color: Colors.white.withOpacity(0.7),
                ),
              ),
            ],
          ),

          // ── Section Title ────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
              child: Row(
                children: [
                  Container(
                    width: 4,
                    height: 20,
                    decoration: BoxDecoration(
                      color: AppColors.primaryGold,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    langCode == 'ar'
                        ? 'أحدث الفرص الاستثمارية'
                        : 'Latest Investment Opportunities',
                    style: const TextStyle(
                      fontFamily: 'IBMPlexSansArabic',
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Offers List ──────────────────────
          offersAsync.when(
            data: (offers) {
              if (offers.isEmpty) {
                return SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.inbox_outlined,
                          size: 60,
                          color: Colors.white.withOpacity(0.2),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          langCode == 'ar'
                              ? 'لا توجد عروض حالياً'
                              : 'No offers available',
                          style: TextStyle(
                            fontFamily: 'IBMPlexSansArabic',
                            fontSize: 16,
                            color: Colors.white.withOpacity(0.4),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }

              return SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final offer = offers[index];
                    return OfferCard(
                      offer: offer,
                      langCode: langCode,
                      onTap: () => context.push('/offer/${offer.offerId}'),
                    );
                  },
                  childCount: offers.length,
                ),
              );
            },
            loading: () => const SliverFillRemaining(
              child: LoadingWidget(message: 'جاري تحميل العروض...'),
            ),
            error: (error, _) => SliverFillRemaining(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 50,
                      color: AppColors.error.withOpacity(0.7),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'حدث خطأ في تحميل العروض',
                      style: TextStyle(
                        fontFamily: 'IBMPlexSansArabic',
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.5),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextButton(
                      onPressed: () =>
                          ref.invalidate(publishedOffersProvider),
                      child: const Text(
                        'إعادة المحاولة',
                        style: TextStyle(
                          fontFamily: 'IBMPlexSansArabic',
                          color: AppColors.primaryGold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Bottom spacing
          const SliverToBoxAdapter(
            child: SizedBox(height: 100),
          ),
        ],
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final String label;
  final String value;
  const _StatChip({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.06),
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
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.primaryGold,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontFamily: 'IBMPlexSansArabic',
              fontSize: 10,
              color: Colors.white.withOpacity(0.5),
            ),
          ),
        ],
      ),
    );
  }
}
