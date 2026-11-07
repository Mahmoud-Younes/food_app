# المرحلة الأولى — توثيق ما تم (First Round)

> **الحالة:** ✅ مكتملة — التاريخ: 7 نوفمبر 2026
>
> تطبيق وصفات الطعام (Food Recipe App) لمذاكرة DEPI العملية، مبني على واجهة [TheMealDB](https://www.themealdb.com/api.php) بحزم الامتحان المسموح بها فقط، وببنية نظيفة تحاكي مشروع `doc_doc` المرجعي.

---

## 1) ما تم بناؤه

### الشاشات الأربع

| الشاشة | الوصف |
|---|---|
| **الرئيسية (Home)** | شريط تصنيفات أفقي (`ListView`) + شبكة وجبات بعمودين (`GridView`) لكل تصنيف، مع مؤشرات تحميل وحالات خطأ |
| **تفاصيل الوجبة (Meal Details)** | تُفتح بـ `idMeal`: صورة `SliverAppBar` قابلة للطي، قائمة المكونات بالمقاييس، خطوات التحضير، زر فيديو يوتيوب (`url_launcher`)، وزر مفضلة (قلب) |
| **البحث (Search)** | بحث بالاسم عبر `search.php?s=` مع معالجة الحالة الفارغة («No meals found») |
| **المفضلة (Favorites)** | شبكة الوجبات المحفوظة، إزالة بزر على البطاقة، تخزين محلي دائم بـ `shared_preferences` |

شاشة البداية (Splash) تنتقل تلقائيًا بعد ثانيتين، وشريط سفلي (`BottomNavigationBar` + `IndexedStack`) يربط الرئيسية/البحث/المفضلة.

### ميزات المكافأة (Bonus)

- **Hero animation** لانتقال صورة الوجبة من البطاقة إلى شاشة التفاصيل (`meal_card.dart` ↔ `meal_details_screen.dart`).
- **Debounce** في `SearchCubit` بمقدار 500ms لتقليل نداءات الشبكة أثناء الكتابة.

### البنية (Clean Architecture — بنمط doc_doc)

```
lib/
├── core/            di (ServiceLocator يدوي) · networking (dio) · routing · theming · shared widgets
└── features/<feature>/
    ├── data/        models (fromJson يدوي) + data sources
    ├── logic/       Cubits (flutter_bloc)
    └── ui/          Screens + Widgets
```

الحزم: `dio` · `flutter_bloc` · `cached_network_image` · `shared_preferences` · `url_launcher` — فقط (بدون `get_it`/`freezed`/`retrofit`)، راجع [ADR-0001](../adr/0001-exam-allowed-packages-with-doc-doc-structure.md).

---

## 2) الاختبارات

### اختبارات الوحدة (Unit)

`test/meal_model_test.dart` — 4 اختبارات لـ `fromJson` اليدوي مع null safety: **4/4 ناجحة** (`flutter test`).

### الاختبارات عبر e2e (محاكي أندرويد)

عبر إطار [e2e.com](https://e2e.com/docs/mobile) على محاكي أندرويد (1440×3120) — 7 اختبارات تحقق تغطي كل ميزة:

| الاختبار | ما يتحقق منه |
|---|---|
| Home loads categories with Beef active | تحميل التصنيفات وشبكة وجبات Beef |
| Switching category loads its own meals | تبديل التصنيف (Dessert) يحمّل وجباته |
| Meal details shows ingredients, steps, video | المكونات + خطوات التحضير + زر الفيديو بعد التمرير |
| Favoriting lists under Favorites and removes | الإضافة للمفضلة والإزالة |
| Favorites survive an app restart | بقاء المفضلة بعد إعادة تشغيل التطبيق (تخزين محلي) |
| Search finds meals by name | البحث عن Arrabiata يجد «Spicy Arrabiata Penne» |
| Search shows an empty state | نص «No meals found» عند عدم وجود نتائج |

ملاحظات تنفيذية:

- عناصر الواجهة التفاعلية تحمل معرّفات `Semantics(identifier:)` للوصول إليها في الاختبارات: `nav-home` · `nav-search` · `nav-favorites` · `search-field` · `favorite-toggle` · `remove-favorite`.
- Flutter يبني شرائح `CustomScrollView` الكامنة بتكاسل، لذا يمرّر الاختبار للأسفل قبل التحقق من العناصر أسفل الشاشة.
- بيانات TheMealDB مستقرة ويُعتمد عليها في التأكيدات: أول وجبة في `filter.php?c=Beef` هي «Algerian Kefta (Meatballs)»، و`search.php?s=Arrabiata` تعيد «Spicy Arrabiata Penne».
- **أدوات e2e محلية خاصة ولا تُرفع إلى GitHub** (`e2e.config.ts` و`tests/` و`package.json` و`node_modules/` في `.gitignore`) — المرفوع هو كود التطبيق والتوثيق والصور فقط.

---

## 3) الصور (لقطات كل ميزة)

| الملف | الحالة الملتقطة |
|---|---|
| `01-launch.png` | إقلاع التطبيق (بعد الشاشة الافتتاحية) |
| `02-home.png` | الرئيسية: تصنيفات + شبكة وجبات Beef بصور محمّلة |
| `03-category-dessert.png` | بعد تبديل التصنيف إلى Dessert |
| `04-meal-details.png` | شاشة تفاصيل الوجبة (المكونات) |
| `05-details-instructions.png` | أسفل التفاصيل: خطوات التحضير وزر الفيديو |
| `06-favorite-added.png` | بعد الضغط على القلب (تفعيل المفضلة) |
| `07-favorites.png` | تبويب المفضلة وفيه وجبة محفوظة |
| `08-favorites-empty.png` | المفضلة فارغة بعد الإزالة |
| `09-search-initial.png` | شاشة البحث قبل الكتابة |
| `10-search-results.png` | نتائج البحث عن Arrabiata |
| `11-search-empty.png` | الحالة الفارغة للبحث |

إضافة إلى لقطات خام من الجهاز (`Screenshot_*.png`) للاطلاع السريع.

---

## 4) كيفية التشغيل

```bash
flutter pub get
flutter run          # مع محاكي/جهاز أندرويد
flutter test         # اختبارات الوحدة
```

اختبارات e2e تتطلب تهيئة أدوات محلية خاصة (غير مضمّنة في المستودع عمدًا).

## 5) ملاحظات تقنية

- **Windows/Gradle:** ذاكرة Kotlin التزايدية تتعرض لقفل ملفات (تدخل مضاد الفيروسات) ويفشل daemon الاتصال — العلاج في `android/gradle.properties`: `kotlin.incremental=false` و`kotlin.compiler.execution.strategy=in-process`.
- مهلات إطار e2e وُسّعت (إقلاع المحاكي بطيء في التشغيل البارد): `launchTimeout: 120s` و`actionTimeout: 90s`.

---

## 6) خريطة المراحل

| المرحلة | النطاق | الحالة |
|---|---|---|
| **الأولى (هذه)** | الأساس + الشاشات الأربع + المفضلة الدائمة + مكافآت (Hero/Debounce) + اختبارات وحدة وe2e + توثيق وصور | ✅ |
| الثانية (مقترحة) | تحسينات واجهة وحالات خطأ الشبكة، اختبارات widget، وربما CI بسيط | ⬜ |
