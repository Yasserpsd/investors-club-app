class Validators {
  Validators._();

  static String? required(String? value, [String fieldName = 'هذا الحقل']) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName مطلوب';
    }
    return null;
  }

  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'الرجاء إدخال البريد الإلكتروني';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'البريد الإلكتروني غير صحيح';
    }
    return null;
  }

  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return 'الرجاء إدخال كلمة المرور';
    }
    if (value.length < 6) {
      return 'كلمة المرور يجب أن تكون 6 أحرف على الأقل';
    }
    return null;
  }

  static String? confirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return 'الرجاء تأكيد كلمة المرور';
    }
    if (value != password) {
      return 'كلمتا المرور غير متطابقتين';
    }
    return null;
  }

  static String? nationalId(String? value) {
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
  }

  static String? saudiPhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'الرجاء إدخال رقم الجوال';
    }
    if (value.length != 9) {
      return 'رقم الجوال يجب أن يكون 9 أرقام';
    }
    if (!value.startsWith('5')) {
      return 'رقم الجوال يجب أن يبدأ بـ 5';
    }
    return null;
  }

  static String? fullName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'الرجاء إدخال الاسم';
    }
    if (value.trim().length < 2) {
      return 'الاسم قصير جداً';
    }
    return null;
  }

  static String? dropdownRequired(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return 'الرجاء اختيار $fieldName';
    }
    return null;
  }
}
