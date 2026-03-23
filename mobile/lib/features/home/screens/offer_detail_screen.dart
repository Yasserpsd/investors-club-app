import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';
import '../../../shared/constants/app_colors.dart';
import '../../../shared/widgets/loading_widget.dart';
import '../../../app/providers.dart';
import '../../home/services/offers_service.dart';

class OfferDetailScreen extends ConsumerWidget {
  final String offerId;
  const OfferDetailScreen({super.key, required this.offerId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final langCode = ref.watch(languageProvider).languageCode;
    final offerAsync = ref.watch(offerByIdProvider(offerId));

    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      body: offerAsync.when(
        data: (offer) {
          if (offer == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline,
                      size: 50, color: Colors.white.withOpacity(0.3)),
                  const SizedBox(height: 16),
                  Text(
                    langCode == 'ar'
                        ? 'لم يتم العثور على العرض'
                        : 'Offer not found',
                    style: TextStyle(
                      fontFamily: 'IBMPlexSansArabic',
                      color: Colors.white.withOpacity(0.5),
                    ),
                  ),
                ],
              ),
            );
          }

          return CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: offer.images.isNotEmpty ? 250 : 120,
                pinned: true,
                backgroundColor: AppColors.primaryDark,
                leading: IconButton(
                  onPressed: () => context.pop(),
                  icon: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.3),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.arrow_back,
                        color: Colors.white, size: 20),
                  ),
                ),
                flexibleSpace: FlexibleSpaceBar(
                  background: offer.images.isNotEmpty
                      ? Stack(
                          fit: StackFit.expand,
                          children: [
                            Image.network(
                              offer.images.first,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: AppColors.primaryDark,
                                  child: Icon(
                                    Icons.image_outlined,
                                    size: 50,
                                    color: Colors.white.withOpacity(0.15),
                                  ),
                                );
                              },
                            ),
                            Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.transparent,
                                    AppColors.primaryDark.withOpacity(0.8),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        )
                      : Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Color(0xFF0d0d1a),
                                AppColors.primaryDark,
                              ],
                            ),
                          ),
                        ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color:
                                  AppColors.primaryGold.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              offer.category,
                              style: const TextStyle(
                                fontFamily: 'IBMPlexSansArabic',
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primaryGold,
                              ),
                            ),
                          ),
                          if (offer.isVIP) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                color: Colors.amber.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.star,
                                      size: 12, color: Colors.amber),
                                  SizedBox(width: 4),
                                  Text(
                                    'VIP',
                                    style: TextStyle(
                                      fontFamily: 'IBMPlexSansArabic',
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.amber,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                          const Spacer(),
                          Icon(Icons.calendar_today,
                              size: 14,
                              color: Colors.white.withOpacity(0.4)),
                          const SizedBox(width: 6),
                          Text(
                            offer.publishDate
                                .toString()
                                .substring(0, 10),
                            style: TextStyle(
                              fontFamily: 'IBMPlexSansArabic',
                              fontSize: 12,
                              color: Colors.white.withOpacity(0.4),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Text(
                        offer.title(langCode),
                        style: const TextStyle(
                          fontFamily: 'IBMPlexSansArabic',
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        offer.body(langCode),
                        style: TextStyle(
                          fontFamily: 'IBMPlexSansArabic',
                          fontSize: 15,
                          color: Colors.white.withOpacity(0.75),
                          height: 1.8,
                        ),
                      ),
                      if (offer.links.isNotEmpty) ...[
                        const SizedBox(height: 30),
                        Row(
                          children: [
                            Container(
                              width: 4,
                              height: 18,
                              decoration: BoxDecoration(
                                color: AppColors.primaryGold,
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              langCode == 'ar'
                                  ? 'روابط ذات صلة'
                                  : 'Related Links',
                              style: const TextStyle(
                                fontFamily: 'IBMPlexSansArabic',
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        ...offer.links.map((link) {
                          return Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            child: InkWell(
                              onTap: () async {
                                final uri = Uri.parse(link);
                                if (await canLaunchUrl(uri)) {
                                  await launchUrl(uri,
                                      mode:
                                          LaunchMode.externalApplication);
                                }
                              },
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.05),
                                  borderRadius:
                                      BorderRadius.circular(10),
                                  border: Border.all(
                                    color: AppColors.primaryGold
                                        .withOpacity(0.1),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(
                                        Icons.open_in_new_outlined,
                                        size: 16,
                                        color: AppColors.primaryGold),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        link,
                                        style: const TextStyle(
                                          fontFamily:
                                              'IBMPlexSansArabic',
                                          fontSize: 13,
                                          color: AppColors.primaryGold,
                                          decoration:
                                              TextDecoration.underline,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
                      ],
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
        loading: () => const Center(
            child: LoadingWidget(message: 'جاري تحميل العرض...')),
        error: (error, _) => Center(
          child: Text(
            'حدث خطأ: $error',
            style: const TextStyle(
                fontFamily: 'IBMPlexSansArabic', color: Colors.white54),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 30),
        decoration: BoxDecoration(
          color: AppColors.primaryDark,
          border: Border(
            top: BorderSide(
                color: AppColors.primaryGold.withOpacity(0.1)),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {
                  final offer =
                      ref.read(offerByIdProvider(offerId)).value;
                  if (offer != null) {
                    SharePlus.instance.share(
                      ShareParams(
                        text:
                            '${offer.title('ar')}\n\nhttps://vcmem.com/update/',
                      ),
                    );
                  }
                },
                icon: const Icon(Icons.share, size: 18),
                label: Text(
                  ref.watch(languageProvider).languageCode == 'ar'
                      ? 'مشاركة'
                      : 'Share',
                  style: const TextStyle(
                    fontFamily: 'IBMPlexSansArabic',
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryGold,
                  foregroundColor: AppColors.primaryDark,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => context.push('/chat'),
                icon: const Icon(Icons.chat_outlined, size: 18),
                label: Text(
                  ref.watch(languageProvider).languageCode == 'ar'
                      ? 'تواصل'
                      : 'Contact',
                  style: const TextStyle(
                    fontFamily: 'IBMPlexSansArabic',
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primaryGold,
                  side: const BorderSide(color: AppColors.primaryGold),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
