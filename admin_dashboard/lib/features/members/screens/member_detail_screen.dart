import 'package:flutter/material.dart';
import '../../../shared/constants/admin_colors.dart';

class MemberDetailScreen extends StatefulWidget {
  final String memberId;
  const MemberDetailScreen({super.key, required this.memberId});

  @override
  State<MemberDetailScreen> createState() => _MemberDetailScreenState();
}

class _MemberDetailScreenState extends State<MemberDetailScreen> {
  bool _isEditing = false;

  // TODO: Fetch from Firestore
  final Map<String, dynamic> _member = {
    'firstName': 'محمد',
    'lastName': 'العمري',
    'email': 'mohammed@email.com',
    'phone': '+966555050930',
    'nationalId': '1098765432',
    'city': 'الرياض',
    'status': 'vip',
    'financialCapacity': 'high',
    'createdAt': '2026-01-15',
    'referralCode': 'INV-M8X2K',
    'referralCount': 5,
    'invitedBy': 'أحمد الشهري',
  };

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Back + Title
          Row(
            children: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back),
              ),
              const SizedBox(width: 8),
              const Text(
                'تفاصيل العضو',
                style: TextStyle(
                  fontFamily: 'IBMPlexSansArabic',
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: AdminColors.textPrimary,
                ),
              ),
              const Spacer(),
              OutlinedButton.icon(
                onPressed: () => setState(() => _isEditing = !_isEditing),
                icon: Icon(_isEditing ? Icons.close : Icons.edit_outlined,
                    size: 18),
                label: Text(_isEditing ? 'إلغاء' : 'تعديل'),
              ),
              if (_isEditing) ...[
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  onPressed: () {
                    // TODO: Save to Firestore
                    setState(() => _isEditing = false);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('تم حفظ التعديلات'),
                        backgroundColor: AdminColors.success,
                      ),
                    );
                  },
                  icon: const Icon(Icons.check, size: 18),
                  label: const Text('حفظ'),
                ),
              ],
            ],
          ),
          const SizedBox(height: 24),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left - Member info
              Expanded(
                flex: 2,
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AdminColors.cardBg,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AdminColors.cardBorder),
                  ),
                  child: Column(
                    children: [
                      // Avatar
                      CircleAvatar(
                        radius: 40,
                        backgroundColor:
                            AdminColors.primaryGold.withOpacity(0.15),
                        child: Text(
                          '${_member['firstName'][0]}${_member['lastName'][0]}',
                          style: const TextStyle(
                            fontFamily: 'IBMPlexSansArabic',
                            fontSize: 28,
                            fontWeight: FontWeight.w700,
                            color: AdminColors.primaryGold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),
                      Text(
                        '${_member['firstName']} ${_member['lastName']}',
                        style: const TextStyle(
                          fontFamily: 'IBMPlexSansArabic',
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 24),

                      _InfoRow(
                        label: 'رقم الهوية',
                        value: _member['nationalId'],
                        icon: Icons.badge_outlined,
                        isLocked: true,
                      ),
                      _InfoRow(
                        label: 'البريد الإلكتروني',
                        value: _member['email'],
                        icon: Icons.email_outlined,
                        editable: _isEditing,
                      ),
                      _InfoRow(
                        label: 'رقم الجوال',
                        value: _member['phone'],
                        icon: Icons.phone_outlined,
                        editable: _isEditing,
                      ),
                      _InfoRow(
                        label: 'المدينة',
                        value: _member['city'],
                        icon: Icons.location_city_outlined,
                        editable: _isEditing,
                      ),
                      _InfoRow(
                        label: 'القدرة المالية',
                        value: _member['financialCapacity'] == 'high'
                            ? 'عالية (VIP)'
                            : 'متوسطة',
                        icon: Icons.account_balance_wallet_outlined,
                      ),
                      _InfoRow(
                        label: 'تاريخ الانضمام',
                        value: _member['createdAt'],
                        icon: Icons.calendar_today_outlined,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 16),

              // Right - Stats & Actions
              Expanded(
                child: Column(
                  children: [
                    // Referral info
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AdminColors.cardBg,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: AdminColors.cardBorder),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'الإحالات',
                            style: TextStyle(
                              fontFamily: 'IBMPlexSansArabic',
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 16),
                          _StatRow(
                            label: 'كود الإحالة',
                            value: _member['referralCode'],
                          ),
                          _StatRow(
                            label: 'عدد المدعوين',
                            value: '${_member['referralCount']}',
                          ),
                          _StatRow(
                            label: 'مدعو بواسطة',
                            value: _member['invitedBy'] ?? 'بدون إحالة',
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Quick actions
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AdminColors.cardBg,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: AdminColors.cardBorder),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'إجراءات سريعة',
                            style: TextStyle(
                              fontFamily: 'IBMPlexSansArabic',
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton.icon(
                              onPressed: () {},
                              icon: const Icon(Icons.lock_reset, size: 18),
                              label: const Text('إعادة كلمة المرور'),
                            ),
                          ),
                          const SizedBox(height: 8),
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton.icon(
                              onPressed: () {},
                              icon: const Icon(Icons.chat_outlined, size: 18),
                              label: const Text('فتح محادثة'),
                            ),
                          ),
                          const SizedBox(height: 8),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: () {},
                              icon: const Icon(Icons.block, size: 18),
                              label: const Text('إيقاف العضوية'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AdminColors.error,
                                foregroundColor: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final bool editable;
  final bool isLocked;

  const _InfoRow({
    required this.label,
    required this.value,
    required this.icon,
    this.editable = false,
    this.isLocked = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AdminColors.primaryGold),
          const SizedBox(width: 12),
          SizedBox(
            width: 120,
            child: Row(
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontFamily: 'IBMPlexSansArabic',
                    fontSize: 13,
                    color: AdminColors.textHint,
                  ),
                ),
                if (isLocked) ...[
                  const SizedBox(width: 4),
                  const Icon(Icons.lock, size: 12, color: AdminColors.warning),
                ],
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: editable
                ? TextFormField(
                    initialValue: value,
                    style: const TextStyle(
                      fontFamily: 'IBMPlexSansArabic',
                      fontSize: 14,
                    ),
                    decoration: const InputDecoration(
                      isDense: true,
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    ),
                  )
                : Text(
                    value,
                    style: TextStyle(
                      fontFamily: 'IBMPlexSansArabic',
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: isLocked
                          ? AdminColors.textSecondary
                          : AdminColors.textPrimary,
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  final String label;
  final String value;
  const _StatRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'IBMPlexSansArabic',
              fontSize: 13,
              color: AdminColors.textHint,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontFamily: 'IBMPlexSansArabic',
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AdminColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
