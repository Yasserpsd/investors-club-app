# نادي المستثمرين | Investors Club App

> تطبيق موبايل لأعضاء نادي المستثمرين + لوحة تحكم ويب للأدمن

---

## وصف عام للمشروع

مشروع **نادي المستثمرين**: تطبيق موبايل (Android + iOS) لأعضاء النادي لعرض العروض الاستثمارية والتواصل مع الإدارة، بالإضافة إلى لوحة تحكم ويب للأدمن لإدارة الأعضاء والعروض والشات.

### الروابط المرجعية

| الوصف | الرابط |
|-------|--------|
| نادي المستثمرين (عربي) | https://vcmem.com/investors-club/ |
| نادي المستثمرين (إنجليزي) | https://vcmem.com/en/investors-club/ |
| صفحة التحديثات | https://vcmem.com/update/ |
| نموذج التسجيل | https://vcmem.com/investors-club/#subscribe |
| GitHub Repo | https://github.com/Yasserpsd/investors-club-app |
| Firebase Console | https://console.firebase.google.com/project/investors-club-fcc36 |
| Firebase Auth (Users) | https://console.firebase.google.com/project/investors-club-fcc36/authentication/users |
| Firestore Database | https://console.firebase.google.com/project/investors-club-fcc36/firestore |

---

## ⚠️ آخر ما وصلنا إليه (23 مارس 2026)

### تم إنجازه ✅

- [x] كود تطبيق الموبايل مكتمل (جميع الشاشات والـ services)
- [x] كود لوحة تحكم الأدمن (Dashboard Web) مكتمل
- [x] تعديل `auth_service.dart` — إضافة cleanup لو Firestore فشل بعد Auth
- [x] تعديل `signup_screen.dart` — رسائل خطأ أوضح + debugPrint
- [x] تعديل `firestore.rules` — تبسيط شرط التسجيل (شيلنا شرط nationalId.size)
- [x] إلغاء فكرة OTP نهائياً — التسجيل بالإيميل والباسورد فقط
- [x] ربط المشروع بـ Firebase (project: `investors-club-fcc36`)
- [x] تسجيل Android app على Firebase (package: `com.vcmem.investorsclub`)
- [x] تسجيل Web app على Firebase
- [x] Deploy الـ Firestore Rules بنجاح
- [x] حل مشكلة versions بـ `flutter pub upgrade --major-versions`
- [x] إنشاء فولدر `assets/icons/` (كان ناقص)
- [x] التطبيق شُغّل بنجاح على الويب (web-server) وظهرت شاشة Splash + Login

### لم يكتمل بعد ❌

- [ ] **إصلاح اللوجو** — ملف الصورة على GitHub اسمه `Logo.png.png` (مكرر) بينما الكود يدور على `logo.png`. محتاج rename على GitHub + التأكد من وجوده محلياً
- [ ] **اختبار التسجيل الفعلي** — التطبيق شُغّل بس التسجيل لم يُختبر بعد التعديلات
- [ ] **مسح users قديمة** من Firebase Auth (users عالقة من تجارب سابقة فاشلة)
- [ ] **توليد `firebase_options.dart`** — يتولّد محلياً بـ `flutterfire configure` ولازم يتعمل كل مرة على جهاز جديد
- [ ] **اختبار لوحة تحكم الأدمن** — الكود موجود في `admin_dashboard/` لكن لم يُشغَّل
- [ ] **بناء APK** — لم يتم بعد
- [ ] **إنشاء حساب أدمن** في Firestore

---

## بيئة التطوير على جهاز المالك (Windows)

### مثبّت ويعمل ✅

| الأداة | الإصدار |
|--------|---------|
| نظام التشغيل | Windows 11 — 25H2 (Build 26200.8037) |
| Flutter SDK | 3.41.5 stable — المسار: `C:\src\flutter` |
| Android SDK | 36.1.0 |
| Visual Studio Build Tools | 2026 18.4.1 |
| Chrome | مثبت |
| Node.js | v24.14.0 |
| Firebase CLI | 15.11.0 |
| FlutterFire CLI | 1.3.1 |
| Git for Windows | مثبت |
| Visual Studio Code | مثبت |

### flutter doctor (نظيف بالكامل) ✅

[√] Flutter (Channel stable, 3.41.5) [√] Windows Version (Windows 11, 25H2) [√] Android toolchain (Android SDK version 36.1.0) [√] Chrome [√] Visual Studio (Build Tools 2026 18.4.1) [√] Connected device (3 available) [√] Network resources • No issues found!



