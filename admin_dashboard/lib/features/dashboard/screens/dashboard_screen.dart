import 'package:flutter/material.dart';
import '../../../shared/constants/admin_colors.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Page title
          const Text(
            'لوحة الإحصائيات',
            style: TextStyle(
              fontFamily: 'IBMPlexSansArabic',
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: AdminColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'نظرة عامة على نادي المستثمرين',
            style: TextStyle(
              fontFamily: 'IBMPlexSansArabic',
              fontSize: 14,
              color: AdminColors.textHint,
            ),
          ),
          const SizedBox(height: 24),

          // ── Stats Cards ─────────────────────────────
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              _StatCard(
                title: 'إجمالي الأعضاء',
                value: '245',
                icon: Icons.people,
                color: AdminColors.chart1,
                trend: '+12%',
                trendUp: true,
              ),
              _StatCard(
                title: 'أعضاء نشطين',
                value: '198',
                icon: Icons.verified_user,
                color: AdminColors.chart3,
                trend: '+5%',
                trendUp: true,
              ),
              _StatCard(
                title: 'جدد (30 يوم)',
                value: '32',
                icon: Icons.person_add,
                color: AdminColors.chart4,
                trend: '+18%',
                trendUp: true,
              ),
              _StatCard(
                title: 'العروض المنشورة',
                value: '15',
                icon: Icons.business_center,
                color: AdminColors.chart2,
              ),
              _StatCard(
                title: 'محادثات مفتوحة',
                value: '8',
                icon: Icons.chat,
                color: AdminColors.chart5,
              ),
              _StatCard(
                title: 'إحالات ناجحة',
                value: '67',
                icon: Icons.card_giftcard,
                color: AdminColors.success,
                trend: '+23%',
                trendUp: true,
              ),
            ],
          ),

          const SizedBox(height: 32),

          // ── Recent Members & Offers ──────────────────
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Recent members
              Expanded(
                child: _DashboardCard(
                  title: 'أحدث الأعضاء',
                  child: Column(
                    children: [
                      _RecentMemberRow(
                        name: 'محمد العمري',
                        email: 'mohammed@email.com',
                        date: '22 مارس 2026',
                        status: 'active',
                      ),
                      _RecentMemberRow(
                        name: 'أحمد الشهري',
                        email: 'ahmed@email.com',
                        date: '20 مارس 2026',
                        status: 'vip',
                      ),
                      _RecentMemberRow(
                        name: 'سارة القحطاني',
                        email: 'sara@email.com',
                        date: '18 مارس 2026',
                        status: 'active',
                      ),
                      _RecentMemberRow(
                        name: 'خالد السبيعي',
                        email: 'khaled@email.com',
                        date: '15 مارس 2026',
                        status: 'active',
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 16),
              // Recent activity
              Expanded(
                child: _DashboardCard(
                  title: 'النشاط الأخير',
                  child: Column(
                    children: [
                      _ActivityRow(
                        icon: Icons.person_add,
                        text: 'عضو جديد: خالد السبيعي',
                        time: 'منذ 3 ساعات',
                        color: AdminColors.chart4,
                      ),
                      _ActivityRow(
                        icon: Icons.business_center,
                        text: 'عرض جديد: فرصة في قطاع التقنية',
                        time: 'منذ 5 ساعات',
                        color: AdminColors.chart1,
                      ),
                      _ActivityRow(
                        icon: Icons.chat,
                        text: 'رسالة جديدة من محمد العمري',
                        time: 'منذ يوم',
                        color: AdminColors.chart5,
                      ),
                      _ActivityRow(
                        icon: Icons.card_giftcard,
                        text: 'إحالة ناجحة: أحمد ← سارة',
                        time: 'منذ يومين',
                        color: AdminColors.success,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Stat Card Widget ──────────────────────────────────
class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final String? trend;
  final bool trendUp;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    this.trend,
    this.trendUp = true,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 220,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AdminColors.cardBg,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AdminColors.cardBorder),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: color, size: 22),
                ),
                if (trend != null)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: (trendUp ? AdminColors.success : AdminColors.error)
                          .withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          trendUp
                              ? Icons.trending_up
                              : Icons.trending_down,
                          size: 14,
                          color: trendUp
                              ? AdminColors.success
                              : AdminColors.error,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          trend!,
                          style: TextStyle(
                            fontFamily: 'IBMPlexSansArabic',
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: trendUp
                                ? AdminColors.success
                                : AdminColors.error,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              value,
              style: const TextStyle(
                fontFamily: 'IBMPlexSansArabic',
                fontSize: 28,
                fontWeight: FontWeight.w700,
                color: AdminColors.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: const TextStyle(
                fontFamily: 'IBMPlexSansArabic',
                fontSize: 13,
                color: AdminColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Dashboard Card ────────────────────────────────────
class _DashboardCard extends StatelessWidget {
  final String title;
  final Widget child;

  const _DashboardCard({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AdminColors.cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AdminColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontFamily: 'IBMPlexSansArabic',
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AdminColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}

// ── Recent Member Row ─────────────────────────────────
class _RecentMemberRow extends StatelessWidget {
  final String name;
  final String email;
  final String date;
  final String status;

  const _RecentMemberRow({
    required this.name,
    required this.email,
    required this.date,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: AdminColors.primaryGold.withOpacity(0.15),
            child: Text(
              name[0],
              style: const TextStyle(
                fontFamily: 'IBMPlexSansArabic',
                fontWeight: FontWeight.w700,
                color: AdminColors.primaryGold,
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontFamily: 'IBMPlexSansArabic',
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AdminColors.textPrimary,
                  ),
                ),
                Text(
                  email,
                  style: const TextStyle(
                    fontFamily: 'IBMPlexSansArabic',
                    fontSize: 11,
                    color: AdminColors.textHint,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: status == 'vip'
                  ? AdminColors.primaryGold.withOpacity(0.15)
                  : AdminColors.success.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              status == 'vip' ? 'VIP' : 'نشط',
              style: TextStyle(
                fontFamily: 'IBMPlexSansArabic',
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: status == 'vip'
                    ? AdminColors.primaryGold
                    : AdminColors.success,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Activity Row ──────────────────────────────────────
class _ActivityRow extends StatelessWidget {
  final IconData icon;
  final String text;
  final String time;
  final Color color;

  const _ActivityRow({
    required this.icon,
    required this.text,
    required this.time,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 16, color: color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontFamily: 'IBMPlexSansArabic',
                fontSize: 13,
                color: AdminColors.textPrimary,
              ),
            ),
          ),
          Text(
            time,
            style: const TextStyle(
              fontFamily: 'IBMPlexSansArabic',
              fontSize: 11,
              color: AdminColors.textHint,
            ),
          ),
        ],
      ),
    );
  }
}
