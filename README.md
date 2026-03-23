# investors-club-app
Investors Club - Mobile App + Admin Dashboard (Flutter)
# نادي المستثمرين | Investors Club App

> تطبيق موبايل لأعضاء نادي المستثمرين + لوحة تحكم ويب للأدمن

---

## وصف عام للمشروع

مشروع: تطبيق **نادي المستثمرين** + لوحة تحكم للأدمن.

### الهدف
- تطبيق موبايل لأعضاء نادي المستثمرين لعرض العروض الاستثمارية والتواصل مع الإدارة.
- لوحة تحكم ويب للأدمن لإدارة الأعضاء، العروض، والشات.

### المنصات المستهدفة
- موبايل: Android + iOS
- ويب: لوحة تحكم Admin فقط

### الهوية والتصميم
الاعتماد على نفس الهوية والتصميم والمحتوى الموجود في موقع نادي المستثمرين:
- صفحة نادي المستثمرين (العربية): https://vcmem.com/investors-club/
- صفحة نادي المستثمرين (الإنجليزية): https://vcmem.com/en/investors-club/
- صفحة التحديثات / أحدث الأخبار والعروض: https://vcmem.com/update/

### الهوية البصرية والألوان
| العنصر | القيمة | الاستخدام |
|--------|--------|-----------|
| اللون الأساسي (Dark Navy) | `#1a1a2e` | الخلفيات والهيدر |
| اللون الذهبي (Gold) | `#c9a84c` | الأزرار والعناصر البارزة |
| الأبيض | `#ffffff` | النصوص على الخلفيات الداكنة |
| رمادي فاتح | `#f5f5f5` | خلفيات الكروت |
| رمادي غامق | `#333333` | النص العادي |

> ⚠️ الألوان أعلاه تقريبية — يُرجى مطابقتها بدقة من CSS الموقع الرسمي

### الخط (Font)
- العربي: خط Tajawal أو Cairo (حسب الموقع)
- الإنجليزي: نفس الخط أو Poppins

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
| إدارة الحالة | Riverpod (أو Provider) |
| الترجمة | flutter_localizations + intl (ARB files) |
| اتجاه النص | RTL للعربي / LTR للإنجليزي |

---

## هيكل المشروع (Project Structure)

investors-club-app/ ├── mobile/ ← تطبيق Flutter للموبايل │ └── lib/ │ ├── main.dart │ ├── app/ │ │ ├── app.dart │ │ ├── routes.dart │ │ └── theme.dart │ ├── features/ │ │ ├── auth/ │ │ │ ├── screens/ │ │ │ │ ├── splash_screen.dart │ │ │ │ ├── login_screen.dart │ │ │ │ └── signup_screen.dart │ │ │ ├── widgets/ │ │ │ └── services/ │ │ │ └── auth_service.dart │ │ ├── home/ │ │ │ ├── screens/ │ │ │ │ ├── home_screen.dart │ │ │ │ └── offer_detail_screen.dart │ │ │ ├── widgets/ │ │ │ │ └── offer_card.dart │ │ │ └── services/ │ │ │ └── offers_service.dart │ │ ├── profile/ │ │ │ ├── screens/ │ │ │ │ └── profile_screen.dart │ │ │ └── services/ │ │ │ └── profile_service.dart │ │ ├── chat/ │ │ │ ├── screens/ │ │ │ │ └── chat_screen.dart │ │ │ ├── widgets/ │ │ │ │ └── message_bubble.dart │ │ │ └── services/ │ │ │ └── chat_service.dart │ │ └── referral/ │ │ ├── screens/ │ │ │ └── referral_screen.dart │ │ └── services/ │ │ └── referral_service.dart │ ├── shared/ │ │ ├── models/ │ │ │ ├── member_model.dart │ │ │ ├── offer_model.dart │ │ │ └── message_model.dart │ │ ├── widgets/ │ │ │ ├── custom_button.dart │ │ │ ├── custom_text_field.dart │ │ │ └── loading_widget.dart │ │ ├── constants/ │ │ │ ├── app_colors.dart │ │ │ ├── app_strings.dart │ │ │ └── app_assets.dart │ │ └── utils/ │ │ └── validators.dart │ └── l10n/ │ ├── app_ar.arb │ └── app_en.arb │ ├── admin_dashboard/ ← لوحة تحكم Flutter Web │ └── lib/ │ ├── main.dart │ ├── app/ │ ├── features/ │ │ ├── auth/ │ │ ├── dashboard/ │ │ ├── members/ │ │ ├── offers/ │ │ ├── chat/ │ │ └── referrals/ │ └── shared/ │ ├── firebase/ ← إعدادات Firebase │ ├── firestore.rules │ ├── firestore.indexes.json │ └── firebase.json │ └── docs/ ← مستندات المشروع ├── database_schema.md └── assets/

