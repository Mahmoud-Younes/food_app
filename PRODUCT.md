# Product

<!-- impeccable:product-schema 1 -->

## Platform

android

## Users

A mobile user exploring international recipes: browses meal categories (meat, seafood, desserts, …), views meals within a category, opens full recipe details (ingredients, steps, YouTube video), searches meals by English name, and keeps a personal favorites list that persists across app restarts. The examiner grading the DEPI assessment evaluates the same surfaces against a published rubric.

## Product Purpose

A Food Recipe App built with Flutter on the free, open TheMealDB API. It is the DEPI Flutter practical assessment deliverable; success means scoring against the published rubric: UI quality and layout (the rubric's 25-point UI criterion references Figma-kit fidelity; per user decision 2026-11-06 a custom design is acceptable and the kit serves as comparison/derivation material), correct API/model layer with null safety (25), clean state management with loading/success/error handling (25), clean architecture (15), working local storage for favorites (10), plus bonus points (Hero animation and/or search debounce, 10+).

## Positioning

An assessment artifact, not a competitive product: the differentiator is precise fidelity to the approved Figma UI kit plus clean bloc-based architecture. No market claim is made.

## Operating Context

- Assessment brief: `food_app.md` at the repo root (DEPI Flutter practical assessment, TheMealDB API, 3 hours suggested, 100 points).
- Reference design: Figma "Food Recipe App UI Kit (Community)" — https://www.figma.com/community/file/1089390955726056362 (screens: Splash/Onboarding, Home, Search, Recipe Details, Favorites). Per user decision (2026-11-06): following it is **not mandatory** — it is comparison/derivation material; a custom visual design may be created.
- Additional reference kits supplied by the user (2026-11-06), same status — comparison/derivation material, not binding:
  - Meal Planner App UI Kit (Community) — https://www.figma.com/design/n1QFuUgqkfq1fFNzD1NIlj/
  - Food Delivery Application (Community) — https://www.figma.com/design/pVsK3YxZ77rpgzrbUXXlVP/
  - Figma community search: "Food Recipe App" — https://www.figma.com/community/search?query=Food%20Recipe%20App&resource_type=files
- API: TheMealDB free endpoints, no key/token required: `categories.php`, `filter.php?c=<category>`, `lookup.php?i=<idMeal>`, `search.php?s=<name>`. Empty search returns `{"meals": null}` — an expected, designed-for outcome.
- Graded on an Android emulator.

## Capabilities and Constraints

Required screens:

1. **Home** — horizontal categories list (`ListView.builder`) with a selected-state color; default selection is the first category; meals grid (`GridView.builder`, 2 columns) of rounded-corner image cards with meal names; loading state (`CircularProgressIndicator` or Shimmer); error state with a clear message and a Retry button.
2. **Meal Details** — hero image at top; meal name with origin (`strArea`) and category (`strCategory`) below; ingredients list (`strIngredient1..N` with measures) in comfortable reading format; full instructions (`strInstructions`); YouTube button (`url_launcher`); favorite heart icon in the AppBar.
3. **Search** — English-only meal-name text field hitting `search.php?s=`; graceful empty state when `meals` is null (friendly "no matching recipes" message — never a null crash).
4. **Favorites** — meals saved locally (`shared_preferences`), persisting after app close/restart, removable from the list.

Confirmed scope decisions (2026-11-06):

- Splash + Onboarding screens from the Figma kit are implemented before Home (user decision).
- Bonus features in scope: Hero animation on meal images and debounced search (user decision).

Constraints:

- Allowed packages only: `dio` or `http` (dio chosen), `flutter_bloc` or `provider` (flutter_bloc chosen), `cached_network_image`, `hive` or `shared_preferences` (shared_preferences chosen), `url_launcher`. `pubspec.yaml` already pins these.
- UI copy in English (matches the kit; search is English-only per the brief).
- Rubric checks: no Pixel Overflow errors; null-safe `fromJson`; business logic separated from UI; logical folder split (`models`, `views`, `widgets`, `controllers`/`cubits`); small reusable widgets; smooth category-switch state changes.

## Brand Commitments

- Reference design: the Figma "Food Recipe App UI Kit (Community)" (link above) is reference material for comparison and derivation, **not a binding contract** (user decision 2026-11-06). A custom visual world may be created; whichever world is chosen gets recorded in DESIGN.md and applied consistently across every screen.
- App name: food_app (working title from the repo).

## Evidence on Hand

- The assessment brief `food_app.md` (Arabic/English) with all endpoint URLs, JSON response samples, screen requirements, allowed packages, and the full grading rubric.
- `pubspec.yaml` with dependencies chosen and pinned.
- TheMealDB serves real data over the network; no fixtures are needed.
- No custom logo, marketing copy, testimonials, or deployment claims exist; none may be fabricated.

## Product Principles

1. **One visual system** — a single recorded design system (DESIGN.md) governs every screen; the Figma kit is comparison material, not the contract (user decision 2026-11-06).
2. **State discipline** — every async surface has explicit loading, success, and error states driven by Cubit/Bloc; the UI never calls the API directly.
3. **Null safety everywhere** — models parse defensively; `meals: null` is handled as a designed empty state.
4. **Clean separation** — `models` / `views` / `widgets` / `controllers`(cubits) folders; small reusable widgets.
5. **Persistence you can trust** — favorites survive a restart and delete in one tap.

## Accessibility & Inclusion

No product-specific requirement was established beyond standard Flutter/Android defaults and the rubric's layout-quality bar.
