تمام، دلوقتي عندي كل المعلومات. هديك **README.md** كامل محدّث فيه كل حاجة: وصف المشروع + وضع البيئة الحالية + المشاكل المعروفة + الخطوات المطلوبة عشان أي مطور يمسك المشروع ويكمّل.

---

هنا الملف الكامل، **انسخه كله** واستبدله بالـ README.md الحالي:

```markdown
# نادي المستثمرين | Investors Club App

> تطبيق موبايل لأعضاء نادي المستثمرين + لوحة تحكم ويب للأدمن

---

## وصف عام للمشروع

مشروع **نادي المستثمرين**: تطبيق موبايل (Android + iOS) لأعضاء النادي لعرض العروض الاستثمارية والتواصل مع الإدارة، بالإضافة إلى لوحة تحكم ويب للأدمن لإدارة الأعضاء والعروض والشات.

### الهوية والتصميم

التصميم مبني على نفس الهوية البصرية لموقع نادي المستثمرين:

| الوصف | الرابط |
|-------|--------|
| نادي المستثمرين (عربي) | https://vcmem.com/investors-club/ |
| نادي المستثمرين (إنجليزي) | https://vcmem.com/en/investors-club/ |
| صفحة التحديثات | https://vcmem.com/update/ |
| نموذج التسجيل | https://vcmem.com/investors-club/#subscribe |

### الألوان

| العنصر | القيمة |
|--------|--------|
| اللون الأساسي (Dark Navy) | `#1a1a2e` |
| اللون الذهبي (Gold) | `#c9a84c` |
| الأبيض | `#ffffff` |
| رمادي فاتح | `#f5f5f5` |
| رمادي غامق | `#333333` |

### الخط

- العربي: IBM Plex Sans Arabic
- الإنجليزي: IBM Plex Sans Arabic (نفس الخط)

---

## Tech Stack

| العنصر | التقنية |
|--------|---------|
| تطبيق الموبايل | Flutter (Dart) — Android + iOS |
| لوحة تحكم الأدمن | Flutter Web |
| Authentication | Firebase Auth (Email/Password) |
| قاعدة البيانات | Cloud Firestore |
| التخزين (صور) | Firebase Storage |
| الاستضافة (لوحة التحكم) | Firebase Hosting |
| إدارة الحالة | Riverpod |
| التنقل | GoRouter |
| الترجمة | flutter_localizations + intl |

---

## ⚠️ الوضع الحالي للمشروع (آخر تحديث: مارس 2026)

### ما تم إنجازه ✅

- كود تطبيق الموبايل مكتمل (جميع الشاشات والـ services)
- كود لوحة تحكم الأدمن (Dashboard Web) مكتمل
- Firestore Security Rules مكتوبة
- Firestore Indexes جاهزة
- Firebase Storage Rules مكتوبة
- الخطوط (IBM Plex Sans Arabic) موجودة في assets
- اللوجو موجود في assets

### مشاكل معروفة ومطلوب إصلاحها 🔧

#### 1. التسجيل لا يعمل

**المشكلة:** عند محاولة إنشاء حساب جديد، يظهر "خطأ في إنشاء الحساب" دائماً.

**الأسباب:**
- ملف `firebase_options.dart` غير موجود (محتاج `flutterfire configure`)
- الـ Firestore Rules تحتاج deploy
- لو الـ Auth نجح بس Firestore فشل، الـ user يبقى عالق في Auth بدون document — والكود القديم ما كان يعمل cleanup
- **الحل موجود في الملف المعدّل** `auth_service.dart` (انظر قسم الملفات المعدّلة)

#### 2. اللوجو مش ظاهر في Splash Screen و Login و Signup

**السبب:** ملف الصورة اسمه `Logo.png.png` (مكرر) بينما الكود بيدور على `logo.png`

**الحل:**
```bash
cd mobile/assets/images
ren "Logo.png.png" "logo.png"
```

#### 3. الداشبورد لم يُجرَّب بعد

