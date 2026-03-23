import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../shared/constants/app_colors.dart';
import '../../../shared/widgets/loading_widget.dart';
import '../../../app/providers.dart';
import '../services/profile_service.dart';
import '../../auth/services/auth_service.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  bool _isEditing = false;
  bool _isSaving = false;

  final _fullNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _cityController = TextEditingController();

  @override
  void dispose() {
    _fullNameController.dispose();
    _phoneController.dispose();
    _cityController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    setState(() => _isSaving = true);

    try {
      await ref.read(profileServiceProvider).updateProfile(
            uid: uid,
            fullName: _fullNameController.text.trim(),
            phone: _phoneController.text.trim(),
            city: _cityController.text.trim(),
          );

      if (mounted) {
        setState(() => _isEditing = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              'تم حفظ التغييرات بنجاح',
              style: TextStyle(fontFamily: 'IBMPlexSansArabic'),
            ),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.all(16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'خطأ: $e',
              style: const TextStyle(fontFamily: 'IBMPlexSansArabic'),
            ),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.all(16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  Future<void> _handleLogout() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'تسجيل الخروج',
          style: TextStyle(
            fontFamily: 'IBMPlexSansArabic',
            fontWeight: FontWeight.w700,
          ),
          textAlign: TextAlign.center,
        ),
        content: const Text(
          'هل أنت متأكد من تسجيل الخروج؟',
          style: TextStyle(fontFamily: 'IBMPlexSansArabic'),
          textAlign: TextAlign.center,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text(
              'إلغاء',
              style: TextStyle(fontFamily: 'IBMPlexSansArabic'),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'خروج',
              style: TextStyle(
                fontFamily: 'IBMPlexSansArabic',
                color: AppColors.error,
              ),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      await ref.read(authServiceProvider).signOut();
      if (mounted) context.go('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    final langCode = ref.watch(languageProvider).languageCode;
    final profileAsync = ref.watch(memberProfileProvider);

    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      appBar: AppBar(
        backgroundColor: AppColors.primaryDark,
        elevation: 0,
        title: Text(
          langCode == 'ar' ? 'حسابي' : 'My Account',
          style: const TextStyle(
            fontFamily: 'IBMPlexSansArabic',
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        actions: [
          if (!_isEditing)
            IconButton(
              onPressed: () {
                final member = profileAsync.value;
                if (member != null) {
                  _fullNameController.text = member.fullName;
                  _phoneController.text = member.phone;
                  _cityController.text = member.city;
                  setState(() => _isEditing = true);
                }
              },
              icon: const Icon(Icons.edit_outlined,
                  color: AppColors.primaryGold, size: 20),
            )
          else ...[
            IconButton(
              onPressed: () => setState(() => _isEditing = false),
              icon: Icon(Icons.close,
                  color: Colors.white.withOpacity(0.5), size: 20),
            ),
            IconButton(
              onPressed: _isSaving ? null : _saveProfile,
              icon: const Icon(Icons.check,
                  color: AppColors.primaryGold, size: 22),
            ),
          ],
        ],
      ),
      body: profileAsync.when(
        data: (member) {
          if (member == null) {
            return const Center(
              child: Text(
                'لم يتم العثور على البيانات',
                style: TextStyle(
                  fontFamily: 'IBMPlexSansArabic',
                  color: Colors.white54,
                ),
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // Avatar
                CircleAvatar(
                  radius: 40,
                  backgroundColor: AppColors.primaryGold.withOpacity(0.15),
                  child: Text(
                    member.fullName.isNotEmpty
                        ? member.fullName[0]
                        : '?',
                    style: const TextStyle(
                      fontFamily: 'IBMPlexSansArabic',
                      fontSize: 30,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryGold,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  member.fullName,
                  style: const TextStyle(
                    fontFamily: 'IBMPlexSansArabic',
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: member.status == 'vip'
                        ? AppColors.primaryGold.withOpacity(0.15)
                        : Colors.green.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    member.status == 'vip' ? 'VIP' : 'عضو نشط',
                    style: TextStyle(
                      fontFamily: 'IBMPlexSansArabic',
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: member.status == 'vip'
                          ? AppColors.primaryGold
                          : Colors.greenAccent,
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // Info card
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppColors.primaryGold.withOpacity(0.1),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                                ? 'المعلومات الشخصية'
                                : 'Personal Information',
                            style: const TextStyle(
                              fontFamily: 'IBMPlexSansArabic',
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      _buildField(
                        icon: Icons.person_outline,
                        label: langCode == 'ar' ? 'الاسم' : 'Name',
                        value: member.fullName,
                        controller:
                            _isEditing ? _fullNameController : null,
                      ),
                      _buildField(
                        icon: Icons.email_outlined,
                        label: langCode == 'ar'
                            ? 'البريد الإلكتروني'
                            : 'Email',
                        value: member.email,
                      ),
                      _buildField(
                        icon: Icons.phone_outlined,
                        label: langCode == 'ar'
                            ? 'رقم الجوال'
                            : 'Phone',
                        value: member.phone,
                        controller:
                            _isEditing ? _phoneController : null,
                      ),
                      _buildField(
                        icon: Icons.location_city_outlined,
                        label: langCode == 'ar' ? 'المدينة' : 'City',
                        value: member.city,
                        controller:
                            _isEditing ? _cityController : null,
                      ),
                      _buildField(
                        icon: Icons.badge_outlined,
                        label: langCode == 'ar'
                            ? 'رقم الهوية'
                            : 'National ID',
                        value: member.nationalId,
                        isLocked: true,
                      ),
                      _buildField(
                        icon: Icons.account_balance_wallet_outlined,
                        label: langCode == 'ar'
                            ? 'القدرة المالية'
                            : 'Financial',
                        value: member.investmentLevel == 'high'
                            ? (langCode == 'ar' ? 'عالية' : 'High')
                            : (langCode == 'ar' ? 'متوسطة' : 'Medium'),
                      ),
                      _buildField(
                        icon: Icons.card_giftcard_outlined,
                        label: langCode == 'ar'
                            ? 'كود الإحالة'
                            : 'Referral Code',
                        value: member.referralCode,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Settings
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppColors.primaryGold.withOpacity(0.1),
                    ),
                  ),
                  child: Column(
                    children: [
                      // Language
                      _settingsTile(
                        icon: Icons.language,
                        title: langCode == 'ar' ? 'اللغة' : 'Language',
                        trailing: Text(
                          langCode == 'ar' ? 'العربية' : 'English',
                          style: const TextStyle(
                            fontFamily: 'IBMPlexSansArabic',
                            fontSize: 13,
                            color: AppColors.primaryGold,
                          ),
                        ),
                        onTap: () {
                          ref
                              .read(languageProvider.notifier)
                              .toggleLanguage();
                          // Save to Firestore
                          final uid =
                              FirebaseAuth.instance.currentUser?.uid;
                          if (uid != null) {
                            final newLang = ref
                                .read(languageProvider)
                                .languageCode;
                            ref
                                .read(profileServiceProvider)
                                .updateLanguage(uid, newLang);
                          }
                        },
                      ),

                      Divider(
                          color: Colors.white.withOpacity(0.05),
                          height: 1),

                      // Referral
                      _settingsTile(
                        icon: Icons.card_giftcard,
                        title: langCode == 'ar'
                            ? 'دعوة صديق'
                            : 'Invite Friend',
                        onTap: () => context.push('/referral'),
                      ),

                      Divider(
                          color: Colors.white.withOpacity(0.05),
                          height: 1),

                      // Logout
                      _settingsTile(
                        icon: Icons.logout,
                        title: langCode == 'ar'
                            ? 'تسجيل الخروج'
                            : 'Logout',
                        isDestructive: true,
                        onTap: _handleLogout,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 80),
              ],
            ),
          );
        },
        loading: () =>
            const LoadingWidget(message: 'جاري تحميل البيانات...'),
        error: (error, _) => Center(
          child: Text(
            'حدث خطأ: $error',
            style: const TextStyle(
              fontFamily: 'IBMPlexSansArabic',
              color: Colors.white54,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildField({
    required IconData icon,
    required String label,
    required String value,
    TextEditingController? controller,
    bool isLocked = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primaryGold, size: 18),
          const SizedBox(width: 12),
          SizedBox(
            width: 100,
            child: Row(
              children: [
                Flexible(
                  child: Text(
                    label,
                    style: TextStyle(
                      fontFamily: 'IBMPlexSansArabic',
                      fontSize: 12,
                      color: Colors.white.withOpacity(0.4),
                    ),
                  ),
                ),
                if (isLocked)
                  Padding(
                    padding: const EdgeInsets.only(right: 4),
                    child: Icon(Icons.lock,
                        size: 10, color: Colors.white.withOpacity(0.3)),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: controller != null
                ? TextField(
                    controller: controller,
                    style: const TextStyle(
                      fontFamily: 'IBMPlexSansArabic',
                      fontSize: 14,
                      color: Colors.white,
                    ),
                    decoration: InputDecoration(
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 8),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.05),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: AppColors.primaryGold.withOpacity(0.2),
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: AppColors.primaryGold.withOpacity(0.2),
                        ),
                      ),
                    ),
                  )
                : Text(
                    value,
                    style: TextStyle(
                      fontFamily: 'IBMPlexSansArabic',
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: isLocked
                          ? Colors.white.withOpacity(0.4)
                          : Colors.white.withOpacity(0.85),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _settingsTile({
    required IconData icon,
    required String title,
    Widget? trailing,
    bool isDestructive = false,
    required VoidCallback onTap,
  }) {
    return ListTile(
      onTap: onTap,
      leading: Icon(
        icon,
        color: isDestructive
            ? AppColors.error
            : AppColors.primaryGold,
        size: 20,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontFamily: 'IBMPlexSansArabic',
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: isDestructive
              ? AppColors.error
              : Colors.white.withOpacity(0.8),
        ),
      ),
      trailing: trailing ??
          Icon(
            Icons.chevron_left,
            color: Colors.white.withOpacity(0.3),
            size: 20,
          ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 4),
      dense: true,
    );
  }
}
