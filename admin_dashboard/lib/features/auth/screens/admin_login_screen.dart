import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../shared/constants/admin_colors.dart';
import '../../../app/admin_routes.dart';

class AdminLoginScreen extends StatefulWidget {
  const AdminLoginScreen({super.key});

  @override
  State<AdminLoginScreen> createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends State<AdminLoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      // TODO: Firebase Auth + check role == 'admin'
      // final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
      //   email: _emailController.text.trim(),
      //   password: _passwordController.text,
      // );
      // final doc = await FirebaseFirestore.instance
      //     .collection('members')
      //     .doc(credential.user!.uid)
      //     .get();
      // if (doc.data()?['role'] != 'admin') {
      //   throw Exception('ليس لديك صلاحية الوصول');
      // }

      await Future.delayed(const Duration(seconds: 2));

      if (mounted) {
        context.go(AdminRoutes.dashboard);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('خطأ: $e'),
            backgroundColor: AdminColors.error,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
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
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AdminColors.primaryDark,
              Color(0xFF252542),
              AdminColors.primaryDark,
            ],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              width: 420,
              padding: const EdgeInsets.all(40),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 30,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Logo
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AdminColors.primaryDark,
                        border: Border.all(
                          color: AdminColors.primaryGold,
                          width: 2,
                        ),
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          'assets/images/logo.png',
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => const Icon(
                            Icons.admin_panel_settings,
                            size: 40,
                            color: AdminColors.primaryGold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'لوحة تحكم نادي المستثمرين',
                      style: TextStyle(
                        fontFamily: 'IBMPlexSansArabic',
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: AdminColors.primaryDark,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Admin Dashboard',
                      style: TextStyle(
                        fontFamily: 'IBMPlexSansArabic',
                        fontSize: 12,
                        color: AdminColors.textHint,
                        letterSpacing: 2,
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Email
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: 'البريد الإلكتروني',
                        hintText: 'admin@vcmem.com',
                        prefixIcon: Icon(Icons.email_outlined, size: 20),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'مطلوب';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Password
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      decoration: InputDecoration(
                        labelText: 'كلمة المرور',
                        hintText: '••••••••',
                        prefixIcon: const Icon(Icons.lock_outlined, size: 20),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            size: 20,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'مطلوب';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 28),

                    // Login button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _handleLogin,
                        child: _isLoading
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: AdminColors.primaryDark,
                                ),
                              )
                            : const Text('تسجيل الدخول'),
                      ),
                    ),

                    const SizedBox(height: 16),
                    Text(
                      'الدخول متاح فقط للمسؤولين',
                      style: TextStyle(
                        fontFamily: 'IBMPlexSansArabic',
                        fontSize: 12,
                        color: AdminColors.textHint.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