لوحة تحكم الأدمن مكتوبة لكن لم يتم تشغيلها أو اختبارها بعد.

---

## بيئة التطوير الحالية على جهاز المالك (Windows)

### مثبّت ✅

| الأداة | الإصدار / الحالة |
|--------|------------------|
| Flutter SDK | 3.41.5 stable — المسار: `C:\src\flutter` |
| Git for Windows | مثبت ويعمل من أي مكان |
| Visual Studio Code | مثبت (يحتاج Flutter + Dart Extensions) |
| Android Studio | Panda 2 – 2025.3.2 |
| Android SDK | مثبت (أساسي فقط) |
| Node.js | غير مؤكد — يحتاج فحص |
| Firebase CLI | غير مثبت بعد |
| FlutterFire CLI | غير مثبت بعد |

### مشاكل بيئة التطوير ⚠️

| المشكلة | التفاصيل |
|---------|----------|
| Flutter PATH | أوامر `flutter` تعمل فقط من داخل `C:\src\flutter\bin` — محتاج إضافة PATH بشكل صحيح في Environment Variables |
| Android cmdline-tools | مكون `cmdline-tools` غير مثبت — `flutter doctor` يعرض تحذير |
| Android Licenses | لم تُقبل بالكامل — أمر `flutter doctor --android-licenses` لم يُنفَّذ |
| Android Emulator | لم يتم إعداد أي محاكي بعد |
| Firebase CLI | غير مثبت — محتاج `npm install -g firebase-tools` |
| FlutterFire CLI | غير مثبت — محتاج `dart pub global activate flutterfire_cli` |
| firebase_options.dart | غير موجود — محتاج `flutterfire configure` |

### ما تم تجربته ✅

- `flutter --version` يعمل من `C:\src\flutter\bin`
- `flutter doctor` يعمل (Flutter سليم، تحذيرات على Android فقط)
- تم إنشاء مشروع تجريبي `my_first_app` وشُغّل بنجاح على الويب (web-server)

---

## المسار الحالي للمشروع على الجهاز

```
C:\Users\LENOVO\Downloads\Compressed\investors-club-app-main\investors-club-app-main\
├── mobile/                 ← تطبيق الموبايل (Flutter)
├── admin_dashboard/        ← لوحة تحكم الأدمن (Flutter Web)
├── firebase/               ← إعدادات Firebase (rules, indexes)
├── README.md               ← هذا الملف
└── HANDOFF.md              ← دليل التسليم للمطور
```

---

## خطوات إعداد المشروع للمطور الجديد

### الخطوة 1: إصلاح بيئة التطوير

```bash
# 1. إضافة Flutter إلى PATH (أو شغّل من C:\src\flutter\bin)

# 2. ثبّت Android cmdline-tools من Android Studio:
#    Android Studio → Settings → SDK Manager → SDK Tools → Android SDK Command-line Tools → Install

# 3. اقبل Android Licenses
flutter doctor --android-licenses

# 4. تأكد كل شيء سليم
flutter doctor
```

### الخطوة 2: إعداد Firebase

```bash
# 1. ثبّت Firebase CLI
npm install -g firebase-tools

# 2. سجّل دخول
firebase login

# 3. ثبّت FlutterFire CLI
dart pub global activate flutterfire_cli

# 4. ادخل فولدر mobile وولّد firebase_options.dart
cd mobile
flutterfire configure
```

**إعدادات Firebase Console المطلوبة:**
1. أنشئ مشروع Firebase جديد في https://console.firebase.google.com
2. فعّل Authentication → Email/Password
3. أنشئ Firestore Database
4. فعّل Firebase Storage
5. أضف تطبيق Android (package: `com.vcmem.investorsclub`)
6. أضف تطبيق iOS (bundle: `com.vcmem.investorsclub`)
7. أضف تطبيق Web (للوحة الأدمن)

### الخطوة 3: إصلاح اسم اللوجو

