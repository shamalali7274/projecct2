# لوحة المسمعة — Musmiah Dashboard

## هيكلية المشروع

```
lib/
├── main.dart                          # نقطة الانطلاق (Theme + RTL + الصفحة الرئيسية)
│
├── core/                               # كل ما هو مشترك بين كل ميزات التطبيق
│   ├── theme/
│   │   ├── app_colors.dart            # ColorScheme فاتح/داكن (Material 3)
│   │   ├── app_text_styles.dart       # Amiri للعناوين + Tajawal للنصوص
│   │   ├── app_dimensions.dart        # قيم الحواف والمسافات الموحّدة
│   │   └── app_theme.dart             # يجمع كل ما سبق في ThemeData واحد
│   │
│   ├── widgets/                        # المكوّنات القابلة لإعادة الاستخدام
│   │   ├── app_card.dart              # البطاقة الأساسية (بدل تكرار Container)
│   │   ├── app_button.dart            # زر بأنماط متعددة (gradient/filled/outlined)
│   │   ├── stat_info_card.dart        # بطاقة إحصائية (تُستخدم 3 مرات بأعلى الصفحة)
│   │   ├── app_progress_bar.dart      # شريط تقدّم
│   │   ├── student_card.dart          # بطاقة الطالبة الكاملة
│   │   ├── app_search_field.dart      # حقل بحث + زر تصفية
│   │   ├── app_top_bar.dart           # الشريط العلوي
│   │   ├── app_bottom_nav.dart        # شريط التنقل السفلي العائم
│   │   └── app_fab.dart               # الزر العائم
│   │
│   ├── network/
│   │   └── api_client.dart            # عميل Dio مركزي (جاهز، غير مفعّل بعد)
│   │
│   └── bloc/
│       └── request_status.dart        # enum عام لحالات أي Bloc لاحقاً
│
└── features/
    └── dashboard/
        ├── domain/entities/            # الكيانات (Entities) المستقلة عن مصدر البيانات
        │   ├── student_entity.dart
        │   └── dashboard_stats_entity.dart
        │
        ├── data/models/                # نماذج التحويل من/إلى JSON (لاحقاً مع Dio)
        │   └── student_model.dart
        │
        └── presentation/pages/
            └── dashboard_page.dart     # الصفحة النهائية (بيانات Mock مؤقتة)
```

## المبادئ المتّبعة

1. **Clean Code + OOP**: كل مكوّن مسؤول عن شيء واحد فقط (Single Responsibility)،
   والطبقات مفصولة (`domain` مستقل عن `data` ومستقل عن `presentation`).
2. **عدم التكرار**: أي عنصر تكرر ظهوره في التصميم (بطاقة، زر، شريط تقدّم...)
   بُني كـ Widget مستقل مرة واحدة في `core/widgets/` ويُستدعى بخصائص مختلفة
   (لون، حجم، نص) بدل نسخ الكود.
3. **الثيم الفاتح والداكن**: كل الألوان تُستدعى حصراً عبر
   `Theme.of(context).colorScheme` — لا يوجد أي كود لون (Hex) مكتوب مباشرة
   داخل أي Widget، لذلك التبديل بين الوضعين يعمل تلقائياً في كل الشاشة.
4. **جاهزية BLoC + Dio**: تم تجهيز `ApiClient` (في `core/network`) و
   `StudentModel.fromJson/toJson` (في `data/models`) والهيكلية الثلاثية
   (domain/data/presentation) **لكن لم تُفعَّل بعد بناءً على طلبك** — الصفحة
   الحالية تستخدم بيانات وهمية (Mock) محلياً داخل `dashboard_page.dart`.

## خطوات الربط مع الباك ايند لاحقاً (لا تحتاجينها الآن)

عندما تصبحين جاهزة للربط، الخطوات ستكون:
1. إنشاء `StudentRepository` في `data/repositories/` يستخدم `ApiClient.instance.dio`
   ويُرجع `List<StudentModel>`.
2. إنشاء `DashboardBloc` في `presentation/bloc/` بحالات
   (initial/loading/success/failure) باستخدام `RequestStatus` الجاهز.
3. استبدال قائمة `_students` و `_stats` الثابتة في `DashboardPage` بـ
   `BlocBuilder<DashboardBloc, DashboardState>`.
4. **لن تحتاجي لتعديل أي Widget داخل `core/widgets/`** لأنها تتعامل مع
   `StudentEntity` فقط بغض النظر عن مصدره.

## التشغيل

```bash
flutter pub get
flutter run
```

> ملاحظة: الخطوط (Amiri, Tajawal) تُجلب عبر حزمة `google_fonts` وتحتاج
> اتصال إنترنت أول مرة للتحميل والتخزين المؤقت. عند الإصدار النهائي
> يُفضّل تضمينها محلياً (Bundled Fonts) لدعم العمل بدون إنترنت.
