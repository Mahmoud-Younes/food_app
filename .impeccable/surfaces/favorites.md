# Favorites — surface brief (بساط التوابل)

Scope: تبويب Favorites؛ محفوظات shared_preferences عبر FavoritesCubit تبقى بعد إعادة التشغيل. Mode: Operate/Read.

## الهيكل — Material 3 أصلي
AppBar 'Favorites'؛ BlocBuilder على FavoritesState: SizedBox.shrink عند initial/loading (قراءة محلية صامتة)، CustomErrorWidget، CustomEmptyStateWidget ('No favorites yet')، أو GridView.builder عمودين من MealCard مع onRemove (قلب Semantics 'remove-favorite' فوق الصورة).

## ما يقرضه العالم
- اللون: دفتر الأختام — أرضية `#F3E6D2` وقلوب `#B33A25` كختم حبر على كل كيس محفوظ؛ زر الإزالة يبقى كما هو وظيفياً.
- الكثافة: كثافة دافئة بإيقاع شبكة Home نفسه — سوق واحد لغة واحدة.
- الخط: سيريفي للعنوان، جسم عامل للأسماء ونص الحالة الفارغة.
- الحركة المميزة: نابض 0.4s بتجاوز الهدف للختم عند الإضافة؛ الإزالة بلا حركة احتفالية — فعل نهائي واحد.

## الحالات
- loading/initial: صمت (SizedBox.shrink) — قراءة محلية بلا وميض.
- success: شبكة المحفوظات، الإزالة بلمسة واحدة وتبقى بعد إعادة التشغيل.
- empty: CustomEmptyStateWidget 'No favorites yet' يشرح الختم والدوام.
- error: CustomErrorWidget بـ Retry (loadFavorites).
