import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../shared/constants/app_colors.dart';
import '../../../shared/widgets/custom_text_field.dart';
import '../../../shared/widgets/custom_button.dart';
import '../services/auth_service.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;
  late AnimationController _animController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeIn),
    );
    _animController.forward();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _animController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    try {
      final authService = ref.read(authServiceProvider);
      await authService.signIn(
        email: _emailController.text,
        password: _passwordController.text,
      );
      if (mounted) context.go('/home');
    } catch (e) {
      if (mounted) {
        String msg = 'خطأ في تسجيل الدخول';
        final s = e.toString();
        if (s.contains('user-not-found') || s.contains('غير مسجل')) {
          msg = 'البريد الإلكتروني غير مسجل';
        } else if (s.contains('wrong-password') || s.contains('غير صحيحة')) {
          msg = 'كلمة المرور غير صحيحة';
        } else if (s.contains('invalid-credential')) {
          msg = 'البريد أو كلمة المرور غير صحيحة';
        } else if (s.contains('account-suspended') || s.contains('إيقاف')) {
          msg = 'تم إيقاف حسابك. تواصل مع الإدارة';
        } else if (s.contains('too-many-requests')) {
          msg = 'محاولات كثيرة. حاول لاحقاً';
        } else if (s.contains('network-request-failed')) {
          msg = 'تحقق من اتصالك بالإنترنت';
        }
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(msg, style: const TextStyle(fontFamily: 'IBMPlexSansArabic')),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _handleForgotPassword() async {
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('أدخل بريدك الإلكتروني أولاً',
            style: TextStyle(fontFamily: 'IBMPlexSansArabic')),
        backgroundColor: AppColors.error,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ));
      return;
    }
    try {
      await ref.read(authServiceProvider).resetPassword(email);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: const Text('تم إرسال رابط إعادة التعيين إلى بريدك',
              style: TextStyle(fontFamily: 'IBMPlexSansArabic')),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('خطأ: $e', style: const TextStyle(fontFamily: 'IBMPlexSansArabic')),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ));
      }
    }
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
            colors: [Color(0xFF0d0d1a), AppColors.primaryDark, Color(0xFF1f1f3a)],
          ),
        ),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Column(
                children: [
                  const SizedBox(height: 50),
                  // Logo
                  Container(
                    width: 110, height: 110,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [BoxShadow(color: AppColors.primaryGold.withOpacity(0.2), blurRadius: 20, spreadRadius: 2)],
                    ),
                    child: ClipOval(
                      child: Image.asset('assets/images/logo.png', fit: BoxFit.cover,
                        errorBuilder: (c, e, s) => Container(
                          decoration: const BoxDecoration(shape: BoxShape.circle, color: AppColors.primaryGold),
                          child: const Icon(Icons.account_balance, size: 50, color: AppColors.primaryDark),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text('نادي المستثمرين', style: TextStyle(fontFamily: 'IBMPlexSansArabic', fontSize: 26, fontWeight: FontWeight.w700, color: AppColors.primaryGold)),
                  const SizedBox(height: 6),
                  Text('INVESTORS CLUB', style: TextStyle(fontFamily: 'IBMPlexSansArabic', fontSize: 12, color: Colors.white.withOpacity(0.5), letterSpacing: 3)),
                  const SizedBox(height: 40),
                  // Card
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.primaryGold.withOpacity(0.1)),
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(children: [
                            Container(width: 4, height: 20, decoration: BoxDecoration(color: AppColors.primaryGold, borderRadius: BorderRadius.circular(2))),
                            const SizedBox(width: 10),
                            const Text('تسجيل الدخول', style: TextStyle(fontFamily: 'IBMPlexSansArabic', fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white)),
                          ]),
                          const SizedBox(height: 24),
                          CustomTextField(
                            controller: _emailController, label: 'البريد الإلكتروني', hint: 'example@email.com',
                            prefixIcon: Icons.email_outlined, keyboardType: TextInputType.emailAddress, textDirection: TextDirection.ltr,
                            validator: (v) {
                              if (v == null || v.trim().isEmpty) return 'يرجى إدخال البريد الإلكتروني';
                              if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(v)) return 'بريد إلكتروني غير صحيح';
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          CustomTextField(
                            controller: _passwordController, label: 'كلمة المرور', hint: '••••••••',
                            prefixIcon: Icons.lock_outline, obscureText: _obscurePassword, textDirection: TextDirection.ltr,
                            suffixIcon: IconButton(
                              icon: Icon(_obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined, color: AppColors.primaryGold.withOpacity(0.5), size: 20),
                              onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                            ),
                            validator: (v) {
                              if (v == null || v.trim().isEmpty) return 'يرجى إدخال كلمة المرور';
                              if (v.length < 6) return '6 أحرف على الأقل';
                              return null;
                            },
                          ),
                          const SizedBox(height: 12),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: TextButton(
                              onPressed: _handleForgotPassword,
                              child: Text('نسيت كلمة المرور؟', style: TextStyle(fontFamily: 'IBMPlexSansArabic', fontSize: 13, color: AppColors.primaryGold.withOpacity(0.8))),
                            ),
                          ),
                          const SizedBox(height: 20),
                          CustomButton(text: 'دخول', onPressed: _handleLogin, isLoading: _isLoading),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Text('ليس لديك حساب؟', style: TextStyle(fontFamily: 'IBMPlexSansArabic', fontSize: 14, color: Colors.white.withOpacity(0.5))),
                    TextButton(onPressed: () => context.push('/signup'), child: const Text('سجّل الآن', style: TextStyle(fontFamily: 'IBMPlexSansArabic', fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.primaryGold))),
                  ]),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
