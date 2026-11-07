# Home — surface brief (بساط التوابل)

Scope: تبويب Home داخل MainScreen (IndexedStack)؛ الشاشة الأولى التي يثبت بها العقد. Mode: Experience بأداء Operate (تصفح شهي + مهمة اختيار تصنيف).

## الهيكل — Material 3 أصلي
Scaffold: ترويسة نصية ('What would you like to cook today?' / 'Fresh recipes from around the world')، ثم CategoriesListView — ListView.separated أفقي من AnimatedContainer مصمت بصورة 44×44 وتحديد بلون القسم، ثم Expanded GridView.builder عمودين من MealCard (Hero 'meal-<id>')، فوق BottomNavigationBar المشترك (nav-home/nav-search/nav-favorites).

## ما يقرضه العالم
- اللون: أرضية `#F3E6D2` بدل الأبيض؛ الكومة المختارة `#B33A25` مصمتة والبقية كتل `#E0A526`/`#8A5A2B` أهدأ — التنظيم من الصبغة قبل الصورة.
- الكثافة: كثافة دافئة بهامش أفقي 20 ثابت وإيقاع عمودي واحد؛ انضباط حديدي يمنع زحام التشبع (خط خطر البطاقة).
- الخط: سيريفي للعنوان، جسم عامل لاسم الوجبة.
- الحركة المميزة: نابض 0.4s بتجاوز الهدف عند تبديل التصنيف — مرة واحدة منسّقة، لا مبعثرة.

## الحالات
- loading: LoadingWidget حتى categoriesStatus=success؛ شبكة هياكل 6 بطاقات أثناء mealsStatus=loading.
- success: ترويسة + شريط الأكوام + شبكة الوجبات.
- error: CustomErrorWidget بـ Retry على المسارين (loadHomeData / selectCategory).
- empty: CustomEmptyStateWidget 'No meals found' عند شبكة فارغة.