---

## قاعدة البيانات (Firestore Collections)

### Collection: `members`
| الحقل | النوع | ملاحظات |
|-------|-------|---------|
| uid | string | Firebase Auth UID (المفتاح الأساسي) |
| fullName | string | الاسم الكامل |
| email | string | البريد الإلكتروني |
| phone | string | رقم الجوال مع كود الدولة (+966) |
| nationalId | string | **رقم الهوية — لا يُعدَّل بعد التسجيل** |
| city | string | المدينة / المنطقة |
| jobTitle | string | الوظيفة أو المسمى المهني |
| investmentLevel | string | القدرة المالية / مستوى الاستثمار |
| interests | array | نوع الاهتمام الاستثماري |
| howDidYouKnow | string | كيف عرفت عن النادي |
| role | string | `member` (افتراضي) أو `admin` |
| status | string | `active` / `suspended` / `vip` |
| invitedBy | string | UID العضو المُحيل (nullable) |
| referralCode | string | كود الإحالة الفريد |
| language | string | `ar` أو `en` |
| agreedToTerms | boolean | الموافقة على الشروط |
| createdAt | timestamp | تاريخ التسجيل |
| updatedAt | timestamp | آخر تحديث |

### Collection: `offers`
| الحقل | النوع | ملاحظات |
|-------|-------|---------|
| offerId | string | معرّف تلقائي |
| title_ar | string | العنوان بالعربي |
| title_en | string | العنوان بالإنجليزي |
| body_ar | string | المحتوى بالعربي |
| body_en | string | المحتوى بالإنجليزي |
| summary_ar | string | ملخص عربي |
| summary_en | string | ملخص إنجليزي |
| category | string | تصنيف / نوع الفرصة |
| images | array | قائمة روابط الصور |
| links | array | روابط خارجية |
| isVIP | boolean | عرض VIP أو لا |
| status | string | `published` / `draft` / `hidden` |
| publishDate | timestamp | تاريخ النشر |
| createdAt | timestamp | تاريخ الإنشاء |
| updatedAt | timestamp | آخر تحديث |

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

## الجزء الأول: تطبيق الموبايل

### 1) شاشة البداية وتسجيل الدخول

**Splash Screen:**
- شاشة أولية بشعار نادي المستثمرين
- خلفية داكنة (Dark Navy) مع اللوقو في المنتصف
- مدة 2-3 ثوانٍ ثم انتقال تلقائي

**شاشة Login:**
- شعار نادي المستثمرين أعلى الشاشة
- تبويبان: "تسجيل الدخول" + "إنشاء حساب جديد"
- حقول تسجيل الدخول: البريد الإلكتروني + كلمة المرور
- زر "نسيت كلمة المرور" → إرسال إيميل Reset
- عند النجاح → جلب بيانات العضو وتخزينها في الـ state

**شاشة Sign Up:**
- **الحقول مطابقة تماماً لنموذج التسجيل في الموقع:**
  - https://vcmem.com/investors-club/#subscribe
- تشمل: الاسم، الهوية، الجوال، البريد، المدينة، الوظيفة، مستوى الاستثمار، إلخ
- Checkbox موافقة على الشروط
- عند الضغط "إنشاء حساب":
  - إنشاء مستخدم في Firebase Auth
  - تخزين البيانات في collection `members` مع `role = 'member'`

### 2) الشاشة الرئيسية (Home)

- عرض أحدث العروض الاستثمارية كـ Card List
- كل كارت: عنوان + ملخص (2-3 أسطر) + تاريخ النشر + تصنيف
- الضغط على كارت → صفحة تفاصيل العرض الكاملة
- التصميم مستوحى من: https://vcmem.com/update/

### 3) صفحة حسابي (Profile)

