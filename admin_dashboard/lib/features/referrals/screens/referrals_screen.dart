import 'package:flutter/material.dart';
import '../../../shared/constants/admin_colors.dart';

class ReferralsScreen extends StatelessWidget {
  const ReferralsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: Replace with Firestore
    final referrals = [
      {
        'name': 'محمد العمري',
        'code': 'INV-M8X2K',
        'count': 5,
        'members': ['أحمد الشهري', 'سارة القحطاني', 'خالد السبيعي', 'فاطمة الحربي', 'نورة العتيبي'],
      },
      {
        'name': 'أحمد الشهري',
        'code': 'INV-A3J9P',
        'count': 2,
        'members': ['حسن الغامدي', 'ريم المطيري'],
      },
      {
        'name': 'فاطمة الحربي',
        'code': 'INV-F7R1N',
        'count': 3,
        'members': ['ليلى الدوسري', 'عبدالله الزهراني', 'منى الشمري'],
      },
      {
        'name': 'سارة القحطاني',
        'code': 'INV-S2K5L',
        'count': 0,
        'members': [],
      },
    ];

    final totalReferred = referrals.fold<int>(
        0, (sum, r) => sum + (r['count'] as int));

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'إدارة الإحالات',
                style: TextStyle(
                  fontFamily: 'IBMPlexSansArabic',
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                ),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  // TODO: Export CSV
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('جاري تصدير ملف CSV...'),
                      backgroundColor: AdminColors.success,
                    ),
                  );
                },
                icon: const Icon(Icons.download, size: 18),
                label: const Text('تصدير CSV'),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Stats
          Row(
            children: [
              _ReferralStat(
                title: 'إجمالي الإحالات',
                value: '$totalReferred',
                icon: Icons.people,
                color: AdminColors.chart1,
              ),
              const SizedBox(width: 16),
              _ReferralStat(
                title: 'أعضاء مُحيلين',
                value: '${referrals.where((r) => (r['count'] as int) > 0).length}',
                icon: Icons.card_giftcard,
                color: AdminColors.chart3,
              ),
              const SizedBox(width: 16),
              _ReferralStat(
                title: 'أعلى مُحيل',
                value: referrals.isNotEmpty
                    ? referrals.reduce((a, b) =>
                        (a['count'] as int) >= (b['count'] as int)
                            ? a
                            : b)['name'] as String
                    : '-',
                icon: Icons.star,
                color: AdminColors.chart5,
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Table
          Container(
            decoration: BoxDecoration(
              color: AdminColors.cardBg,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AdminColors.cardBorder),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: DataTable(
                columnSpacing: 40,
                headingRowColor:
                    WidgetStateProperty.all(AdminColors.tableHeader),
                columns: const [
                  DataColumn(label: Text('العضو المُحيل')),
                  DataColumn(label: Text('كود الإحالة')),
                  DataColumn(label: Text('عدد المدعوين')),
                  DataColumn(label: Text('المدعوين')),
                ],
                rows: referrals.map((r) {
                  return DataRow(cells: [
                    DataCell(Row(
                      children: [
                        CircleAvatar(
                          radius: 16,
                          backgroundColor:
                              AdminColors.primaryGold.withOpacity(0.15),
                          child: Text(
                            (r['name'] as String)[0],
                            style: const TextStyle(
                              fontFamily: 'IBMPlexSansArabic',
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: AdminColors.primaryGold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          r['name'] as String,
                          style: const TextStyle(
                            fontFamily: 'IBMPlexSansArabic',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    )),
                    DataCell(
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: AdminColors.pageBg,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          r['code'] as String,
                          style: const TextStyle(
                            fontFamily: 'IBMPlexSansArabic',
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                    ),
                    DataCell(Text(
                      '${r['count']}',
                      style: const TextStyle(
                        fontFamily: 'IBMPlexSansArabic',
                        fontWeight: FontWeight.w700,
                        color: AdminColors.primaryGold,
                      ),
                    )),
                    DataCell(
                      (r['members'] as List).isEmpty
                          ? const Text(
                              'لا يوجد',
                              style: TextStyle(color: AdminColors.textHint),
                            )
                          : Wrap(
                              spacing: 4,
                              children: (r['members'] as List)
                                  .take(3)
                                  .map((m) => Chip(
                                        label: Text(m,
                                            style: const TextStyle(
                                                fontSize: 11)),
                                        visualDensity: VisualDensity.compact,
                                        materialTapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                      ))
                                  .toList()
                                ..addAll(
                                  (r['members'] as List).length > 3
                                      ? [
                                          Chip(
                                            label: Text(
                                              '+${(r['members'] as List).length - 3}',
                                              style:
                                                  const TextStyle(fontSize: 11),
                                            ),
                                            visualDensity:
                                                VisualDensity.compact,
                                          )
                                        ]
                                      : [],
                                ),
                            ),
                    ),
                  ]);
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ReferralStat extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _ReferralStat({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AdminColors.cardBg,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AdminColors.cardBorder),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 14),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    fontFamily: 'IBMPlexSansArabic',
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: AdminColors.textPrimary,
                  ),
                ),
                Text(
                  title,
                  style: const TextStyle(
                    fontFamily: 'IBMPlexSansArabic',
                    fontSize: 12,
                    color: AdminColors.textHint,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
