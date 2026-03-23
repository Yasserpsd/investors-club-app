import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../shared/constants/app_colors.dart';
import '../../../app/providers.dart';
import '../../../app/routes.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  bool _isEditing = false;

  // TODO: Replace with actual member data from Firestore
  final Map<String, String> _memberData = {
    'firstName': 'محمد',
    'lastName': 'العمري',
    'email': 'mohammed@email.com',
    'phone': '+966555050930',
    'nationalId': '1098765432',
    'city': 'الرياض',
    'financialCapacity': 'high',
    'referralCode': 'INV-M8X2K',
  };

  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _cityController;

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController(text: _memberData['firstName']);
    _lastNameController = TextEditingController(text: _memberData['lastName']);
    _emailController = TextEditingController(text: _memberData['email']);
    _phoneController = TextEditingController(text: _memberData['phone']);
    _cityController = TextEditingController(text: _memberData['city']);
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _cityController.dispose();
    super.dispose();
  }

  Future<void> _saveChanges() async {
    // TODO: Update Firestore
    setState(() => _isEditing = false);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('تم حفظ التغييرات بنجاح'),
          backgroundColor: AppColors.success,
        ),
      );
    }
  }

  void _toggleLanguage() {
    ref.read(languageProvider.notifier).toggleLanguage();
  }

  Future<void> _handleLogout() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text(
          'تسجيل الخروج',
          style: TextStyle(fontFamily: 'IBMPlexSansArabic'),
        ),
        content: const Text(
          'هل أنت متأكد من تسجيل الخروج؟',
          style: TextStyle(fontFamily: 'IBMPlexSansArabic'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
            ),
            child: const Text('خروج'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      // TODO: Firebase Auth sign out
      context.go(AppRoutes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    final locale = ref.watch(languageProvider);
    final langCode = locale.languageCode;
    final isArabic = langCode == 'ar';

    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      body: CustomScrollView(
        slivers: [
          // Header
          SliverToBoxAdapter(
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: Column(
                  children: [
                    // Avatar
                    Container(
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.primaryGold,
                          width: 2.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primaryGold.withOpacity(0.2),
                            blurRadius: 15,
                          ),
                        ],
                      ),
                      child: ClipOval(
                        child: Container(
                          color: AppColors.primaryGold.withOpacity(0.15),
                          child: Center(
                            child: Text(
                              '${_memberData['firstName']?[0] ?? ''}${_memberData['lastName']?[0] ?? ''}',
                              style: const TextStyle(
                                fontFamily: 'IBMPlexSansArabic',
                                fontSize: 32,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primaryGold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      '${_memberData['firstName']} ${_memberData['lastName']}',
                      style: const TextStyle(
                        fontFamily: 'IBMPlexSansArabic',
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        gradient: AppColors.goldGradient,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        _memberData['financialCapacity'] == 'high'
                            ? 'VIP'
                            : (isArabic ? 'عضو' : 'Member'),
                        style: const TextStyle(
                          fontFamily: 'IBMPlexSansArabic',
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primaryDark,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),

          // Body card
          SliverToBoxAdapter(
            child: Container(
              decoration: const BoxDecoration(
                color: AppColors.backgroundLight,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(28),
                  topRight: Radius.circular(28),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Edit toggle
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          isArabic ? 'المعلومات الشخصية' : 'Personal Info',
                          style: const TextStyle(
                            fontFamily: 'IBMPlexSansArabic',
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        TextButton.icon(
                          onPressed: () {
                            if (_isEditing) {
                              _saveChanges();
                            } else {
                              setState(() => _isEditing = true);
                            }
                          },
                          icon: Icon(
                            _isEditing ? Icons.check : Icons.edit_outlined,
                            size: 18,
                          ),
                          label: Text(
                            _isEditing
                                ? (isArabic ? 'حفظ' : 'Save')
                                : (isArabic ? 'تعديل' : 'Edit'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Info fields
                    _buildField(
                      icon: Icons.person_outlined,
                      label: isArabic ? 'الاسم الأول' : 'First Name',
                      controller: _firstNameController,
                      editable: _isEditing,
                    ),
                    _buildField(
                      icon: Icons.person_outlined,
                      label: isArabic ? 'الاسم الأخير' : 'Last Name',
                      controller: _lastNameController,
                      editable: _isEditing,
                    ),
                    _buildField(
                      icon: Icons.badge_outlined,
                      label: isArabic ? 'رقم الهوية' : 'National ID',
                      value: _memberData['nationalId'] ?? '',
                      editable: false, // Never editable
                      isLocked: true,
                    ),
                    _buildField(
                      icon: Icons.email_outlined,
                      label: isArabic ? 'البريد الإلكتروني' : 'Email',
                      controller: _emailController,
                      editable: _isEditing,
                    ),
                    _buildField(
                      icon: Icons.phone_outlined,
                      label: isArabic ? 'رقم الجوال' : 'Phone',
                      controller: _phoneController,
                      editable: _isEditing,
                    ),
                    _buildField(
                      icon: Icons.location_city_outlined,
                      label: isArabic ? 'المدينة' : 'City',
                      controller: _cityController,
                      editable: _isEditing,
                    ),

                    const SizedBox(height: 24),

                    // ── Settings ─────────────────────
                    Text(
                      isArabic ? 'الإعدادات' : 'Settings',
                      style: const TextStyle(
                        fontFamily: 'IBMPlexSansArabic',
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Language toggle
                    _buildSettingsTile(
                      icon: Icons.language,
                      title: isArabic ? 'اللغة' : 'Language',
                      subtitle: isArabic ? 'العربية' : 'English',
                      trailing: Switch(
                        value: !isArabic,
                        activeColor: AppColors.primaryGold,
                        onChanged: (_) => _toggleLanguage(),
                      ),
                    ),

                    // Referral
                    _buildSettingsTile(
                      icon: Icons.card_giftcard_outlined,
                      title: isArabic ? 'دعوة صديق' : 'Invite Friend',
                      subtitle: isArabic
                          ? 'كود الإحالة: ${_memberData['referralCode']}'
                          : 'Referral: ${_memberData['referralCode']}',
                      onTap: () => context.push(AppRoutes.referral),
                    ),

                    const SizedBox(height: 8),

                    // Logout
                    _buildSettingsTile(
                      icon: Icons.logout,
                      title: isArabic ? 'تسجيل الخروج' : 'Logout',
                      subtitle: '',
                      iconColor: AppColors.error,
                      titleColor: AppColors.error,
                      onTap: _handleLogout,
                    ),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildField({
    required IconData icon,
    required String label,
    TextEditingController? controller,
    String? value,
    bool editable = false,
    bool isLocked = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.backgroundWhite,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isLocked
                ? AppColors.warning.withOpacity(0.3)
                : (editable ? AppColors.primaryGold.withOpacity(0.3) : AppColors.border),
          ),
        ),
        child: Row(
          children: [
            Icon(icon, size: 20, color: AppColors.primaryGold),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        label,
                        style: const TextStyle(
                          fontFamily: 'IBMPlexSansArabic',
                          fontSize: 11,
                          color: AppColors.textHint,
                        ),
                      ),
                      if (isLocked) ...[
                        const SizedBox(width: 4),
                        const Icon(Icons.lock, size: 12, color: AppColors.warning),
                      ],
                    ],
                  ),
                  const SizedBox(height: 2),
                  editable && controller != null
                      ? TextField(
                          controller: controller,
                          style: const TextStyle(
                            fontFamily: 'IBMPlexSansArabic',
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textPrimary,
                          ),
                          decoration: const InputDecoration(
                            isDense: true,
                            contentPadding: EdgeInsets.zero,
                            border: InputBorder.none,
                          ),
                        )
                      : Text(
                          value ?? controller?.text ?? '',
                          style: TextStyle(
                            fontFamily: 'IBMPlexSansArabic',
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: isLocked
                                ? AppColors.textSecondary
                                : AppColors.textPrimary,
                          ),
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    required String subtitle,
    Widget? trailing,
    VoidCallback? onTap,
    Color? iconColor,
    Color? titleColor,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.backgroundWhite,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(icon, size: 22, color: iconColor ?? AppColors.primaryGold),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontFamily: 'IBMPlexSansArabic',
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: titleColor ?? AppColors.textPrimary,
                      ),
                    ),
                    if (subtitle.isNotEmpty)
                      Text(
                        subtitle,
                        style: const TextStyle(
                          fontFamily: 'IBMPlexSansArabic',
                          fontSize: 12,
                          color: AppColors.textHint,
                        ),
                      ),
                  ],
                ),
              ),
              trailing ??
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: AppColors.textHint.withOpacity(0.5),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
