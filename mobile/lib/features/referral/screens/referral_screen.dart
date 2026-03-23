import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:share_plus/share_plus.dart';
import '../../../shared/constants/app_colors.dart';
import '../../../shared/widgets/loading_widget.dart';
import '../../../app/providers.dart';
import '../services/referral_service.dart';

class ReferralScreen extends ConsumerWidget {
  const ReferralScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final langCode = ref.watch(languageProvider).languageCode;
    final uid = FirebaseAuth.instance.currentUser?.uid;

    if (uid == null) {
      return const Scaffold(
        body: Center(child: Text('يرجى تسجيل الدخول')),
      );
    }

    final statsAsync = ref.watch(myReferralStatsProvider(uid));
    final referralsAsync = ref.watch(myReferralsProvider(uid));

    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      appBar: AppBar(
        backgroundColor: AppColors.primaryDark,
        elevation: 0,
        title: Text(
          langCode == 'ar' ? 'دعوة الأصدقاء' : 'Invite Friends',
          style: const TextStyle(
            fontFamily: 'IBMPlexSansArabic',
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // ── Hero Card ──
            statsAsync.when(
              data: (stats) {
                final referralCode = stats['referralCode'] as String;
                final referralLink = stats['referralLink'] as String;

                return Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFF2a2a4a),
                        AppColors.primaryDark,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: AppColors.primaryGold.withOpacity(0.2),
                    ),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.card_giftcard,
                        color: AppColors.primaryGold.withOpacity(0.8),
                        size: 40,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        langCode == 'ar'
                            ? 'ادعُ أصدقاءك لنادي المستثمرين'
                            : 'Invite friends to Investors Club',
                        style: const TextStyle(
                          fontFamily: 'IBMPlexSansArabic',
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        langCode == 'ar'
                            ? 'شارك كود الإحالة الخاص بك مع أصدقائك المهتمين بالاستثمار'
                            : 'Share your referral code with investment-minded friends',
                        style: TextStyle(
                          fontFamily: 'IBMPlexSansArabic',
                          fontSize: 12,
                          color: Colors.white.withOpacity(0.5),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),

                      // Code box
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 14),
                        decoration: BoxDecoration(
                          color: AppColors.primaryGold.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: AppColors.primaryGold.withOpacity(0.3),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              referralCode,
                              style: const TextStyle(
                                fontFamily: 'IBMPlexSansArabic',
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primaryGold,
                                letterSpacing: 2,
                              ),
                            ),
                            const SizedBox(width: 12),
                            GestureDetector(
                              onTap: () {
                                Clipboard.setData(
                                    ClipboardData(text: referralCode));
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      langCode == 'ar'
                                          ? 'تم نسخ الكود'
                                          : 'Code copied',
                                      style: const TextStyle(
                                          fontFamily: 'IBMPlexSansArabic'),
                                    ),
                                    backgroundColor: Colors.green,
                                    behavior: SnackBarBehavior.floating,
                                    margin: const EdgeInsets.all(16),
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(10),
                                    ),
                                    duration:
                                        const Duration(seconds: 2),
                                  ),
                                );
                              },
                              child: Icon(
                                Icons.copy,
                                color:
                                    AppColors.primaryGold.withOpacity(0.7),
                                size: 20,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Share button
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            final message = langCode == 'ar'
                                ? 'انضم إلى نادي المستثمرين عبر رابط الدعوة الخاص بي:\n$referralLink'
                                : 'Join Investors Club with my referral link:\n$referralLink';
                            Share.share(message);
                          },
                          icon: const Icon(Icons.share, size: 18),
                          label: Text(
                            langCode == 'ar'
                                ? 'مشاركة الرابط'
                                : 'Share Link',
                            style: const TextStyle(
                              fontFamily: 'IBMPlexSansArabic',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryGold,
                            foregroundColor: AppColors.primaryDark,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
              loading: () =>
                  const LoadingWidget(message: 'جاري التحميل...'),
              error: (e, _) => Text('خطأ: $e'),
            ),

            const SizedBox(height: 24),

            // ── Stats ──
            statsAsync.when(
              data: (stats) => Row(
                children: [
                  _StatBox(
                    label: langCode == 'ar' ? 'المدعوين' : 'Invited',
                    value: '${stats['totalInvited']}',
                    icon: Icons.people_outline,
                  ),
                  const SizedBox(width: 12),
                  _StatBox(
                    label: langCode == 'ar' ? 'مفعّلين' : 'Active',
                    value: '${stats['activeInvited']}',
                    icon: Icons.check_circle_outline,
                  ),
                ],
              ),
              loading: () => const SizedBox.shrink(),
              error: (_, __) => const SizedBox.shrink(),
            ),

            const SizedBox(height: 24),

            // ── Invited Members List ──
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                langCode == 'ar'
                    ? 'الأعضاء المدعوين'
                    : 'Invited Members',
                style: const TextStyle(
                  fontFamily: 'IBMPlexSansArabic',
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 12),

            referralsAsync.when(
              data: (referrals) {
                if (referrals.isEmpty) {
                  return Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(30),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          Icons.group_add_outlined,
                          size: 40,
                          color: Colors.white.withOpacity(0.15),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          langCode == 'ar'
                              ? 'لم تتم أي إحالة بعد'
                              : 'No referrals yet',
                          style: TextStyle(
                            fontFamily: 'IBMPlexSansArabic',
                            fontSize: 14,
                            color: Colors.white.withOpacity(0.4),
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return Column(
                  children: referrals.map((member) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColors.primaryGold.withOpacity(0.08),
                        ),
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 20,
                            backgroundColor:
                                AppColors.primaryGold.withOpacity(0.15),
                            child: Text(
                              member.fullName.isNotEmpty
                                  ? member.fullName[0]
                                  : '?',
                              style: const TextStyle(
                                fontFamily: 'IBMPlexSansArabic',
                                fontWeight: FontWeight.w700,
                                color: AppColors.primaryGold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                Text(
                                  member.fullName,
                                  style: const TextStyle(
                                    fontFamily: 'IBMPlexSansArabic',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  member.createdAt
                                      .toString()
                                      .substring(0, 10),
                                  style: TextStyle(
                                    fontFamily: 'IBMPlexSansArabic',
                                    fontSize: 11,
                                    color:
                                        Colors.white.withOpacity(0.4),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Icon(
                            Icons.check_circle,
                            color: member.status == 'active' ||
                                    member.status == 'vip'
                                ? Colors.greenAccent
                                : Colors.white.withOpacity(0.2),
                            size: 20,
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                );
              },
              loading: () => const LoadingWidget(),
              error: (e, _) => Text('خطأ: $e'),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

class _StatBox extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _StatBox({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: AppColors.primaryGold.withOpacity(0.1),
          ),
        ),
        child: Column(
          children: [
            Icon(icon, color: AppColors.primaryGold, size: 24),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontFamily: 'IBMPlexSansArabic',
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: AppColors.primaryGold,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'IBMPlexSansArabic',
                fontSize: 12,
                color: Colors.white.withOpacity(0.5),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
