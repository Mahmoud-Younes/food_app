شامل عملي تقییم • FLUTTER PRACTICAL ASSESSMENT 

# (Food Recipe App) الطعام وصفات تطبیق مشروع 

TheMealDB  تطبیقات برمجة واجھة مع وربطھ Flutter باستخدام متكامل موبایل تطبیق ءبنا 

(API & State Management)  متوسط :المستوى ( بونص 10+)  درجة 100 :الكلیة الدرجة ساعات 3 :المقترحة المدة 

لمتحان **ا** من والھدف المشروع عن نبذة. 1 

،بحریة مأكوالت ،لحوم )المختلفة التصنیفات استعراض للمستخدم یتیح ،العالمیة الطعام وصفات لعرض موبایل تطبیق ءبنا ھو المطلوب المكونات مع كاملة الوصفة تفاصیل وعرض ،لسمب **ا** وجبة أي عن الفوري البحث ،تصنیف كل داخل الوجبات قائمة مشاھدة ،(إلخ ،حلویات .ًمحلیا المفضلة قائمة في الوجبات حفظ إمكانیة إلى باإلضافة ،الفیدیو ورابط التحضیر وخطوات 

(Figma UI Kit) . المجاني فیجما تصمیم رابط 2 

Food Recipe App UI Kit (Community) :لالمتحان المعتمد التصمیم Splash/Onboarding, Home Screen, Search, Recipe Details,) ومنظمة واضحة شاشات على التصمیم یحتوي .( للتحمیل الجاھزة واألیقونات والخطوط األلوان مع Favorites <u>https://www.figma.com/community/file/1089390955726056362</u> :فیجما لملف المباشر الرابط <u>https://www.figma.com/community/search?resource_type=Mixed&sor</u> :فیجما في المباشر للبحث بدیل رابط <u>t_by=relevancy&query=Food+Recipe+App</u> 

(TheMealDB Endpoints)  المجاني API . ـال توثیق 3 

:GET ( طلبات عبر مباشرة وتعمل Token  أو API Key إلى تحتاج ال )بالكامل ومفتوحة مجانیة التالیة الروابط جمیع 

|JSONمالحظات التعامل مع الـ|(Endpoint URL)الرابط المباشر|(Feature)الوظیفة|
|---|---|---|
|categories ترجع مصفوفة باسم<br>تحتوي على اسم التصنیف وصورتھ<br>.ووصفھ|https://www.themealdb.com/api/json/v1/1/<br>categories.php|.جلب التصنیفات1<br>(Categories List)|
|باسمSeafood یتم تغییر كلمة<br>التصنیف المختار.ترجع مصفوفة<br>ID  )**ا**لسم، الصورة، والـmeals<br>.(فقط|https://www.themealdb.com/api/json/v1/1/<br>filter.php?c=Seafood|.وجبات تصنیف معین2<br>(Filter by Category)|
|لجلب كافةidMeal یتم تمریر<br>،التفاصیل، المكونات، خطوات التحضیر<br>.ورابط یوتیوب|https://www.themealdb.com/api/json/v1/1/<br>lookup.php?i=52772|ID .تفاصیل وجبة بالـ3<br>(Meal Details by ID)|
|یتم تمریر النص المكتوب في حقل البحث<br>.إذا لم توجد نتائج ترجع=s? بعد<br>.{meals": null"}|https://www.themealdb.com/api/json/v1/1/<br>search.php?s=Arrabiata|.البحث عن وجبة ب**ا**لسم4<br>(Search Meal by Name)|



(TheMealDB API)  الطعام وصفات تطبیق مشروع — العملي Flutter امتحان 

Page 1 of 3 

(JSON Response Samples) . الراجعة البیانات لھیكل أمثلة 4 

: السیرفر من یرجع الذي الفعلي JSON ـال شكل إلیك ،Flutter  مشروع داخل Models ـال ءإنشا لتسھیل 

{ "categories": [ { "idCategory": "1", "strCategory": "Beef", "strCategoryThumb": "https://www.themealdb.com/images/category/beef.png", "strCategoryDescription": "Beef is the culinary name for meat from cattle..." } ], "meals_details_sample": [ { "idMeal": "52772", "strMeal": "Teriyaki Chicken Casserole", "strCategory": "Chicken", "strArea": "Japanese", "strInstructions": "Preheat oven to 350° F. Spray a 9x13-inch baking pan...", "strMealThumb": "https://www.themealdb.com/images/media/meals/wvpsxx1468256321.jpg", "strYoutube": "https://www.youtube.com/watch?v=4aZr5hZXP_s", "strIngredient1": "soy sauce", "strMeasure1": "3/4 cup" } ] } 

(App Screens & Requirements) . التقنیة والمتطلبات الشاشات 5 

(Home Screen) الرئیسیة الشاشة: األولى الشاشة 

أفقیة قائمة في وعرضھا( 1)  رقم Endpoint  من التصنیفات جلب :(Categories Horizontal List) األفقي التصنیفات شریط 

عند لفتراضي **ا** التصنیف ویكون ،(Selected State) (. مختلف بلون ًحالیا النشط التصنیف تمییز یتم ListView.builder) 

.(Seafood أو Beef ًمثال )تصنیف أول ھو التطبیق فتح 

من شبكة في الوجبات وعرض( 2)  رقم Endpoint  ءاستدعا یتم ،المختار التصنیف على ءًبنا :(Meals GridView) الوجبات شبكة .(. الصورة تحمیل حالة ومعالجة دائریة زوایا مع واسمھا الوجبة صورة یعرض كارت كل GridView.builder) عمودین رسالة وعرض ،البیانات جلب ءأثنا Shimmer  أو CircularProgressIndicator إظھار :والخطأ التحمیل لتح **ا** إدارة .اإلنترنت انقطاع حال في" المحاولة إعادة "زر مع واضحة 

(Meal Details Screen) الوصفة تفاصیل شاشة: الثانیة الشاشة 

ءالستدعا idMeal وتمریر التفاصیل لشاشة لنتقال **ا** یتم ،الرئیسیة الشاشة في وجبة أي على الضغط عند : البیانات وجلب ID ـال تمریر 

.(3)  رقم Endpoint 

.(strCategory) (والتصنیف ، strArea)  المنشأ بلد ،الوجبة اسم تحتھا ،األعلى في الوجبة صورة عرض :المحتوى عرض على strIngredient5 إلى strIngredient1 من )المقادیر مع المكونات عرض :التحضیر وطریقة المكونات قائمة .( ةءللقرا مریح بتنسیق strInstructions) الكاملة التحضیر بخطوات متبوعة ،(األقل 

حزمة باستخدام( strYoutube)  یوتیوب على الوصفة فیدیو لفتح زر إضافة :المفضلة وزر الفیدیو مشاھدة زر . المفضلة من الوجبة إزالة أو لحفظ AppBar ( ـال في Favorite Icon) قلب أیقونة وزر ،url_launcher 

Page 2 of 3 (TheMealDB API)  الطعام وصفات تطبیق مشروع — العملي Flutter امتحان 

(Search Screen) البحث شاشة: الثالثة الشاشة 

.(4)  رقم Endpoint  إلى طلب وإرسال اإلنجلیزیة باللغة الوجبة اسم كتابة للمستخدم یتیح :(Search TextField) البحث حقل 

- تخبر لطیفة واجھة عرض یتم ،meals: null القیمة API  ـال أرجع حال في :(Empty States) الفارغة لتالح **ا** معالجة .(Null check operator used on a null value) خطأ حدوث من ًبدال لبحثھ مطابقة وصفات وجود بعدم المستخدم 

(Favorites Screen) المفضلة شاشة: الرابعة الشاشة 

إمكانیة مع ،(Hive أو Sqflite أو SharedPreferences باستخدام )ًمحلیا بحفظھا المستخدم قام التي الوجبات عرض .فتحھ وإعادة التطبیق إغالق بعد حتى بالبیانات لحتفاظو **ا** المفضلة من الوجبة حذف 

(Grading Rubric) . التقییم ومعاییر المقترحة الحزم 6 provider أو flutter_bloc (Cubit/Bloc) ،بالشبكة لالتصال http أو dio :التالیة األساسیة الحزم باستخدام للطالب سمحُی و ،للصور cached_network_image ،المحلي للتخزین hive أو shared_preferences ،الحالة إلدارة . الروابط لفتح url_launcher 

|الدرجة|التفاصیل المطلوبة|(Criteria)معیار التقییم|
|---|---|---|
|درجة25|محاكاة تصمیم فیجما بدقة، تناسق األلوان والمسافات، استخدام<br> بشكل صحیح، وعدمExpanded أوSingleChildScrollView<br>.Pixel Overflowظھور أخطاء|(UI & Layout) .جودة الواجھات1|
|درجة25|، التعاملfromJson مع دوالModelsكتابة كود الشبكة بشكل سلیم، إنشاء<br>.(، ومعالجة أخطاء **ا**لتصالNull Safety)اآلمن مع القیم الفارغة|ModelsوالـAPI .ربط الـ2|
|درجة25|، والتعامل السلیم مع ح**ا**لتUI (عن الـBusiness Logic)فصل منطق العمل<br>.(وتغییر التصنیف النشط بسالسةLoading, Success, Error)|State) .إدارة الحالة3<br>(Management|
|درجة15|models,views, :ًتقسیم المجلدات بشكل منطقي)مثال<br>Widgets (وتقسیم الشاشة إلىcontrollers/cubits,widgets<br>.صغیرة قابلة إلعادة **ا**لستخدام|Clean) .تنظیم المشروع4<br>(Architecture|
|درجات10|(بكفاءة وبقاء الوجبات المحفوظة بعد إغالقFavorites)عمل شاشة المفضلة<br>.التطبیق وإعادة تشغیلھ|(Local Storage) .التخزین المحلي5|
|درجات10+|على صورةHero Animation)إضافة أنیمیشن بسیط عند **ا**لنتقال للشاشة<br>.في شریط البحث لتقلیل طلبات الشبكةDebounce الوجبة(أو استخدام|(Bonus Points)بونص إضافي|



(TheMealDB API)  الطعام وصفات تطبیق مشروع — العملي Flutter امتحان 

Page 3 of 3 

