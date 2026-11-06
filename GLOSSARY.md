# Food Recipe App

A mobile app for browsing world recipes from TheMealDB, searching meals by name, viewing full recipe details, and keeping a personal list of favorites.

## Language

**Category**:
A group of meals sharing a main kind of food (e.g. Beef, Seafood, Dessert). The app shows one category as active at a time.
_Avoid_: Type, collection, filter

**Meal**:
A single recipe in TheMealDB, identified by its unique ID.

**Meal Summary**:
A meal with only its ID, name, and image — what category listings, search results, and the local favorites list carry.

**Meal Details**:
The full recipe of a meal: origin area, ingredients with measurements, preparation steps, and the YouTube video link. Always fetched fresh from the API by meal ID.

**Ingredient**:
One component of a recipe with its measurement (e.g. "soy sauce — 3/4 cup"). TheMealDB stores up to 20 per meal.

**Favorite**:
A meal the user saved locally. Favorites persist across app restarts and can be removed at any time.
_Avoid_: Liked, bookmark, saved item
