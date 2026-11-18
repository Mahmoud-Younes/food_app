# Exam-allowed packages and clean-architecture layout

This project is a graded Flutter practical assessment that explicitly allows only: `dio` (or `http`), `flutter_bloc` (or `provider`), `cached_network_image`, `shared_preferences` (or `hive`), and `url_launcher`. We adopt a clean-architecture folder layout (`core/` with di/networking/routing/theming/widgets, and `features/<feature>/` split into `data`/`logic`/`ui`) **without** heavier third-party tooling: no `get_it` (manual singletons in `core/di/service_locator.dart` instead), no `retrofit` (plain `ApiService` methods), no `freezed`/`json_serializable` (hand-written `fromJson` with null safety — the rubric grades this directly, 25 marks), and no `flutter_screenutil`.

## Considered Options

- Heavy tooling stack (`get_it`, `retrofit`, `freezed`): rejected — packages fall outside the exam's allowed list, and generated `fromJson` would not demonstrate the hand-written models the rubric requires.

## Consequences

- Dependency injection is plain top-level finals; swapping to `get_it` later would only touch `core/di/service_locator.dart`.
- Meal detail visits create a fresh `MealDetailsCubit` per navigation instead of a shared singleton.
