# Search — surface brief (بساط التوابل)

Scope: تبويب Search في MainScreen؛ بحث إنجليزي بالاسم على search.php?s=. Mode: Operate.

## الهيكل — Material 3 أصلي
AppBar 'Search'؛ TextField (Semantics 'search-field'، hint 'Search for a meal (in English)...'، أيقونة بحث وزر مسح) يغذي SearchCubit (onSearchChanged بـ debounce، searchMeals)؛ BlocBuilder على RequestStatus: CustomEmptyStateWidget ('Search for recipes')، LoadingWidget، CustomErrorWidget، CustomEmptyStateWidget ('No meals found')، أو GridView.builder عمودين من MealCard.

## ما يقرضه العالم
- اللون: حقل على كريمي `#F3E6D2` بحد تركيز `#B33A25`؛ النتائج تتدلّى كأكياس بصور كاملة بلا تلوين.
- الكثافة: كثافة دافئة — شبكة 2 أعمدة بنسبة 0.82 بإيقاع بطاقة Home نفسه، لا أبعاد جديدة.
- الخط: سيريفي لعنوان الشاشة وعناوين الحالات، جسم عامل للاستعلام والنتائج.
- الحركة المميزة: نابض 0.4s بتجاوز الهدف عند دخول الشبكة بعد كل بحث — الهدوء أثناء debounce ثم الاندفاع مرة واحدة.

## الحالات
- initial: CustomEmptyStateWidget 'Search for recipes' (دعوة للكتابة).
- loading: LoadingWidget أثناء debounce والطلب.
- success: شبكة النتائج؛ empty: CustomEmptyStateWidget 'No meals found' مع الاستعلام — meals=null مصمَّمة، لا انهيار.
- error: CustomErrorWidget بـ Retry (searchMeals(state.query)).