```bash
cd mobile/assets/images
ren "Logo.png.png" "logo.png"
```

### الخطوة 4: Deploy الـ Firestore Rules

```bash
cd firebase
firebase deploy --only firestore:rules
firebase deploy --only firestore:indexes
```

### الخطوة 5: تشغيل التطبيق

```bash
# تطبيق الموبايل
cd mobile
flutter pub get
flutter run

# لوحة تحكم الأدمن
cd admin_dashboard
flutter pub get
flutter run -d chrome
```

### الخطوة 6: بناء APK للتجربة

```bash
cd mobile
flutter build apk
# الملف: build/app/outputs/flutter-apk/app-release.apk
```

---

## الملفات اللي تحتاج تعديل (مشاكل التسجيل)

### 1. `mobile/lib/features/auth/services/auth_service.dart`

**التعديل:** إضافة cleanup — لو Firestore فشل بعد ما Auth نجح، يمسح الـ user من Auth عشان يقدر يسجل تاني بنفس الإيميل. وإضافة `debugPrint` في كل خطوة للتتبع.

### 2. `mobile/lib/features/auth/screens/signup_screen.dart`

**التعديل:** إضافة رسائل خطأ أوضح (PERMISSION_DENIED, too-many-requests) وإضافة `debugPrint` لطباعة الخطأ الحقيقي في الـ console.

### 3. `firebase/firestore.rules`

**التعديل:** تبسيط شرط الـ create في collection members — شيلنا شرط `nationalId.size() == 10` من الـ rules لأنه كان يمنع التسجيل لو فيه أي اختلاف بسيط.

> ⚡ النسخ المعدّلة الكاملة لهذه الملفات موجودة في conversation history مع المالك — اطلبها منه.

---

## هيكل المشروع التفصيلي

```
mobile/
├── lib/
│   ├── main.dart
│   ├── firebase_options.dart          ← يتولّد بـ flutterfire configure
│   ├── app/
│   │   ├── app.dart                   ← MaterialApp + Theme + Localization
│   │   ├── routes.dart                ← GoRouter routes
│   │   └── providers.dart             ← Riverpod providers (language, auth, member)
│   ├── features/
│   │   ├── auth/
│   │   │   ├── screens/
│   │   │   │   ├── splash_screen.dart
│   │   │   │   ├── login_screen.dart
│   │   │   │   └── signup_screen.dart
│   │   │   └── services/
│   │   │       └── auth_service.dart
│   │   ├── home/
│   │   │   ├── screens/
│   │   │   │   ├── home_screen.dart
│   │   │   │   └── offer_detail_screen.dart
│   │   │   ├── widgets/
│   │   │   │   └── offer_card.dart
│   │   │   └── services/
│   │   │       └── offers_service.dart
│   │   ├── profile/
│   │   │   ├── screens/
│   │   │   │   └── profile_screen.dart
│   │   │   └── services/
│   │   │       └── profile_service.dart
│   │   ├── chat/
│   │   │   ├── screens/
│   │   │   │   └── chat_screen.dart
│   │   │   ├── widgets/
│   │   │   │   └── message_bubble.dart
│   │   │   └── services/
│   │   │       └── chat_service.dart
│   │   ├── referral/
│   │   │   ├── screens/
│   │   │   │   └── referral_screen.dart
│   │   │   └── services/
│   │   │       └── referral_service.dart
│   │   └── shell/
│   │       └── main_shell.dart        ← Bottom Navigation wrapper
│   └── shared/
│       ├── models/
│       │   └── member_model.dart
│       ├── widgets/
│       │   ├── custom_button.dart
│       │   └── custom_text_field.dart
│       └── constants/
│           ├── app_colors.dart
│           └── app_theme.dart
├── assets/
│   ├── images/
│   │   └── logo.png                   ← ⚠️ اسمه حالياً Logo.png.png — محتاج rename
│   └── fonts/
│       └── IBMPlexSansArabic-*.ttf
└── pubspec.yaml

admin_dashboard/
├── lib/
│   ├── main.dart
│   ├── app/
│   │   └── admin_routes.dart
│   ├── features/
│   │   ├── auth/screens/
│   │   │   └── admin_login_screen.dart
│   │   ├── dashboard/screens/
│   │   │   └── dashboard_screen.dart     ← إحصائيات
│   │   ├── members/screens/
│   │   │   ├── members_screen.dart       ← جدول الأعضاء
│   │   │   └── member_detail_screen.dart ← تفاصيل عضو
│   │   ├── offers/screens/
│   │   │   ├── offers_screen.dart        ← جدول العروض
│   │   │   └── offer_form_screen.dart    ← إضافة/تعديل عرض
│   │   ├── chat/screens/
│   │   │   └── admin_chat_screen.dart    ← الرد على الأعضاء
│   │   ├── referrals/screens/
│   │   │   └── referrals_screen.dart     ← تتبع الإحالات
│   │   └── shell/
│   │       └── admin_shell.dart          ← Sidebar navigation
│   └── shared/constants/
│       ├── admin_colors.dart
│       └── admin_theme.dart
└── pubspec.yaml

firebase/
├── firebase.json
├── firestore.rules        ← ⚠️ محتاج deploy بعد التعديل
├── firestore.indexes.json ← محتاج deploy
└── storage.rules
```

