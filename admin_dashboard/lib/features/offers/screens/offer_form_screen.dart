import 'package:flutter/material.dart';
import '../../../shared/constants/admin_colors.dart';

class OfferFormScreen extends StatefulWidget {
  final String? offerId;
  const OfferFormScreen({super.key, this.offerId});

  @override
  State<OfferFormScreen> createState() => _OfferFormScreenState();
}

class _OfferFormScreenState extends State<OfferFormScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _isVIP = false;
  String _status = 'draft';

  final _titleArController = TextEditingController();
  final _titleEnController = TextEditingController();
  final _summaryArController = TextEditingController();
  final _summaryEnController = TextEditingController();
  final _bodyArController = TextEditingController();
  final _bodyEnController = TextEditingController();
  final _categoryController = TextEditingController();

  bool get isEdit => widget.offerId != null;

  @override
  void initState() {
    super.initState();
    if (isEdit) {
      // TODO: Load offer data from Firestore
      _titleArController.text = 'فرصة استثمارية في قطاع التقنية';
      _titleEnController.text = 'Investment Opportunity in Tech';
      _summaryArController.text = 'شركة تقنية ناشئة تبحث عن مستثمرين';
      _summaryEnController.text = 'A tech startup looking for investors';
      _bodyArController.text = 'تفاصيل الفرصة...';
      _bodyEnController.text = 'Opportunity details...';
      _categoryController.text = 'تقنية';
      _isVIP = true;
      _status = 'published';
    }
  }

  @override
  void dispose() {
    _titleArController.dispose();
    _titleEnController.dispose();
    _summaryArController.dispose();
    _summaryEnController.dispose();
    _bodyArController.dispose();
    _bodyEnController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    try {
      // TODO: Save to Firestore
      await Future.delayed(const Duration(seconds: 1));
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(isEdit ? 'تم تحديث العرض' : 'تم إنشاء العرض'),
            backgroundColor: AdminColors.success,
          ),
        );
        Navigator.pop(context);
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back),
              ),
              const SizedBox(width: 8),
              Text(
                isEdit ? 'تعديل العرض' : 'إضافة عرض جديد',
                style: const TextStyle(
                  fontFamily: 'IBMPlexSansArabic',
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          Form(
            key: _formKey,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left - Form fields
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('العنوان (عربي) *',
                            style: TextStyle(
                              fontFamily: 'IBMPlexSansArabic',
                              fontWeight: FontWeight.w600,
                            )),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _titleArController,
                          validator: (v) =>
                              v == null || v.isEmpty ? 'مطلوب' : null,
                          decoration:
                              const InputDecoration(hintText: 'عنوان العرض بالعربي'),
                        ),
                        const SizedBox(height: 16),

                        const Text('العنوان (إنجليزي)',
                            style: TextStyle(
                              fontFamily: 'IBMPlexSansArabic',
                              fontWeight: FontWeight.w600,
                            )),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _titleEnController,
                          textDirection: TextDirection.ltr,
                          decoration: const InputDecoration(
                              hintText: 'Offer title in English'),
                        ),
                        const SizedBox(height: 16),

                        const Text('الملخص (عربي) *',
                            style: TextStyle(
                              fontFamily: 'IBMPlexSansArabic',
                              fontWeight: FontWeight.w600,
                            )),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _summaryArController,
                          maxLines: 2,
                          validator: (v) =>
                              v == null || v.isEmpty ? 'مطلوب' : null,
                          decoration: const InputDecoration(
                              hintText: 'ملخص قصير للعرض'),
                        ),
                        const SizedBox(height: 16),

                        const Text('الملخص (إنجليزي)',
                            style: TextStyle(
                              fontFamily: 'IBMPlexSansArabic',
                              fontWeight: FontWeight.w600,
                            )),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _summaryEnController,
                          maxLines: 2,
                          textDirection: TextDirection.ltr,
                          decoration:
                              const InputDecoration(hintText: 'Short summary'),
                        ),
                        const SizedBox(height: 16),

                        const Text('التفاصيل (عربي) *',
                            style: TextStyle(
                              fontFamily: 'IBMPlexSansArabic',
                              fontWeight: FontWeight.w600,
                            )),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _bodyArController,
                          maxLines: 8,
                          validator: (v) =>
                              v == null || v.isEmpty ? 'مطلوب' : null,
                          decoration: const InputDecoration(
                              hintText: 'تفاصيل العرض الكاملة...'),
                        ),
                        const SizedBox(height: 16),

                        const Text('التفاصيل (إنجليزي)',
                            style: TextStyle(
                              fontFamily: 'IBMPlexSansArabic',
                              fontWeight: FontWeight.w600,
                            )),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _bodyEnController,
                          maxLines: 8,
                          textDirection: TextDirection.ltr,
                          decoration: const InputDecoration(
                              hintText: 'Full offer details...'),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 16),

                // Right - Settings
                Expanded(
                  child: Column(
                    children: [
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
                            const Text('إعدادات النشر',
                                style: TextStyle(
                                  fontFamily: 'IBMPlexSansArabic',
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                )),
                            const SizedBox(height: 16),

                            const Text('التصنيف *',
                                style: TextStyle(
                                    fontFamily: 'IBMPlexSansArabic')),
                            const SizedBox(height: 8),
                            TextFormField(
                              controller: _categoryController,
                              validator: (v) =>
                                  v == null || v.isEmpty ? 'مطلوب' : null,
                              decoration: const InputDecoration(
                                  hintText: 'مثال: تقنية، عقارات'),
                            ),
                            const SizedBox(height: 16),

                            const Text('الحالة',
                                style: TextStyle(
                                    fontFamily: 'IBMPlexSansArabic')),
                            const SizedBox(height: 8),
                            DropdownButtonFormField<String>(
                              value: _status,
                              items: const [
                                DropdownMenuItem(
                                    value: 'draft', child: Text('مسودة')),
                                DropdownMenuItem(
                                    value: 'published', child: Text('منشور')),
                                DropdownMenuItem(
                                    value: 'hidden', child: Text('مخفي')),
                              ],
                              onChanged: (v) =>
                                  setState(() => _status = v!),
                            ),
                            const SizedBox(height: 16),

                            SwitchListTile(
                              value: _isVIP,
                              onChanged: (v) =>
                                  setState(() => _isVIP = v),
                              title: const Text(
                                'عرض VIP',
                                style: TextStyle(
                                  fontFamily: 'IBMPlexSansArabic',
                                  fontSize: 14,
                                ),
                              ),
                              activeColor: AdminColors.primaryGold,
                              contentPadding: EdgeInsets.zero,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Action buttons
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _save,
                          child: _isLoading
                              ? const SizedBox(
                                  width: 22,
                                  height: 22,
                                  child: CircularProgressIndicator(
                                      strokeWidth: 2),
                                )
                              : Text(isEdit ? 'حفظ التعديلات' : 'نشر العرض'),
                        ),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('إلغاء'),
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
    );
  }
}