- عرض كل بيانات العضو
- تعديل: الاسم، البريد، الجوال، المدينة، الوظيفة، التفضيلات
- **رقم الهوية: Read-only فقط — لا يُعدَّل**
- زر تغيير اللغة (عربي/إنجليزي)
- زر تسجيل الخروج

### 4) الشات مع الإدارة (In-App Chat)

- زر "تواصل مع الإدارة" أو "الدعم"
- شاشة شات one-to-one بين العضو والإدارة
- رسائل نصية مع عرض الوقت والتاريخ
- التخزين في: `supportChats/{memberId}/messages`
- الإدارة ترد من لوحة تحكم الأدمن

### 5) دعوة صديق (Referral)

- زر "دعوة صديق" في القائمة أو صفحة الحساب
- توليد رابط/كود إحالة فريد (`ref=memberId`)
- مشاركة عبر Share Sheet (واتساب، SMS، بريد)
- العضو الجديد المسجّل من رابط إحالة يُخزَّن له `invitedBy = memberId`

### 6) دعم لغتين (AR / EN)

- كل النصوص قابلة للترجمة (لا نص ثابت في الكود)
- ملفات: `app_ar.arb` + `app_en.arb`
- العربي: RTL / الإنجليزي: LTR
- حفظ اختيار اللغة محلياً وعلى الحساب

---

## الجزء الثاني: لوحة تحكم الأدمن (Admin Dashboard — Web)

### 1) تسجيل الدخول

- صفحة Login ويب (Email + Password)
- التحقق أن المستخدم `role = 'admin'`
- غير Admin → لا يدخل

### 2) لوحة الإحصائيات (Dashboard Home)

- إجمالي عدد الأعضاء
- عدد الأعضاء النشطين
- أعضاء جدد آخر 30 يوم
- عدد العروض المنشورة
- عدد المحادثات المفتوحة
- عدد الإحالات الناجحة

### 3) إدارة الأعضاء (Members)

- جدول: الاسم، البريد، الجوال، الهوية، المدينة، الدور، الحالة
- عمليات: عرض / تحرير / حذف / إرسال Reset Password
- **رقم الهوية لا يُعدَّل حتى من الأدمن**
- بحث بالاسم / البريد / الهوية
- فلاتر حسب الحالة والدور

### 4) إدارة العروض (Offers)

- جدول: العنوان، تاريخ النشر، التصنيف، الحالة
- إضافة عرض جديد: عنوان، نص، صور، روابط، تصنيف، VIP، تاريخ
- تعديل / حذف / إخفاء عرض
- العروض تظهر في تطبيق الموبايل

### 5) إدارة الشات (Chat)

- قائمة المحادثات: اسم العضو، آخر رسالة، الوقت
- فتح محادثة → عرض كل الرسائل + إرسال رد فوري
- الرسائل مرتبطة بـ memberId

### 6) إدارة الإحالات (Referrals)

- لكل عضو: عدد المدعوين + أسماؤهم + تاريخ تسجيلهم
- تصدير CSV لكل الإحالات

---

## الصلاحيات والـ Roles

| الحالة | السلوك |
|--------|--------|
| تسجيل حساب جديد من التطبيق | `role = 'member'` تلقائياً |
| حسابات الأدمن | تُنشأ يدوياً من Backend أو لوحة التحكم |
| عضو عادي في التطبيق | يشوف واجهة الأعضاء فقط |
| أدمن في التطبيق | زر يفتح رابط لوحة التحكم الويب |

---

## ملاحظات مهمة

1. **الهوية البصرية**: الالتزام بنفس ألوان وتصميم https://vcmem.com/investors-club/
2. **كل النصوص قابلة للترجمة** (AR/EN) — لا نص ثابت في الكود
3. **رقم الهوية لا يُعدَّل** بعد التسجيل — لا من التطبيق ولا من لوحة التحكم
4. **الشات نصي فقط** في هذه المرحلة — إرسال ملفات/صور مرحلة لاحقة
5. **كود نظيف**: Clean Architecture أو تقسيم منطقي واضح (screens, widgets, services, repositories)

---

## روابط مرجعية

| الوصف | الرابط |
|-------|--------|
| نادي المستثمرين (عربي) | https://vcmem.com/investors-club/ |
| نادي المستثمرين (إنجليزي) | https://vcmem.com/en/investors-club/ |
| صفحة التحديثات | https://vcmem.com/update/ |
| نموذج التسجيل | https://vcmem.com/investors-club/#subscribe |
