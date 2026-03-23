import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../shared/constants/app_colors.dart';
import '../../../shared/widgets/custom_text_field.dart';
import '../../../shared/widgets/custom_button.dart';
import '../../../app/providers.dart';
import '../services/auth_service.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _cityController = TextEditingController();
  final _phoneController = TextEditingController();
  final _nationalIdController = TextEditingController();
  final _emailController = TextEditingController();
  final _inviteCodeController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _agreedToTerms = false;
  String _financialCapacity = 'medium';

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _cityController.dispose();
    _phoneController.dispose();
    _nationalIdController.dispose();
    _emailController.dispose();
    _inviteCodeController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleSignUp() async {
    if (!_formKey.currentState!.validate()) return;

    if (!_agreedToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'يجب الموافقة على الضوابط والأحكام',
            style: TextStyle(fontFamily: 'IBMPlexSansArabic'),
          ),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final authService = ref.read(authServiceProvider);
      final langCode = ref.read(languageProvider).languageCode;

      await authService.signUp(
        email: _emailController.text,
        password: _passwordController.text,
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        phone: _phoneController.text.trim(),
        nationalId: _nationalIdController.text.trim(),
        city: _cityController.text.trim(),
        financialCapacity: _financialCapacity,
        inviteCode: _inviteCodeController.text.trim(),
        agreedToTerms: _agreedToTerms,
        language: langCode,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              'تم إنشاء الحساب بنجاح! مرحباً بك في نادي المستثمرين',
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
        context.go('/home');
      }
    } catch (e) {
      if (mounted) {
        String errorMessage = 'خطأ في إنشاء الحساب';
        final errorStr = e.toString();

        if (errorStr.contains('email-already-in-use') ||
            errorStr.contains('مسجل مسبقاً')) {
          errorMessage = 'البريد الإلكتروني مسجل مسبقاً';
        } else if (errorStr.contains('weak-password') ||
            errorStr.contains('ضعيفة')) {
          errorMessage = 'كلمة المرور ضعيفة. اختر كلمة أقوى';
        } else if (errorStr.contains('invalid-email')) {
          errorMessage = 'البريد الإلكتروني غير صحيح';
        } else if (errorStr.contains('network-request-failed')) {
          errorMessage = 'تحقق من اتصالك بالإنترنت';
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              errorMessage,
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
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showTermsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'الضوابط والأحكام',
          style: TextStyle(
            fontFamily: 'IBMPlexSansArabic',
            fontWeight: FontWeight.w700,
          ),
          textAlign: TextAlign.center,
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _termItem('1', 'العضوية في نادي المستثمرين متاحة لجميع المهتمين بالاستثمار.'),
              _termItem('2', 'يلتزم العضو بصحة البيانات المدخلة عند التسجيل.'),
              _termItem('3', 'لا يحق للعضو مشاركة بيانات الدخول مع أي طرف آخر.'),
              _termItem('4', 'الفرص الاستثمارية المعروضة هي للاطلاع وليست توصية مالية.'),
              _termItem('5', 'يتحمل العضو مسؤولية قراراته الاستثمارية بالكامل.'),
              _termItem('6', 'النادي غير مسؤول عن أي خسائر مالية ناتجة عن الاستثمار.'),
              _termItem('7', 'يحق للإدارة تعليق أو إلغاء العضوية في حال مخالفة الشروط.'),
              _termItem('8', 'المحتوى المعروض محمي بحقوق الملكية الفكرية.'),
              _termItem('9', 'يحق للإدارة تعديل هذه الشروط في أي وقت.'),
              _termItem('10', 'بيانات الأعضاء محفوظة وفق سياسة الخصوصية.'),
              _termItem('11', 'العضو مسؤول عن الحفاظ على سرية حسابه.'),
              _termItem('12', 'بالتسجيل يوافق العضو على جميع الشروط أعلاه.'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'إغلاق',
              style: TextStyle(fontFamily: 'IBMPlexSansArabic'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _termItem(String number, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$number. ',
            style: const TextStyle(
              fontFamily: 'IBMPlexSansArabic',
              fontWeight: FontWeight.w700,
              color: AppColors.primaryGold,
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontFamily: 'IBMPlexSansArabic',
                fontSize: 13,
                height: 1.6,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF0d0d1a),
              AppColors.primaryDark,
              Color(0xFF1f1f3a),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                const SizedBox(height: 30),

                // Logo
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryGold.withOpacity(0.15),
                        blurRadius: 15,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      'assets/images/logo.png',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.primaryGold,
                          ),
                          child: const Icon(
                            Icons.account_balance,
                            size: 35,
                            color: AppColors.primaryDark,
                          ),
                        );
                      },
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                const Text(
                  'إنشاء حساب جديد',
                  style: TextStyle(
                    fontFamily: 'IBMPlexSansArabic',
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryGold,
                  ),
                ),

                const SizedBox(height: 8),

                // Absher notice
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.primaryGold.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: AppColors.primaryGold.withOpacity(0.15),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline,
                          color: AppColors.primaryGold.withOpacity(0.7),
                          size: 18),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'شركة المجتمع الافتراضي متصلة رسمياً ببوابة أبشر بغرض التحقق من صحة رقم جوالك',
                          style: TextStyle(
                            fontFamily: 'IBMPlexSansArabic',
                            fontSize: 11,
                            color: Colors.white.withOpacity(0.6),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Form
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: AppColors.primaryGold.withOpacity(0.1),
                    ),
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // First + Last name
                        Row(
                          children: [
                            Expanded(
                              child: CustomTextField(
                                controller: _firstNameController,
                                label: 'الاسم الأول',
                                hint: 'محمد',
                                prefixIcon: Icons.person_outline,
                                validator: (v) =>
                                    v == null || v.trim().isEmpty
                                        ? 'مطلوب'
                                        : null,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: CustomTextField(
                                controller: _lastNameController,
                                label: 'الاسم الأخير',
                                hint: 'العمري',
                                prefixIcon: Icons.person_outline,
                                validator: (v) =>
                                    v == null || v.trim().isEmpty
                                        ? 'مطلوب'
                                        : null,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),

                        // City
                        CustomTextField(
                          controller: _cityController,
                          label: 'المدينة',
                          hint: 'الرياض',
                          prefixIcon: Icons.location_city_outlined,
                          validator: (v) =>
                              v == null || v.trim().isEmpty ? 'مطلوب' : null,
                        ),
                        const SizedBox(height: 14),

                        // Phone
                        CustomTextField(
                          controller: _phoneController,
                          label: 'رقم الجوال (بدون 0 أو +966)',
                          hint: '5XXXXXXXX',
                          prefixIcon: Icons.phone_outlined,
                          keyboardType: TextInputType.phone,
                          textDirection: TextDirection.ltr,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(9),
                          ],
                          validator: (v) {
                            if (v == null || v.trim().isEmpty) return 'مطلوب';
                            if (v.length != 9 || !v.startsWith('5')) {
                              return 'رقم الجوال يجب أن يبدأ بـ 5 ويتكون من 9 أرقام';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 14),

                        // National ID
                        CustomTextField(
                          controller: _nationalIdController,
                          label: 'رقم الهوية / الإقامة',
                          hint: '10 أرقام',
                          prefixIcon: Icons.badge_outlined,
                          keyboardType: TextInputType.number,
                          textDirection: TextDirection.ltr,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(10),
                          ],
                          validator: (v) {
                            if (v == null || v.trim().isEmpty) return 'مطلوب';
                            if (v.length != 10) return 'يجب 10 أرقام';
                            if (!v.startsWith('1') && !v.startsWith('2')) {
                              return 'يجب أن يبدأ بـ 1 أو 2';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 14),

                        // Email
                        CustomTextField(
                          controller: _emailController,
                          label: 'البريد الإلكتروني',
                          hint: 'example@email.com',
                          prefixIcon: Icons.email_outlined,
                          keyboardType: TextInputType.emailAddress,
                          textDirection: TextDirection.ltr,
                          validator: (v) {
                            if (v == null || v.trim().isEmpty) return 'مطلوب';
                            if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                                .hasMatch(v)) {
                              return 'بريد إلكتروني غير صحيح';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 14),

                        // Invite Code (optional)
                        CustomTextField(
                          controller: _inviteCodeController,
                          label: 'كود دعوة (اختياري)',
                          hint: 'INV-XXXXX',
                          prefixIcon: Icons.card_giftcard_outlined,
                          textDirection: TextDirection.ltr,
                        ),
                        const SizedBox(height: 14),

                        // Password
                        CustomTextField(
                          controller: _passwordController,
                          label: 'كلمة المرور',
                          hint: '6 أحرف على الأقل',
                          prefixIcon: Icons.lock_outline,
                          obscureText: _obscurePassword,
                          textDirection: TextDirection.ltr,
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              color: AppColors.primaryGold.withOpacity(0.5),
                              size: 20,
                            ),
                            onPressed: () => setState(
                                () => _obscurePassword = !_obscurePassword),
                          ),
                          validator: (v) {
                            if (v == null || v.isEmpty) return 'مطلوب';
                            if (v.length < 6) return '6 أحرف على الأقل';
                            return null;
                          },
                        ),
                        const SizedBox(height: 14),

                        // Confirm Password
                        CustomTextField(
                          controller: _confirmPasswordController,
                          label: 'تأكيد كلمة المرور',
                          hint: '••••••••',
                          prefixIcon: Icons.lock_outline,
                          obscureText: _obscureConfirmPassword,
                          textDirection: TextDirection.ltr,
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureConfirmPassword
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              color: AppColors.primaryGold.withOpacity(0.5),
                              size: 20,
                            ),
                            onPressed: () => setState(() =>
                                _obscureConfirmPassword =
                                    !_obscureConfirmPassword),
                          ),
                          validator: (v) {
                            if (v == null || v.isEmpty) return 'مطلوب';
                            if (v != _passwordController.text) {
                              return 'كلمتا المرور غير متطابقتين';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 18),

                        // Financial capacity
                        Text(
                          'قدرتك المالية',
                          style: TextStyle(
                            fontFamily: 'IBMPlexSansArabic',
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.white.withOpacity(0.8),
                          ),
                        ),
                        const SizedBox(height: 8),
                        RadioListTile<String>(
                          value: 'medium',
                          groupValue: _financialCapacity,
                          onChanged: (v) =>
                              setState(() => _financialCapacity = v!),
                          title: Text(
                            'ملاءتي المالية متوسطة',
                            style: TextStyle(
                              fontFamily: 'IBMPlexSansArabic',
                              fontSize: 13,
                              color: Colors.white.withOpacity(0.7),
                            ),
                          ),
                          activeColor: AppColors.primaryGold,
                          dense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                        RadioListTile<String>(
                          value: 'high',
                          groupValue: _financialCapacity,
                          onChanged: (v) =>
                              setState(() => _financialCapacity = v!),
                          title: Text(
                            'ملاءتي المالية عالية، وأرجو إضافتي إلى قائمة الـ VIP',
                            style: TextStyle(
                              fontFamily: 'IBMPlexSansArabic',
                              fontSize: 13,
                              color: Colors.white.withOpacity(0.7),
                            ),
                          ),
                          activeColor: AppColors.primaryGold,
                          dense: true,
                          contentPadding: EdgeInsets.zero,
                        ),

                        const SizedBox(height: 14),

                        // Terms
                        Row(
                          children: [
                            Checkbox(
                              value: _agreedToTerms,
                              onChanged: (v) =>
                                  setState(() => _agreedToTerms = v!),
                              activeColor: AppColors.primaryGold,
                              checkColor: AppColors.primaryDark,
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: _showTermsDialog,
                                child: Text.rich(
                                  TextSpan(
                                    text: 'أوافق على ',
                                    style: TextStyle(
                                      fontFamily: 'IBMPlexSansArabic',
                                      fontSize: 12,
                                      color: Colors.white.withOpacity(0.6),
                                    ),
                                    children: [
                                      TextSpan(
                                        text: 'الضوابط والأحكام',
                                        style: TextStyle(
                                          color: AppColors.primaryGold,
                                          decoration:
                                              TextDecoration.underline,
                                        ),
                                      ),
                                      const TextSpan(
                                          text:
                                              ' الخاصة بعضوية نادي المستثمرين'),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        // Sign up button
                        CustomButton(
                          text: 'إنشاء حساب',
                          onPressed: _handleSignUp,
                          isLoading: _isLoading,
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Login link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'لديك حساب بالفعل؟',
                      style: TextStyle(
                        fontFamily: 'IBMPlexSansArabic',
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.5),
                      ),
                    ),
                    TextButton(
                      onPressed: () => context.push('/login'),
                      child: const Text(
                        'سجّل دخولك',
                        style: TextStyle(
                          fontFamily: 'IBMPlexSansArabic',
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryGold,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
