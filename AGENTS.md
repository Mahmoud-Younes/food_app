# AGENTS.md

Guidance for AI coding agents working in this repository.

## What this is

A Flutter recipe app (`food_app`) built against TheMealDB API — a DEPI (Digital Egypt Pioneers Initiative) practical assessment, not a production product. The visual world is **The Spice Stall** (souk palette, serif display type). Exam constraints shape everything: a short package allow-list, a fixed clean-architecture layout, and e2e tests that pin visible strings.

See also: `PRODUCT.md`, `GLOSSARY.md`, `docs/first_round/README.md` (round-1 record), `CLAUDE.md` (agent skills: issue tracker, triage labels, domain docs).

## Commands

```bash
flutter analyze                # must pass before ANY commit
flutter test                   # unit + widget tests (test/)
flutter build apk --debug      # build gate before e2e
```

Local e2e suite (gitignored tooling; requires a running Android emulator, device `emulator-5554` / AVD `Pixel_7_Pro`):

```bash
node node_modules/e2e/dist/cli/bin.js run tests/food_app.e2e.ts
```

## Architecture

Clean-architecture layout — mirror it exactly for new code:

- `lib/core/` — shared infrastructure: `di/` (service_locator), `networking/` (dio_factory, api_service, api_error_handler, api_constants), `routing/`, `theming/`, `helpers/`, `widgets/` (shared widgets like MealCard).
- `lib/features/<feature>/{data,logic,ui}` — features: `splash`, `home`, `search`, `meal_details`, `favorites`, `main_screen`.
  - `data/` = models + repository, `logic/` = Cubits, `ui/` = screens + widgets.
- State management: **flutter_bloc Cubits only** (no Bloc, no Provider/Riverpod/GetX).
- DI via `lib/core/di/service_locator.dart`.

## Allowed packages (hard exam constraint)

Only: `dio`, `flutter_bloc`, `shared_preferences`, `cached_network_image`, `url_launcher` (+ Flutter SDK). Never add a dependency without the user's explicit approval.

## Hard invariants — never change

- **Visible strings** pinned by e2e: `Beef`, `Dessert`, `Ingredients`, `Preparation Steps`, `Watch Recipe Video`, `No meals found`.
- **Semantics ids** pinned by e2e: `nav-home`, `nav-search`, `nav-favorites`, `search-field`, `favorite-toggle`, `remove-favorite`.
- Data assumptions: first Beef meal is `Algerian Kefta (Meatballs)`; searching `Arrabiata` must surface `Spicy Arrabiata Penne`.
- Theme = Spice Stall: bone `#F3E6D2`, umber `#2A1F18`, paprika `#B33A25` (primary), turmeric `#E0A526`, cumin `#8A5A2B`; dark is warm `#1C1410`; per-category accents via `CategoryColors.colorFor()`; serif display font — all in `lib/core/theming/`.

## Git discipline

- Commits are **local only — never push** without being asked.
- Message prefixes: `features:`, `tests:`, `docs:`, `fix:`, `chore:`, `polish:`.
- `git add` with **explicit paths only** — never `git add -A` / `git add .`. These stay untracked/private (see `.gitignore`): `tests/`, `e2e.config.ts`, `package.json`, `package-lock.json`, `node_modules/`, `.agents/`, `.mcp.json`, `.zcode/`, `.e2e/`, `.impeccable/`, `/design_draft.md`, `/food_app.md`, `/concepts_brief.md`, `/*_report.md`.
- Never commit before `flutter analyze` passes.

## Windows / emulator gotchas

- `android/gradle.properties` pins `kotlin.incremental=false` and `kotlin.compiler.execution.strategy=in-process` — required for Gradle builds on this host; do not remove.
- When e2e fails at install/launch, check in order: free host RAM (needs >1.5 GB of 16 GB — qemu + the emulator starve it), the agent-device daemon (`C:\Users\Younes\.agent-device\daemon.json` — rename to stale if its pid is dead), then cold-boot the emulator (`emulator.exe -avd Pixel_7_Pro -no-snapshot-load`). The e2e timeouts are already generous (launch 120 s, action 90 s, per-test 240 s) — fix recovery, not timeouts.
- `fill()` can fail with "Field focus was refused" → `tap()` the field first.
