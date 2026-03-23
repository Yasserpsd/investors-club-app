import 'package:flutter/material.dart';
import '../../../shared/constants/app_colors.dart';
import '../../../shared/models/offer_model.dart';

class OfferCard extends StatelessWidget {
  final OfferModel offer;
  final String langCode;
  final VoidCallback onTap;

  const OfferCard({
    super.key,
    required this.offer,
    required this.langCode,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.backgroundWhite,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── صورة العرض (إن وجدت) ──────────────
            if (offer.images.isNotEmpty)
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
                child: Stack(
                  children: [
                    Image.network(
                      offer.images.first,
                      width: double.infinity,
                      height: 180,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        width: double.infinity,
                        height: 180,
                        color: AppColors.backgroundLight,
                        child: const Icon(
                          Icons.image_outlined,
                          size: 50,
                          color: AppColors.textHint,
                        ),
                      ),
                    ),
                    // VIP Badge
                    if (offer.isVIP)
                      Positioned(
                        top: 12,
                        left: 12,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            gradient: AppColors.goldGradient,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.star, size: 14, color: AppColors.primaryDark),
                              SizedBox(width: 4),
                              Text(
                                'VIP',
                                style: TextStyle(
                                  fontFamily: 'IBMPlexSansArabic',
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.primaryDark,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              )
            else
              // بدون صورة — شريط ذهبي أعلى الكارت
              Container(
                height: 6,
                decoration: const BoxDecoration(
                  gradient: AppColors.goldGradient,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
              ),

            // ── محتوى الكارت ──────────────────────
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // التصنيف + VIP (لو مافي صورة)
                  Row(
                    children: [
                      if (offer.category.isNotEmpty)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primaryDark.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            offer.category,
                            style: const TextStyle(
                              fontFamily: 'IBMPlexSansArabic',
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primaryDark,
                            ),
                          ),
                        ),
                      if (offer.isVIP && offer.images.isEmpty) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            gradient: AppColors.goldGradient,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            'VIP',
                            style: TextStyle(
                              fontFamily: 'IBMPlexSansArabic',
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primaryDark,
                            ),
                          ),
                        ),
                      ],
                      const Spacer(),
                      // التاريخ
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.calendar_today_outlined,
                            size: 13,
                            color: AppColors.textHint,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            _formatDate(offer.publishDate),
                            style: const TextStyle(
                              fontFamily: 'IBMPlexSansArabic',
                              fontSize: 11,
                              color: AppColors.textHint,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // العنوان
                  Text(
                    offer.title(langCode),
                    style: const TextStyle(
                      fontFamily: 'IBMPlexSansArabic',
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                      height: 1.4,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 8),

                  // الملخص
                  Text(
                    offer.summary(langCode),
                    style: const TextStyle(
                      fontFamily: 'IBMPlexSansArabic',
                      fontSize: 13,
                      color: AppColors.textSecondary,
                      height: 1.6,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 14),

                  // زر التفاصيل
                  Row(
                    children: [
                      Text(
                        langCode == 'ar' ? 'عرض التفاصيل' : 'View Details',
                        style: const TextStyle(
                          fontFamily: 'IBMPlexSansArabic',
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryGold,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        langCode == 'ar'
                            ? Icons.arrow_back_ios
                            : Icons.arrow_forward_ios,
                        size: 13,
                        color: AppColors.primaryGold,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      '', 'يناير', 'فبراير', 'مارس', 'أبريل', 'مايو', 'يونيو',
      'يوليو', 'أغسطس', 'سبتمبر', 'أكتوبر', 'نوفمبر', 'ديسمبر',
    ];
    if (langCode == 'ar') {
      return '${date.day} ${months[date.month]} ${date.year}';
    }
    return '${date.day}/${date.month}/${date.year}';
  }
}
