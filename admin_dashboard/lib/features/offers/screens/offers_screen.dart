import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../shared/constants/admin_colors.dart';
import '../../../app/admin_routes.dart';

class OffersScreen extends StatefulWidget {
  const OffersScreen({super.key});

  @override
  State<OffersScreen> createState() => _OffersScreenState();
}

class _OffersScreenState extends State<OffersScreen> {
  String _statusFilter = 'all';

  // TODO: Replace with Firestore
  final List<Map<String, dynamic>> _offers = [
    {
      'offerId': '1',
      'titleAr': 'فرصة استثمارية في قطاع التقنية',
      'category': 'تقنية',
      'status': 'published',
      'isVIP': true,
      'publishDate': '2026-03-22',
    },
    {
      'offerId': '2',
      'titleAr': 'مشروع عقاري في الرياض',
      'category': 'عقارات',
      'status': 'published',
      'isVIP': false,
      'publishDate': '2026-03-20',
    },
    {
      'offerId': '3',
      'titleAr': 'فرنشايز مطاعم - امتياز تجاري',
      'category': 'أغذية',
      'status': 'draft',
      'isVIP': false,
      'publishDate': '2026-03-15',
    },
    {
      'offerId': '4',
      'titleAr': 'مبادرة 5 دقائق – الموسم الثاني',
      'category': 'مبادرات',
      'status': 'published',
      'isVIP': false,
      'publishDate': '2026-03-10',
    },
  ];

  List<Map<String, dynamic>> get _filtered {
    if (_statusFilter == 'all') return _offers;
    return _offers.where((o) => o['status'] == _statusFilter).toList();
  }

  @override
  Widget build(BuildContext context) {
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
                'إدارة العروض الاستثمارية',
                style: TextStyle(
                  fontFamily: 'IBMPlexSansArabic',
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                ),
              ),
              ElevatedButton.icon(
                onPressed: () => context.go(AdminRoutes.offerForm),
                icon: const Icon(Icons.add, size: 20),
                label: const Text('إضافة عرض'),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Filters
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AdminColors.cardBg,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AdminColors.cardBorder),
            ),
            child: Row(
              children: [
                _FilterChip(
                  label: 'الكل (${_offers.length})',
                  selected: _statusFilter == 'all',
                  onTap: () => setState(() => _statusFilter = 'all'),
                ),
                const SizedBox(width: 8),
                _FilterChip(
                  label:
                      'منشور (${_offers.where((o) => o['status'] == 'published').length})',
                  selected: _statusFilter == 'published',
                  onTap: () => setState(() => _statusFilter = 'published'),
                ),
                const SizedBox(width: 8),
                _FilterChip(
                  label:
                      'مسودة (${_offers.where((o) => o['status'] == 'draft').length})',
                  selected: _statusFilter == 'draft',
                  onTap: () => setState(() => _statusFilter = 'draft'),
                ),
                const SizedBox(width: 8),
                _FilterChip(
                  label:
                      'مخفي (${_offers.where((o) => o['status'] == 'hidden').length})',
                  selected: _statusFilter == 'hidden',
                  onTap: () => setState(() => _statusFilter = 'hidden'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Offers table
          Container(
            decoration: BoxDecoration(
              color: AdminColors.cardBg,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AdminColors.cardBorder),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: DataTable(
                columnSpacing: 30,
                headingRowColor:
                    WidgetStateProperty.all(AdminColors.tableHeader),
                columns: const [
                  DataColumn(label: Text('العرض')),
                  DataColumn(label: Text('التصنيف')),
                  DataColumn(label: Text('الحالة')),
                  DataColumn(label: Text('VIP')),
                  DataColumn(label: Text('تاريخ النشر')),
                  DataColumn(label: Text('إجراءات')),
                ],
                rows: _filtered.map((o) {
                  return DataRow(cells: [
                    DataCell(Text(
                      o['titleAr'],
                      style: const TextStyle(
                        fontFamily: 'IBMPlexSansArabic',
                        fontWeight: FontWeight.w600,
                      ),
                    )),
                    DataCell(Text(o['category'])),
                    DataCell(_OfferStatusBadge(status: o['status'])),
                    DataCell(
                      o['isVIP'] == true
                          ? Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color:
                                    AdminColors.primaryGold.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Text(
                                'VIP',
                                style: TextStyle(
                                  fontFamily: 'IBMPlexSansArabic',
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: AdminColors.primaryGold,
                                ),
                              ),
                            )
                          : const Text('-'),
                    ),
                    DataCell(Text(o['publishDate'])),
                    DataCell(Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit_outlined, size: 18),
                          color: AdminColors.info,
                          tooltip: 'تعديل',
                          onPressed: () =>
                              context.go('/offers/form/${o['offerId']}'),
                        ),
                        IconButton(
                          icon: Icon(
                            o['status'] == 'published'
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            size: 18,
                          ),
                          color: AdminColors.warning,
                          tooltip: o['status'] == 'published'
                              ? 'إخفاء'
                              : 'نشر',
                          onPressed: () {
                            // TODO: Toggle status
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete_outline, size: 18),
                          color: AdminColors.error,
                          tooltip: 'حذف',
                          onPressed: () {
                            // TODO: Delete offer
                          },
                        ),
                      ],
                    )),
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

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: selected
              ? AdminColors.primaryGold
              : AdminColors.pageBg,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected
                ? AdminColors.primaryGold
                : AdminColors.cardBorder,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontFamily: 'IBMPlexSansArabic',
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: selected
                ? AdminColors.primaryDark
                : AdminColors.textSecondary,
          ),
        ),
      ),
    );
  }
}

class _OfferStatusBadge extends StatelessWidget {
  final String status;
  const _OfferStatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color fg;
    String label;
    switch (status) {
      case 'published':
        bg = AdminColors.success.withOpacity(0.1);
        fg = AdminColors.success;
        label = 'منشور';
        break;
      case 'draft':
        bg = AdminColors.warning.withOpacity(0.1);
        fg = AdminColors.warning;
        label = 'مسودة';
        break;
      default:
        bg = AdminColors.textHint.withOpacity(0.1);
        fg = AdminColors.textHint;
        label = 'مخفي';
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontFamily: 'IBMPlexSansArabic',
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: fg,
        ),
      ),
    );
  }
}
