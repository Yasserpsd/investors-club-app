import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../../shared/constants/app_colors.dart';
import '../../../shared/widgets/custom_text_field.dart';
import '../../../shared/widgets/custom_button.dart';
import '../../../app/routes.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _scrollController = ScrollController();
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _agreedToTerms = false;

  // ── Controllers (مطابقة للفورم الأصلي) ────────────
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _cityController = TextEditingController();
  final _phoneController = TextEditingController();
  final _nationalIdController = TextEditingController();
  final _emailController = TextEditingController();
  final _inviteCodeController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // ── القدرة المالية (Radio) ────────────────────────
  String _financialCapacity = 'medium'; // medium أو high

  @override
  void dispose() {
    _scrollController.dispose();
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
    if (!_formKey.currentState!.validate()) {
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
      return;
    }

    if (!_agreedToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('يجب الموافقة على الضوابط والأحكام'),
          backgroundColor: AppColors.warning,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // TODO: Firebase Auth - Create user
      // final credential = await FirebaseAuth.instance
      //     .createUserWithEmailAndPassword(
      //   email: _emailController.text.trim(),
      //   password: _passwordController.text,
      // );

      // TODO: Store member data in Firestore
      // await FirebaseFirestore.instance
      //     .collection('members')
      //     .doc(credential.user!.uid)
      //     .set({
      //   'firstName': _firstNameController.text.trim(),
      //   'lastName': _lastNameController.text.trim(),
      //   'fullName': '${_firstNameController.text.trim()} ${_lastNameController.text.trim()}',
      //   'city': _cityController.text.trim(),
      //   'phone': '+966${_phoneController.text.trim()}',
      //   'nationalId': _nationalIdController.text.trim(),
      //   'email': _emailController.text.trim(),
      //   'inviteCode': _inviteCodeController.text.trim(),
      //   'invitedBy': null, // TODO: resolve invite code to member UID
      //   'financialCapacity': _financialCapacity,
      //   'isVIP': _financialCapacity == 'high',
      //   'role': 'member',
      //   'status': _financialCapacity == 'high' ? 'vip' : 'active',
      //   'referralCode': credential.user!.uid.substring(0, 8).toUpperCase(),
      //   'language': 'ar',
      //   'agreedToTerms': true,
      //   'createdAt': FieldValue.serverTimestamp(),
      //   'updatedAt': FieldValue.serverTimestamp(),
      // });

      await Future.delayed(const Duration(seconds: 2));

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('تم إنشاء الحساب بنجاح! مرحباً بك في نادي المستثمرين'),
            backgroundColor: AppColors.success,
          ),
        );
        context.go(AppRoutes.home);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('خطأ في إنشاء الحساب: ${e.toString()}'),
            backgroundColor: AppColors.error,
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
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          constraints: const BoxConstraints(maxHeight: 500, maxWidth: 400),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: AppColors.primaryDark,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                child: const Column(
                  children: [
                    Icon(Icons.gavel, color: AppColors.primaryGold, size: 32),
                    SizedBox(height: 8),
                    Text(
                      'الضوابط والأحكام',
                      style: TextStyle(
                        fontFamily: 'IBMPlexSansArabic',
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primaryGold,
                      ),
                    ),
                    Text(
                      'Investors Club',
                      style: TextStyle(
                        fontFamily: 'IBMPlexSansArabic',
                        fontSize: 12,
                        color: AppColors.textOnDark,
                      ),
                    ),
                  ],
                ),
              ),

              // Body
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTermItem('1', 'العضوية وقنوات التواصل',
                          'نادي المستثمرين يُعد ذراعاً تنفيذياً لشركة فايبز القابضة، ويُعتمد التعامل مع شخصيات وأرقام موثقة رسمياً عبر بوابة أبشر.'),
                      _buildTermItem('2', 'حفظ الخصوصية',
                          'يتم الحفاظ على خصوصية الأعضاء وعدم إزعاجهم، واستخدام مرافق النادي والملتقيات (حضورياً وأونلاين).'),
                      _buildTermItem('3', 'التواصل المباشر بين الأعضاء',
                          'يحق لك التواصل المباشر مع باقي الأعضاء داخل أو خارج النادي بجميع الوسائل، شريطة الالتزام التام بضوابط وأحكام هذه الاتفاقية.'),
                      _buildTermItem('4', 'دور وحقوق شركة فايبز القابضة',
                          'أسست الشركة نادي المستثمرين ليكون وسيلة وساطة بين أعضاء النادي من المستثمرين ومؤسسي وملاك المشاريع. تدخل فايبز كشريك صامت بنسبة لا تقل عن 1% من أي نسبة شراكة يتم الاتفاق عليها.'),
                      _buildTermItem('5', 'حظر طلبات التمويل',
                          'يُمنع منعاً باتاً نشر أو عرض أي إعلانات أو طلبات تمويل مباشرة أو غير مباشرة داخل قنوات النادي، ويُترتب على مخالفة ذلك إلغاء العضوية فوراً دون إنذار.'),
                      _buildTermItem('6', 'المسؤولية والتعهد',
                          'أتعهد كعضو أن تكون جميع مشاركاتي متوافقة مع أهداف النادي، وأتحمل كامل المسؤولية النظامية والقانونية عن أي محتوى أطرحه.'),
                      _buildTermItem('7', 'الشراكات الجانبية',
                          'يحق لك الدخول في شراكات أو اتفاقيات جانبية مع أعضاء آخرين داخل أو خارج النادي، شريطة عدم الإخلال بحقوق الشركة المبينة في الفقرة (4).'),
                      _buildTermItem('8', 'مبدأ الافتراضية وعدم الإلزام',
                          'أساس التعامل في النادي هو مبدأ الافتراضية وعدم الإلزام، ويحق للعضو مغادرة النادي في أي وقت دون إبداء أسباب.'),
                      _buildTermItem('9', 'الملكية الفكرية',
                          'حقوق نشر المواضيع والرسائل والمحتوى المتداول داخل مجموعات النادي تظل محفوظة للنادي ولصاحب المحتوى.'),
                      _buildTermItem('10', 'إخلاء المسؤولية',
                          'النادي وشركة فايبز القابضة لا يقدمان أي استشارات أو توصيات استثمارية، ولا يُعد أي محتوى أو نقاش ضماناً لتحقيق أرباح أو نتائج مستقبلية. كل عضو يتحمل كامل المسؤولية عن قراراته وتعاملاته التجارية.'),
                      _buildTermItem('11', 'تسوية النزاعات',
                          'في حال وقوع أي خلاف، يتم السعي لحله ودياً وفق مبدأ حسن النية، وفي حال تعذر ذلك تختص المحاكم المختصة بالمملكة العربية السعودية في الرياض.'),
                      _buildTermItem('12', 'تعديل الاتفاقية',
                          'يحتفظ نادي المستثمرين بحقه الكامل في تعديل أو تحديث هذه الضوابط والأحكام في أي وقت، ويتم إشعار الأعضاء بأي تعديل.'),

                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.primaryGold.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppColors.primaryGold.withValues(alpha: 0.3)),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.info_outline, color: AppColors.primaryGold, size: 20),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'تم تحرير هذه الاتفاقية إلكترونياً، ويُعد قبولك لها إقراراً منك بالاطلاع والفهم والموافقة والالتزام بجميع بنودها.',
                                style: TextStyle(
                                  fontFamily: 'IBMPlexSansArabic',
                                  fontSize: 12,
                                  color: AppColors.primaryGold,
                                  height: 1.6,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Center(
                        child: Text(
                          'Vibes Holding CR. No.: 2050161213\nSA-1083525',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'IBMPlexSansArabic',
                            fontSize: 10,
                            color: AppColors.textHint,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Footer
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(ctx),
                        child: const Text('إغلاق'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() => _agreedToTerms = true);
                          Navigator.pop(ctx);
                        },
                        child: const Text('أوافق'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTermItem(String number, String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: const BoxDecoration(
              color: AppColors.primaryDark,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                number,
                style: const TextStyle(
                  fontFamily: 'IBMPlexSansArabic',
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryGold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontFamily: 'IBMPlexSansArabic',
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryDark,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(
                    fontFamily: 'IBMPlexSansArabic',
                    fontSize: 12,
                    color: AppColors.textSecondary,
                    height: 1.6,
                  ),
                ),
              ],
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
          gradient: AppColors.primaryGradient,
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            controller: _scrollController,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                const SizedBox(height: 30),

                // ── Logo ──────────────────────────────
                Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.primaryGold, width: 2),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.account_balance,
                      size: 40,
                      color: AppColors.primaryGold,
                    ),
                  ),
                ),

                const SizedBox(height: 12),
                const Text(
                  'نادي المستثمرين',
                  style: TextStyle(
                    fontFamily: 'IBMPlexSansArabic',
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryGold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'انضم إلينا اليوم',
                  style: TextStyle(
                    fontFamily: 'IBMPlexSansArabic',
                    fontSize: 14,
                    color: AppColors.textOnDark.withValues(alpha: 0.7),
                  ),
                ),

                const SizedBox(height: 8),

                // ── تنويه أبشر ────────────────────────
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 12),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0D7C3D).withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFF0D7C3D).withValues(alpha: 0.3)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: const Color(0xFF0D7C3D),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Center(
                          child: Text(
                            'أبشر',
                            style: TextStyle(
                              fontFamily: 'IBMPlexSansArabic',
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'شركة المجتمع الافتراضي متصلة رسمياً ببوابة أبشر بغرض التحقق من صحة رقم جوالك قبل إضافته إلى قروب واتساب "نادي المستثمرين".',
                          style: TextStyle(
                            fontFamily: 'IBMPlexSansArabic',
                            fontSize: 11,
                            color: AppColors.textOnDark.withValues(alpha: 0.9),
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 8),

                // ── Form Container ────────────────────
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppColors.backgroundWhite,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // ── Tab Header ────────────────
                        Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () => context.go(AppRoutes.login),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  decoration: const BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(color: AppColors.border, width: 2),
                                    ),
                                  ),
                                  child: const Text(
                                    'تسجيل الدخول',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontFamily: 'IBMPlexSansArabic',
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                      color: AppColors.textHint,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                decoration: const BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(color: AppColors.primaryGold, width: 2),
                                  ),
                                ),
                                child: const Text(
                                  'حساب جديد',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: 'IBMPlexSansArabic',
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.primaryGold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 24),

                        // ═══════════════════════════════
                        // ── الاسم الأول والأخير ──────
                        // ═══════════════════════════════
                        Row(
                          children: [
                            Expanded(
                              child: CustomTextField(
                                controller: _firstNameController,
                                label: 'الاسم الأول *',
                                hint: 'الاسم الأول',
                                prefixIcon: Icons.person_outlined,
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'مطلوب';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: CustomTextField(
                                controller: _lastNameController,
                                label: 'الاسم الأخير *',
                                hint: 'الاسم الأخير',
                                prefixIcon: Icons.person_outlined,
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'مطلوب';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        // ═══════════════════════════════
                        // ── المدينة ──────────────────
                        // ═══════════════════════════════
                        CustomTextField(
                          controller: _cityController,
                          label: 'المدينة *',
                          hint: 'مثال: الرياض',
                          prefixIcon: Icons.location_city_outlined,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'الرجاء إدخال المدينة';
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 16),

                        // ═══════════════════════════════
                        // ── رقم الجوال ───────────────
                        // ═══════════════════════════════
                        _buildSectionHint('ادخل جوالك المعتمد لدى أبشر بدون صفر'),
                        const SizedBox(height: 8),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // كود الدولة
                            Container(
                              height: 56,
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              decoration: BoxDecoration(
                                color: AppColors.backgroundLight,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: AppColors.border),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text('🇸🇦', style: TextStyle(fontSize: 20)),
                                  SizedBox(width: 6),
                                  Text(
                                    '+966',
                                    style: TextStyle(
                                      fontFamily: 'IBMPlexSansArabic',
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 10),
                            // حقل الرقم
                            Expanded(
                              child: CustomTextField(
                                controller: _phoneController,
                                hint: '555050930',
                                prefixIcon: Icons.phone_outlined,
                                keyboardType: TextInputType.phone,
                                textDirection: TextDirection.ltr,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(9),
                                ],
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'مطلوب';
                                  }
                                  if (value.length != 9 || !value.startsWith('5')) {
                                    return 'رقم غير صحيح';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        // ═══════════════════════════════
                        // ── رقم الهوية / الإقامة ─────
                        // ═══════════════════════════════
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RichText(
                              text: TextSpan(
                                style: const TextStyle(
                                  fontFamily: 'IBMPlexSansArabic',
                                  fontSize: 13,
                                  color: AppColors.textSecondary,
                                ),
                                children: [
                                  const TextSpan(text: 'رقم هويتك / اقامتك '),
                                  TextSpan(
                                    text: '(تستخدم فقط لإتمام مطابقة رقم جوالك للموثق في أبشر)',
                                    style: TextStyle(
                                      color: Colors.red.shade600,
                                      fontSize: 12,
                                    ),
                                  ),
                                  const TextSpan(
                                    text: ' *',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 8),
                            CustomTextField(
                              controller: _nationalIdController,
                              hint: 'رقم الهوية / الإقامة',
                              prefixIcon: Icons.badge_outlined,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(10),
                              ],
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'الرجاء إدخال رقم الهوية';
                                }
                                if (value.length != 10) {
                                  return 'رقم الهوية يجب أن يكون 10 أرقام';
                                }
                                if (!value.startsWith('1') && !value.startsWith('2')) {
                                  return 'يجب أن يبدأ بـ 1 (مواطن) أو 2 (مقيم)';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        // ═══════════════════════════════
                        // ── البريد الإلكتروني ────────
                        // ═══════════════════════════════
                        CustomTextField(
                          controller: _emailController,
                          label: 'ادخل بريدك الإلكتروني *',
                          hint: 'example@email.com',
                          prefixIcon: Icons.alternate_email,
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'الرجاء إدخال البريد الإلكتروني';
                            }
                            if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                                .hasMatch(value)) {
                              return 'البريد الإلكتروني غير صحيح';
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 16),

                        // ═══════════════════════════════
                        // ── كود الدعوة (اختياري) ─────
                        // ═══════════════════════════════
                        CustomTextField(
                          controller: _inviteCodeController,
                          label: 'كود دعوة',
                          hint: 'اتركه فارغاً إن لم يتوفر كود دعوة',
                          prefixIcon: Icons.card_giftcard_outlined,
                        ),

                        const SizedBox(height: 20),

                        // ═══════════════════════════════
                        // ── القدرة المالية (Radio) ────
                        // ═══════════════════════════════
                        const Text(
                          'قدرتك المالية',
                          style: TextStyle(
                            fontFamily: 'IBMPlexSansArabic',
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 8),

                        // خيار 1: ملاءتي المالية متوسطة
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: _financialCapacity == 'medium'
                                  ? AppColors.primaryGold
                                  : AppColors.border,
                              width: _financialCapacity == 'medium' ? 2 : 1,
                            ),
                            color: _financialCapacity == 'medium'
                                ? AppColors.primaryGold.withValues(alpha: 0.05)
                                : null,
                          ),
                          child: RadioListTile<String>(
                            value: 'medium',
                            groupValue: _financialCapacity,
                            onChanged: (val) => setState(() => _financialCapacity = val!),
                            activeColor: AppColors.primaryGold,
                            title: const Text(
                              'ملاءتي المالية متوسطة',
                              style: TextStyle(
                                fontFamily: 'IBMPlexSansArabic',
                                fontSize: 14,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),

                        const SizedBox(height: 8),

                        // خيار 2: ملاءتي المالية عالية (VIP)
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: _financialCapacity == 'high'
                                  ? AppColors.primaryGold
                                  : AppColors.border,
                              width: _financialCapacity == 'high' ? 2 : 1,
                            ),
                            color: _financialCapacity == 'high'
                                ? AppColors.primaryGold.withValues(alpha: 0.05)
                                : null,
                          ),
                          child: RadioListTile<String>(
                            value: 'high',
                            groupValue: _financialCapacity,
                            onChanged: (val) => setState(() => _financialCapacity = val!),
                            activeColor: AppColors.primaryGold,
                            title: const Text(
                              'ملاءتي المالية عالية، وأرجو إضافتي إلى قائمة الـ VIP',
                              style: TextStyle(
                                fontFamily: 'IBMPlexSansArabic',
                                fontSize: 14,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        // ═══════════════════════════════
                        // ── كلمة المرور ──────────────
                        // ═══════════════════════════════
                        _buildSectionTitle('كلمة المرور'),
                        const SizedBox(height: 12),

                        CustomTextField(
                          controller: _passwordController,
                          label: 'كلمة المرور *',
                          hint: '6 أحرف على الأقل',
                          prefixIcon: Icons.lock_outlined,
                          obscureText: _obscurePassword,
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              color: AppColors.textHint,
                            ),
                            onPressed: () =>
                                setState(() => _obscurePassword = !_obscurePassword),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) return 'مطلوب';
                            if (value.length < 6) return '6 أحرف على الأقل';
                            return null;
                          },
                        ),
                        const SizedBox(height: 14),

                        CustomTextField(
                          controller: _confirmPasswordController,
                          label: 'تأكيد كلمة المرور *',
                          hint: 'أعد إدخال كلمة المرور',
                          prefixIcon: Icons.lock_outlined,
                          obscureText: _obscureConfirmPassword,
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureConfirmPassword
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              color: AppColors.textHint,
                            ),
                            onPressed: () => setState(
                                () => _obscureConfirmPassword = !_obscureConfirmPassword),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) return 'مطلوب';
                            if (value != _passwordController.text) return 'غير متطابقة';
                            return null;
                          },
                        ),

                        const SizedBox(height: 20),

                        // ═══════════════════════════════
                        // ── الموافقة على الشروط ──────
                        // ═══════════════════════════════
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: _agreedToTerms
                                  ? AppColors.primaryGold
                                  : AppColors.border,
                            ),
                            color: _agreedToTerms
                                ? AppColors.primaryGold.withValues(alpha: 0.05)
                                : null,
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 24,
                                height: 24,
                                child: Checkbox(
                                  value: _agreedToTerms,
                                  onChanged: (val) =>
                                      setState(() => _agreedToTerms = val ?? false),
                                  activeColor: AppColors.primaryGold,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: GestureDetector(
                                  onTap: _showTermsDialog,
                                  child: RichText(
                                    text: const TextSpan(
                                      style: TextStyle(
                                        fontFamily: 'IBMPlexSansArabic',
                                        fontSize: 13,
                                        color: AppColors.textSecondary,
                                        height: 1.5,
                                      ),
                                      children: [
                                        TextSpan(text: 'أوافق على '),
                                        TextSpan(
                                          text: 'الضوابط والأحكام',
                                          style: TextStyle(
                                            color: AppColors.primaryGold,
                                            fontWeight: FontWeight.w600,
                                            decoration: TextDecoration.underline,
                                          ),
                                        ),
                                        TextSpan(
                                          text: ' الخاصة بعضوية نادي المستثمرين',
                                        ),
                                        TextSpan(
                                          text: ' *',
                                          style: TextStyle(color: Colors.red),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),

                        // ═══════════════════════════════
                        // ── زر إنشاء الحساب ─────────
                        // ═══════════════════════════════
                        CustomButton(
                          text: 'إنشاء حساب',
                          onPressed: _handleSignUp,
                          isLoading: _isLoading,
                        ),

                        const SizedBox(height: 14),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'لديك حساب بالفعل؟',
                              style: TextStyle(
                                fontFamily: 'IBMPlexSansArabic',
                                fontSize: 14,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            TextButton(
                              onPressed: () => context.go(AppRoutes.login),
                              child: const Text('سجّل دخولك'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 20,
          decoration: BoxDecoration(
            color: AppColors.primaryGold,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontFamily: 'IBMPlexSansArabic',
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.primaryDark,
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHint(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontFamily: 'IBMPlexSansArabic',
        fontSize: 12,
        color: AppColors.textHint,
      ),
    );
  }
}
