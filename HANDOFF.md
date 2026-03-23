# Investors Club - Developer Handoff Guide

## المطلوب لتشغيل المشروع

### الخطوة 1: إعداد Firebase
1. أنشئ مشروع Firebase جديد في https://console.firebase.google.com
2. فعّل Authentication → Email/Password
3. أنشئ Firestore Database (Start in test mode)
4. فعّل Firebase Storage
5. أضف تطبيق Android (package: com.vcmem.investorsclub)
6. أضف تطبيق iOS (bundle: com.vcmem.investorsclub)
7. أضف تطبيق Web (للوحة الأدمن)

### الخطوة 2: توليد firebase_options.dart
```bash
cd mobile
dart pub global activate flutterfire_cli
flutterfire configure --project=YOUR_PROJECT_ID