---

## قاعدة البيانات (Firestore Collections)

### Collection: `members`

| الحقل | النوع | ملاحظات |
|-------|-------|---------|
| uid | string | Firebase Auth UID |
| fullName | string | الاسم الكامل |
| email | string | البريد الإلكتروني |
| phone | string | رقم الجوال |
| nationalId | string | رقم الهوية — **لا يُعدَّل أبداً بعد التسجيل** |
| city | string | المدينة |
| jobTitle | string | الوظيفة |
| investmentLevel | string | القدرة المالية (medium / high) |
| interests | array | الاهتمامات |
| howDidYouKnow | string | كيف عرفت عن النادي |
| role | string | `member` (افتراضي) أو `admin` |
| status | string | `active` / `suspended` / `vip` |
| invitedBy | string | UID/كود المُحيل (اختياري) |
| referralCode | string | كود إحالة فريد يُولَّد تلقائياً |
| language | string | `ar` أو `en` |
| agreedToTerms | boolean | الموافقة على الشروط |
| createdAt | timestamp | تاريخ التسجيل |
| updatedAt | timestamp | آخر تحديث |

### Collection: `offers`

| الحقل | النوع | ملاحظات |
|-------|-------|---------|
| offerId | string | معرّف تلقائي |
| title_ar / title_en | string | العنوان |
| body_ar / body_en | string | المحتوى |
| summary_ar / summary_en | string | ملخص |
| category | string | تصنيف |
| images | array | روابط الصور |
| links | array | روابط خارجية |
| isVIP | boolean | عرض VIP |
| status | string | `published` / `draft` / `hidden` |
| publishDate | timestamp | تاريخ النشر |

### Collection: `supportChats/{memberId}/messages`

| الحقل | النوع | ملاحظات |
|-------|-------|---------|
| messageId | string | معرّف تلقائي |
| senderId | string | UID المُرسل |
| senderRole | string | `member` أو `admin` |
| text | string | نص الرسالة |
| timestamp | timestamp | وقت الإرسال |
| isRead | boolean | هل تم القراءة |

---

## الصلاحيات

| الحالة | السلوك |
|--------|--------|
| تسجيل جديد من التطبيق | `role = 'member'` تلقائياً |
| حسابات الأدمن | تُنشأ يدوياً من Firebase Console أو لوحة التحكم |
| عضو عادي | يشوف التطبيق فقط (عروض، شات، بروفايل، إحالة) |
| أدمن | يدخل لوحة التحكم الويب فقط |

---## ملاحظات للمطور القادم

