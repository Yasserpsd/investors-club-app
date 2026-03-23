import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../shared/constants/app_colors.dart';
import '../../../shared/models/offer_model.dart';
import '../../../app/providers.dart';

class OfferDetailScreen extends ConsumerWidget {
  final String offerId;

  const OfferDetailScreen({super.key, required this.offerId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(languageProvider);
    final langCode = locale.languageCode;

    // TODO: Fetch from Firestore by offerId
    // For now use mock data
    final offer = OfferModel(
      offerId: offerId,
      titleAr: 'مبادرة 5 دقائق – الموسم الثاني',
      titleEn: '5 Minutes Initiative – Season 2',
      bodyAr: '''قريباً… انطلاق الموسم الثاني من مبادرة "5 دقائق"

لكن هذه المرة… التجربة مختلفة تماماً، وصوتك أنت سيصنع قائمة المشاريع المختارة.

في إدارة نادي المستثمرين رأينا أن يكون لكم أنتم الأعضاء الدور الأكبر والأكثر تأثيراً في اختيار المشاريع التي ستصعد على المنصة هذا الموسم.

كيف كانت الآلية سابقاً؟
اعتادت إدارة النادي أن تختار بنفسها المشاريع التي تُعرض على منصة النادي في مقره بمدينة الرياض.

ما الجديد في الموسم الثاني؟
هذه المرة ستتاح الفرصة لجميع الأعضاء لاختيار:
• 10 مشاريع من أصل 150 مشروعاً معتمداً في بنك المشاريع
• هذه المشاريع تم اختيارها بعناية بعد فلترة أكثر من 700 مشروع
• جميعها تعود ملكيتها لأعضاء نادي المستثمرين

خطوات المشاركة:
1. قم بزيارة بنك المشاريع
2. اختر رقم المشروع الذي يهمك
3. أرسل رقمه على الخاص

بعد ذلك:
• سنقوم باختيار أعلى 10 مشاريع حصولاً على الترشيحات
• ثم نطرحها للتصويت العام
• ليتم في النهاية اعتماد 5 مشاريع فقط للمشاركة على منصة النادي

صوتك = تأثيرك''',
      bodyEn: 'Coming soon: Season 2 of the "5 Minutes" initiative...',
      summaryAr: 'قريباً انطلاق الموسم الثاني من مبادرة "5 دقائق"',
      summaryEn: 'Season 2 of "5 Minutes" initiative is coming',
      category: 'مبادرات',
      images: [],
      links: ['https://vcmem.com/5min', 'https://vibesholding.com/pb'],
      isVIP: false,
      status: 'published',
      publishDate: DateTime(2026, 3, 22),
      createdAt: DateTime(2026, 3, 22),
      updatedAt: DateTime(2026, 3, 22),
    );

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // ── App Bar ──────────────────────────────
          SliverAppBar(
            expandedHeight: offer.images.isNotEmpty ? 250 : 0,
            pinned: true,
            backgroundColor: AppColors.primaryDark,
            leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primaryDark.withValues(alpha: 0.7),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.arrow_back,
                  color: AppColors.primaryGold,
                  size: 20,
                ),
              ),
            ),
            flexibleSpace: offer.images.isNotEmpty
                ? FlexibleSpaceBar(
                    background: Image.network(
                      offer.images.first,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: AppColors.primaryDark,
                      ),
                    ),
                  )
                : null,
          ),

          // ── Content ─────────────────────────────
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header section
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    color: AppColors.primaryDark,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Tags
                      Row(
                        children: [
                          if (offer.category.isNotEmpty)
                            _buildTag(offer.category, false),
                          if (offer.isVIP) ...[
                            const SizedBox(width: 8),
                            _buildTag('VIP', true),
                          ],
                        ],
                      ),
                      const SizedBox(height: 14),

                      // Title
                      Text(
                        offer.title(langCode),
                        style: const TextStyle(
                          fontFamily: 'IBMPlexSansArabic',
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textOnDark,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Date
                      Row(
                        children: [
                          const Icon(
                            Icons.calendar_today_outlined,
                            size: 14,
                            color: AppColors.primaryGold,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            _formatDate(offer.publishDate, langCode),
                            style: TextStyle(
                              fontFamily: 'IBMPlexSansArabic',
                              fontSize: 13,
                              color: AppColors.primaryGold.withValues(alpha: 0.8),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Body
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text(
                    offer.body(langCode),
                    style: const TextStyle(
                      fontFamily: 'IBMPlexSansArabic',
                      fontSize: 15,
                      color: AppColors.textPrimary,
                      height: 1.8,
                    ),
                  ),
                ),

                // Links
                if (offer.links.isNotEmpty) ...[
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Divider(),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          langCode == 'ar' ? 'روابط ذات صلة' : 'Related Links',
                          style: const TextStyle(
                            fontFamily: 'IBMPlexSansArabic',
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 12),
                        ...offer.links.map((link) => _buildLinkTile(link)),
                      ],
                    ),
                  ),
                ],

                const SizedBox(height: 30),
              ],
            ),
          ),
        ],
      ),

      // ── Bottom Action ─────────────────────────
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.backgroundWhite,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Row(
            children: [
              // Share button
              Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.primaryGold),
                ),
                child: IconButton(
                  onPressed: () {
                    // TODO: Share offer
                  },
                  icon: const Icon(
                    Icons.share_outlined,
                    color: AppColors.primaryGold,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Contact button
              Expanded(
                child: SizedBox(
                  height: 50,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // TODO: Navigate to chat or open WhatsApp
                    },
                    icon: const Icon(Icons.chat_bubble_outline, size: 20),
                    label: Text(
                      langCode == 'ar'
                          ? 'تواصل مع الإدارة'
                          : 'Contact Admin',
                      style: const TextStyle(
                        fontFamily: 'IBMPlexSansArabic',
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTag(String text, bool isVIP) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: isVIP ? AppColors.primaryGold : AppColors.primaryGold.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontFamily: 'IBMPlexSansArabic',
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: isVIP ? AppColors.primaryDark : AppColors.primaryGold,
        ),
      ),
    );
  }

  Widget _buildLinkTile(String url) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: () async {
          final uri = Uri.parse(url);
          if (await canLaunchUrl(uri)) {
            await launchUrl(uri, mode: LaunchMode.externalApplication);
          }
        },
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.backgroundLight,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.link,
                size: 18,
                color: AppColors.primaryGold,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  url,
                  style: const TextStyle(
                    fontFamily: 'IBMPlexSansArabic',
                    fontSize: 13,
                    color: AppColors.primaryGold,
                    decoration: TextDecoration.underline,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const Icon(
                Icons.open_in_new,
                size: 16,
                color: AppColors.textHint,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date, String langCode) {
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
