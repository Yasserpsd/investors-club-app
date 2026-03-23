import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../shared/constants/admin_colors.dart';

class MembersScreen extends StatefulWidget {
  const MembersScreen({super.key});

  @override
  State<MembersScreen> createState() => _MembersScreenState();
}

class _MembersScreenState extends State<MembersScreen> {
  String _searchQuery = '';
  String _statusFilter = 'all';
  final _searchController = TextEditingController();

  // TODO: Replace with Firestore stream
  final List<Map<String, dynamic>> _members = [
    {
      'uid': '001',
      'firstName': 'محمد',
      'lastName': 'العمري',
      'email': 'mohammed@email.com',
      'phone': '+966555050930',
      'nationalId': '1098765432',
      'city': 'الرياض',
      'status': 'vip',
      'financialCapacity': 'high',
      'createdAt': '2026-01-15',
      'referralCount': 5,
    },
    {
      'uid': '002',
      'firstName': 'أحمد',
      'lastName': 'الشهري',
      'email': 'ahmed@email.com',
      'phone': '+966501234567',
      'nationalId': '1087654321',
      'city': 'جدة',
      'status': 'active',
      'financialCapacity': 'medium',
      'createdAt': '2026-02-20',
      'referralCount': 2,
    },
    {
      'uid': '003',
      'firstName': 'سارة',
      'lastName': 'القحطاني',
      'email': 'sara@email.com',
      'phone': '+966509876543',
      'nationalId': '1076543210',
      'city': 'الدمام',
      'status': 'active',
      'financialCapacity': 'medium',
      'createdAt': '2026-03-10',
      'referralCount': 0,
    },
    {
      'uid': '004',
      'firstName': 'خالد',
      'lastName': 'السبيعي',
      'email': 'khaled@email.com',
      'phone': '+966555111222',
      'nationalId': '1065432109',
      'city': 'الرياض',
      'status': 'suspended',
      'financialCapacity': 'high',
      'createdAt': '2026-03-15',
      'referralCount': 1,
    },
    {
      'uid': '005',
      'firstName': 'فاطمة',
      'lastName': 'الحربي',
      'email': 'fatima@email.com',
      'phone': '+966508887776',
      'nationalId': '2054321098',
      'city': 'مكة',
      'status': 'active',
      'financialCapacity': 'medium',
      'createdAt': '2026-03-20',
      'referralCount': 3,
    },
  ];