1. **التسجيل بالإيميل والباسورد فقط** — تم إلغاء فكرة OTP نهائياً. التسجيل عادي: email + password → Firebase Auth → Firestore document.

2. **ملف `firebase_options.dart` غير موجود في الـ repo** — لازم تولّده بنفسك بـ `flutterfire configure` لأنه محطوط في `.gitignore` (فيه مفاتيح خاصة بمشروع Firebase).

3. **مشكلة الـ users العالقة في Firebase Auth** — بسبب مشكلة التسجيل القديمة، فيه users اتعملت في Firebase Auth بدون documents في Firestore. لازم تمسحهم من Firebase Console → Authentication → Users قبل ما تجرب بنفس الإيميلات.

4. **رقم الهوية (nationalId) لا يُعدَّل أبداً** — لا من التطبيق ولا من لوحة التحكم ولا من الـ rules. ده ثابت بعد التسجيل.

5. **كل النصوص قابلة للترجمة (AR/EN)** — لا نص ثابت في الكود. اللغة تتغير من البروفايل وتتحفظ محلياً.

6. **الشات نصي فقط** في هذه المرحلة — إرسال ملفات وصور ممكن يتضاف لاحقاً.

7. **لوحة تحكم الأدمن مكتوبة لكن لم تُختبر** — الكود موجود كامل في `admin_dashboard/` بس محتاج يتشغل ويتجرب ويتربط بنفس مشروع Firebase.

8. **إنشاء حساب أدمن** — لازم يدوياً: إما تعمل user عادي وتغير `role` إلى `admin` من Firebase Console → Firestore → members → الـ document → حقل role، أو من لوحة التحكم بعد ما تشتغل.

9. **لا يوجد إشعارات (Push Notifications) حالياً** — ممكن تتضاف كمرحلة لاحقة باستخدام Firebase Cloud Messaging.

10. **لا يوجد تغيير لوجو من الداشبورد حالياً** — اللوجو ثابت في assets. ممكن تتضاف ميزة رفع لوجو من الداشبورد على Firebase Storage كمرحلة لاحقة.

---

## مراحل التطوير المقترحة

### المرحلة الحالية (مطلوب الآن) 🔴
- [ ] إصلاح بيئة التطوير (PATH, Android toolchain, licenses)
- [ ] تشغيل `flutterfire configure` وتوليد `firebase_options.dart`
- [ ] إصلاح اسم اللوجو (`Logo.png.png` → `logo.png`)
- [ ] تطبيق تعديلات `auth_service.dart` (cleanup عند فشل Firestore)
- [ ] Deploy الـ Firestore Rules والـ Indexes
- [ ] مسح الـ users العالقة من Firebase Auth
- [ ] اختبار التسجيل وتسجيل الدخول بنجاح
- [ ] اختبار لوحة تحكم الأدمن على الويب
- [ ] بناء APK تجريبي واختباره على موبايل أندرويد

### المرحلة القادمة 🟡
- [ ] رفع لوحة التحكم على Firebase Hosting
- [ ] إضافة ميزة تغيير اللوجو من الداشبورد
- [ ] إضافة Push Notifications (Firebase Cloud Messaging)
- [ ] إضافة إرسال صور في الشات
- [ ] تحسين تجربة البحث والفلاتر في الداشبورد
- [ ] بناء نسخة iOS (يحتاج Mac + Apple Developer Account)

### المرحلة المتقدمة 🟢
- [ ] نشر التطبيق على Google Play Store
- [ ] نشر التطبيق على Apple App Store
- [ ] إضافة تحليلات (Firebase Analytics)
- [ ] إضافة Crashlytics لتتبع الأخطاء
- [ ] تصدير تقارير الأعضاء والإحالات CSV من الداشبورد

---

## التواصل

- **مالك المشروع:** Yasser
- **GitHub:** https://github.com/Yasserpsd/investors-club-app
- **موقع نادي المستثمرين:** https://vcmem.com/investors-club/