### ملاحظة عن PATH

أوامر `flutter` تعمل فقط من `C:\src\flutter\bin`. لو حابب تشغلها من أي مكان، لازم تضيف `C:\src\flutter\bin` إلى System Environment Variables → PATH.

### مسار المشروع على الجهاز


C:\Users\LENOVO\Downloads\Compressed\investors-club-app-main\investors-club-app-main\



---

## Firebase Project Info

| المعلومة | القيمة |
|----------|--------|
| Project ID | `investors-club-fcc36` |
| Android Package | `com.vcmem.investorsclub` |
| Android App ID | `1:1070920642889:android:10e5523568e920b7532a98` |
| Web App ID | `1:1070920642889:web:aebf5a574a509edf532a98` |
| Firestore Rules | تم Deploy ✅ |
| Auth Method | Email/Password (بدون OTP) |

---

## خطوات الاستكمال للمطور القادم

### أول حاجة: توليد firebase_options.dart

```bash
cd mobile
flutterfire configure --platforms=android,web --android-package-name=com.vcmem.investorsclub --project=investors-club-fcc36


تاني حاجة: إصلاح اللوجو
على GitHub ملف الصورة اسمه Logo.png.png. لازم يتغير إلى logo.png:

Copycd mobile/assets/images
ren "Logo.png.png" "logo.png"
تالت حاجة: إنشاء فولدر icons (لو مش موجود)
Copymkdir mobile/assets/icons
رابع حاجة: تثبيت الـ packages
Copycd mobile
flutter pub upgrade --major-versions
flutter pub get
خامس حاجة: مسح users قديمة
روح https://console.firebase.google.com/project/investors-club-fcc36/authentication/users وامسح أي users موجودة من تجارب سابقة.

سادس حاجة: تشغيل التطبيق
Copy# على الويب (للتجربة السريعة)
cd mobile
flutter run -d web-server
# افتح الرابط اللي يظهر في المتصفح

# على Android (موبايل أو emulator)
flutter run

# بناء APK
flutter build apk
# الملف: build/app/outputs/flutter-apk/app-release.apk
سابع حاجة: تشغيل لوحة تحكم الأدمن
Copycd admin_dashboard
flutter pub get
flutter run -d chrome
تامن حاجة: إنشاء حساب أدمن
سجّل حساب عادي من التطبيق
روح Firebase Console → Firestore → collection members
افتح الـ document بتاع الحساب اللي عملته
غيّر حقل role من member إلى admin
دلوقتي تقدر تدخل لوحة التحكم بالحساب ده
Tech Stack
العنصر	التقنية
تطبيق الموبايل	Flutter (Dart) — Android + iOS
لوحة تحكم الأدمن	Flutter Web
Authentication	Firebase Auth (Email/Password — بدون OTP)
قاعدة البيانات	Cloud Firestore
التخزين (صور)	Firebase Storage
الاستضافة (لوحة التحكم)	Firebase Hosting
إدارة الحالة	Riverpod
التنقل	GoRouter
الخط	IBM Plex Sans Arabic
الألوان
العنصر	القيمة
Dark Navy (أساسي)	#1a1a2e
Gold (ذهبي)	#c9a84c
أبيض	#ffffff
رمادي فاتح	#f5f5f5
رمادي غامق	#333333
هيكل المشروع
mobile/
├── lib/
│   ├── main.dart
│   ├── firebase_options.dart          ← يتولّد بـ flutterfire configure (مش في الـ repo)
│   ├── app/
│   │   ├── app.dart
│   │   ├── routes.dart
│   │   └── providers.dart
│   ├── features/
│   │   ├── auth/
│   │   │   ├── screens/
│   │   │   │   ├── splash_screen.dart
│   │   │   │   ├── login_screen.dart
│   │   │   │   └── signup_screen.dart    ← معدّل ✅
│   │   │   └── services/
│   │   │       └── auth_service.dart     ← معدّل ✅
│   │   ├── home/
│   │   ├── profile/
│   │   ├── chat/
│   │   ├── referral/
│   │   └── shell/
│   └── shared/
├── assets/
│   ├── images/
│   │   └── logo.png                      ← ⚠️ محتاج rename من Logo.png.png
│   ├── icons/                             ← فولدر فاضي (لازم يكون موجود)
│   └── fonts/
└── pubspec.yaml

admin_dashboard/
├── lib/
│   ├── main.dart
│   ├── features/
│   │   ├── auth/ → admin_login_screen.dart
│   │   ├── dashboard/ → dashboard_screen.dart
│   │   ├── members/ → members_screen.dart + member_detail_screen.dart
│   │   ├── offers/ → offers_screen.dart + offer_form_screen.dart
│   │   ├── chat/ → admin_chat_screen.dart
│   │   ├── referrals/ → referrals_screen.dart
│   │   └── shell/ → admin_shell.dart
│   └── shared/constants/
└── pubspec.yaml

firebase/
├── firebase.json
├── firestore.rules            ← معدّل ✅ + تم Deploy ✅
├── firestore.indexes.json
└── storage.rules
قاعدة البيانات (Firestore)
Collection: members
الحقل	النوع	ملاحظات
uid	string	Firebase Auth UID
fullName	string	الاسم الكامل
email	string	البريد الإلكتروني
phone	string	رقم الجوال
nationalId	string	لا يُعدَّل أبداً بعد التسجيل
city	string	المدينة
jobTitle	string	الوظيفة
investmentLevel	string	medium / high
interests	array	الاهتمامات
role	string	member أو admin
status	string	active / suspended / vip
invitedBy	string	كود المُحيل (اختياري)
referralCode	string	كود إحالة فريد
language	string	ar أو en
agreedToTerms	boolean	الموافقة على الشروط
createdAt	timestamp	تاريخ التسجيل
updatedAt	timestamp	آخر تحديث
Collection: offers
الحقل	النوع	ملاحظات
title_ar / title_en	string	العنوان
body_ar / body_en	string	المحتوى
summary_ar / summary_en	string	ملخص
category	string	تصنيف
images	array	روابط الصور
isVIP	boolean	عرض VIP
status	string	published / draft / hidden
Collection: supportChats/{memberId}/messages
الحقل	النوع	ملاحظات
senderId	string	UID المُرسل
senderRole	string	member أو admin
text	string	نص الرسالة
timestamp	timestamp	وقت الإرسال
isRead	boolean	هل تم القراءة
التعديلات اللي اتعملت على الكود (مارس 2026)
1. auth_service.dart — إضافة Cleanup
لو Firebase Auth نجح بس Firestore فشل، الكود الجديد بيمسح الـ user من Auth أوتوماتيك عشان المستخدم يقدر يجرب تاني بنفس الإيميل. وبيطبع debugPrint في كل خطوة عشان يسهل تتبع الأخطاء.

2. signup_screen.dart — رسائل خطأ أوضح
ضفنا رسائل لـ PERMISSION_DENIED و too-many-requests + debugPrint لطباعة الخطأ الحقيقي في الـ console.

3. firestore.rules — تبسيط شرط التسجيل
شيلنا شرط nationalId is string && nationalId.size() == 10 من قاعدة الـ create عشان كان بيمنع التسجيل. الشروط الحالية: role == 'member' + status == 'active' + agreedToTerms == true بس.

ملاحظات مهمة للمطور
التسجيل بالإيميل والباسورد فقط — لا OTP ولا phone auth
ملف firebase_options.dart مش في الـ repo — لازم تولّده بـ flutterfire configure
رقم الهوية لا يُعدَّل — لا من التطبيق ولا من لوحة التحكم
الشات نصي فقط — إرسال صور مرحلة لاحقة
لوحة الأدمن لم تُختبر — الكود جاهز بس محتاج تشغيل وتجربة
لا يوجد Push Notifications — ممكن تتضاف لاحقاً
لا يوجد تغيير لوجو من الداشبورد — اللوجو ثابت في assets
مراحل التطوير
المرحلة الحالية 🔴
 إصلاح اللوجو (rename على GitHub)
 اختبار التسجيل وتسجيل الدخول
 اختبار لوحة تحكم الأدمن
 بناء APK تجريبي
 إنشاء حساب أدمن
المرحلة القادمة 🟡
 رفع لوحة التحكم على Firebase Hosting
 Push Notifications
 إرسال صور في الشات
 بناء نسخة iOS (محتاج Mac)
المرحلة المتقدمة 🟢
 نشر على Google Play Store
 نشر على Apple App Store
 Firebase Analytics + Crashlytics
التواصل
مالك المشروع: Yasser
GitHub: https://github.com/Yasserpsd/investors-club-app
موقع نادي المستثمرين: https://vcmem.com/investors-club/

---

كده الـ README فيه كل حاجة وصلنا ليها: Firebase project ID، الـ App IDs، الأدوات المثبتة بالإصدارات الحقيقية، اللينكات المهمة، التعديلات اللي اتعملت، والخطوات بالظبط عشان أي حد يمسك المشروع ويكمّل من نفس النقطة.