  List<Map<String, dynamic>> get _filteredMembers {
    return _members.where((m) {
      final matchesSearch = _searchQuery.isEmpty ||
          '${m['firstName']} ${m['lastName']}'
              .toLowerCase()
              .contains(_searchQuery.toLowerCase()) ||
          m['email'].toString().toLowerCase().contains(_searchQuery.toLowerCase()) ||
          m['phone'].toString().contains(_searchQuery) ||
          m['nationalId'].toString().contains(_searchQuery);
      final matchesStatus =
          _statusFilter == 'all' || m['status'] == _statusFilter;
      return matchesSearch && matchesStatus;
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'إدارة الأعضاء',
                    style: TextStyle(
                      fontFamily: 'IBMPlexSansArabic',
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: AdminColors.textPrimary,
                    ),
                  ),
                  Text(
                    '${_members.length} عضو مسجل',
                    style: const TextStyle(
                      fontFamily: 'IBMPlexSansArabic',
                      fontSize: 14,
                      color: AdminColors.textHint,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Filters bar
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AdminColors.cardBg,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AdminColors.cardBorder),
            ),
            child: Row(
              children: [
                // Search
                Expanded(
                  flex: 3,
                  child: TextField(
                    controller: _searchController,
                    onChanged: (v) => setState(() => _searchQuery = v),
                    decoration: InputDecoration(
                      hintText: 'بحث بالاسم، البريد، الجوال، أو الهوية...',
                      prefixIcon: const Icon(Icons.search, size: 20),
                      suffixIcon: _searchQuery.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear, size: 18),
                              onPressed: () {
                                _searchController.clear();
                                setState(() => _searchQuery = '');
                              },
                            )
                          : null,
                      contentPadding: const EdgeInsets.symmetric(vertical: 0),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                // Status filter
                Expanded(
                  flex: 1,
                  child: DropdownButtonFormField<String>(
                    value: _statusFilter,
                    decoration: const InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'all', child: Text('الكل')),
                      DropdownMenuItem(value: 'active', child: Text('نشط')),
                      DropdownMenuItem(value: 'vip', child: Text('VIP')),
                      DropdownMenuItem(
                          value: 'suspended', child: Text('موقوف')),
                    ],
                    onChanged: (v) => setState(() => _statusFilter = v!),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Members table
          Container(
            decoration: BoxDecoration(
              color: AdminColors.cardBg,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AdminColors.cardBorder),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: DataTable(
                columnSpacing: 20,
                headingRowColor:
                    WidgetStateProperty.all(AdminColors.tableHeader),
                columns: const [
                  DataColumn(label: Text('العضو')),
                  DataColumn(label: Text('الجوال')),
                  DataColumn(label: Text('المدينة')),
                  DataColumn(label: Text('الحالة')),
                  DataColumn(label: Text('الإحالات')),
                  DataColumn(label: Text('تاريخ الانضمام')),
                  DataColumn(label: Text('إجراءات')),
                ],
                rows: _filteredMembers.map((m) {
                  return DataRow(
                    cells: [
                      // Name + Email
                      DataCell(
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 16,
                              backgroundColor:
                                  AdminColors.primaryGold.withOpacity(0.15),
                              child: Text(
                                m['firstName'][0],
                                style: const TextStyle(
                                  fontFamily: 'IBMPlexSansArabic',
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: AdminColors.primaryGold,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '${m['firstName']} ${m['lastName']}',
                                  style: const TextStyle(
                                    fontFamily: 'IBMPlexSansArabic',
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  m['email'],
                                  style: const TextStyle(
                                    fontFamily: 'IBMPlexSansArabic',
                                    fontSize: 11,
                                    color: AdminColors.textHint,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      DataCell(Text(m['phone'])),
                      DataCell(Text(m['city'])),
                      // Status badge
                      DataCell(_StatusBadge(status: m['status'])),
                      DataCell(Text('${m['referralCount']}')),
                      DataCell(Text(m['createdAt'])),
                      // Actions
                      DataCell(
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.visibility_outlined,
                                  size: 18),
                              color: AdminColors.info,
                              tooltip: 'عرض',
                              onPressed: () =>
                                  context.go('/members/${m['uid']}'),
                            ),
                            IconButton(
                              icon: const Icon(Icons.lock_reset, size: 18),
                              color: AdminColors.warning,
                              tooltip: 'إعادة كلمة المرور',
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                        'تم إرسال رابط إعادة التعيين لـ ${m['email']}'),
                                    backgroundColor: AdminColors.success,
                                  ),
                                );
                              },
                            ),
                            IconButton(
                              icon: Icon(
                                m['status'] == 'suspended'
                                    ? Icons.check_circle_outline
                                    : Icons.block,
                                size: 18,
                              ),
                              color: m['status'] == 'suspended'
                                  ? AdminColors.success
                                  : AdminColors.error,
                              tooltip: m['status'] == 'suspended'
                                  ? 'تفعيل'
                                  : 'إيقاف',
                              onPressed: () {
                                // TODO: Toggle status in Firestore
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;
  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color fg;
    String label;
    switch (status) {
      case 'vip':
        bg = AdminColors.primaryGold.withOpacity(0.15);
        fg = AdminColors.primaryGold;
        label = 'VIP';
        break;
      case 'suspended':
        bg = AdminColors.error.withOpacity(0.1);
        fg = AdminColors.error;
        label = 'موقوف';
        break;
      default:
        bg = AdminColors.success.withOpacity(0.1);
        fg = AdminColors.success;
        label = 'نشط';
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
