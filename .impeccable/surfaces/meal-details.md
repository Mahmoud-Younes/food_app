# Meal Details — surface brief (بساط التوابل)

Scope: مسار MealDetailsScreen بكوبيت جديد لكل زيارة (MealDetailsCubit). Mode: Read/Operate — قراءة وصفة والتصرف عليها.

## الهيكل — Material 3 أصلي
CustomScrollView: SliverAppBar pinned (expandedHeight 280) بـ FlexibleSpaceBar يحمل Hero 'meal-<id>'، زر رجوع دائري، وقلب المفضلة IconButton (Semantics 'favorite-toggle')؛ ثم اسم الوجبة، رقاقتا category/area، IngredientsSection، InstructionsSection، وElevatedButton.icon 'Watch Recipe Video' عبر url_launcher مع SnackBar عند الفشل.

## ما يقرضه العالم
- اللون: الصورة بلا تلوين ككيس معلّق بعرض كامل؛ الرقاقتان حبر `#E0A526`/`#8A5A2B` على كريمي `#F3E6D2`؛ الخلفية تذوب في الصورة ثم تكشف الكريمي.
- الكثافة: كثافة دافئة في المقادير — صفوف مضغوطة بإيقاع واحد، ومسافة أوسع قبل كل قسم منها بعده.
- الخط: سيريفي لاسم الوجبة، جسم عامل مرتفع الارتفاع للمقادير والخطوات الطويلة.
- الحركة المميزة: نابض 0.4s بتجاوز الهدف يختم القلب `#B33A25` ويثبته — يضرب ولا يتلاشى.

## الحالات
- loading/initial: LoadingWidget.
- success: المحتوى كاملاً؛ يخفى زر اليوتيوب إن youtubeUrl فارغ.
- error: AppBar + CustomErrorWidget بـ Retry (getMealDetails).
- empty: لا تنطبق — تفصيلة وجبة واحدة بلا قائمة؛ غياب اليوتيوب هو الحالة الجزئية الوحيدة.
