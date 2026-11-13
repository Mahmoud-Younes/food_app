# Round-3 Closing Round — food_app DEPI Submission

*   **Author:** Mahmoud-Younes
*   **Status:** Executed (2026-11-13) — revised per the 2026-11-10 consolidated review of this document
*   **Date:** 2026-11-08 (revised 2026-11-09, 2026-11-10)

--------------------------------------------------------------------------------

## Overview

The food_app is a Flutter recipe browser built on TheMealDB for the DEPI
(Digital Egypt Pioneers Initiative) practical assessment. Two rounds of work
delivered every required screen, the Spice-Stall visual world (the
souk-palette theme defined in `lib/core/theming/` and GLOSSARY.md), unit and
widget tests, and an e2e run on the current commit (`fcffb0f`: 7 selected
tests passed, 4 skipped, zero failures). What keeps the project from being
submittable is not missing functionality — it is three kinds of residue: one
graded feature that does not work when used (the Hero flight toward the
details screen), documents that contradict the code, and a repository shell
(a default-template README, undecided file composition) that undersells the
work to evaluators.

This design covers the closing round: a two-wave sequence — doc/chores commits
first, then one isolated code fix — publishing the unpushed round-2 work and
this round's changes to the public repo `github.com/Mahmoud-Younes/food_app`
in two pushes. It adds no features. Effort estimate: 2.5–3.5 hours plus a
1-hour emulator contingency.

## The Problem

The exam rubric awards 100 points for implemented functionality (UI 25,
models/API 25, state management 25, architecture 15, local storage 10 — all
already implemented and tested) and 10 bonus points for "Hero animation when
transitioning TO the screen". Today the details route passes only a meal id;
the details screen renders a loading widget on its first frame, so Flutter
finds no destination Hero when it samples the frame and silently skips the
flight. Tapping a meal shows a plain transition — in the direction the rubric
names. The reverse direction does animate, which makes the missing one
conspicuous to anyone checking the bonus.

Separately, the repo a DEPI evaluator opens is not the repo that was built:

*   `README.md` is still the default Flutter template ("A new Flutter project")
    — the first document any reviewer reads says nothing.
*   `PRODUCT.md` claims an Onboarding screen that does not exist and cites a
    `DESIGN.md` that does not exist; `CLAUDE.md` calls the app "food ordering"
    (it is a recipe browser). False claims in a graded repo cost more
    credibility than the inflated features are worth.
*   `.impeccable/` — agent-tooling state files from the impeccable tool — are
    tracked and, since they are already on origin/main, will keep accumulating
    publicly with every future push unless untracked now.
*   `cupertino_icons` is an unused dependency outside the exam's stated
    allow-list — a rule AGENTS.md itself records.

The proposed solution: fix the Hero flight with a frame-1 destination Hero,
correct every claim in tracked documents, replace the README with a verified
English walk-through using the existing Spice-Stall screenshots, tidy the
tracked file composition, and push in two waves so the risky code change never
blocks the safe documentation improvements.

## Goals

*   **G1 — Working bonus animation**: tapping a meal card on Home visibly flies
    the meal image into the details screen header, in the push direction, in
    both light and dark themes (the flight engages from Home; Search and
    Favorites render the same header without a flight — see "The fix", step 2).
*   **G2 — True documents**: every tracked document states only claims true of
    the code at push time (`PRODUCT.md`, `CLAUDE.md`, the new root `README.md`,
    and this design document — its factual fixes land before the wave-1 push).
*   **G3 — Presentable public repo**: an English README that maps the four
    screens to the rubric, shows the architecture in summary, explains how to
    run the app, and embeds `docs/second_round/` screenshots with links that
    render on GitHub (case-exact paths).
*   **G4 — Intentional composition**: the pushed tree contains only intended
    public content — `.impeccable/` untracked going forward, `AGENTS.md`
    committed, no e2e-related file ever pushed, `docs/screenshots/` untouched
    per author decision, and round-3 working artifacts (reports, drafts, the
    exam brief (the root `food_app.md`)) kept private behind pattern-based
    ignores.
*   **G5 — Discipline intact**: small, isolated commits with the repo's prefix
    convention (`fix:`/`docs:`/`chore:`), `flutter analyze` green before every
    commit, and the full gate chain (analyze → test → APK build → e2e → manual
    flight check) before the fix wave lands.

## Non-Goals

*   No new features. Round 2 already spent the additions budget (its new
    features: dark mode, large-font support, Hero, debounce); anything new
    happens after submission.
*   No history rewrite or force-push. Files already published on origin/main
    stay reachable in git history.
*   No restructuring of `docs/first_round/README.md` — it remains the round-1
    record (a one-line factual correction is not restructuring).
*   No shimmer package and no loading-system rework; the existing hand-rolled
    pulsing skeleton stays and the README explains it.
*   No edits to the e2e suite (`tests/food_app.e2e.ts`,
    `tests/phase1_capture.e2e.ts`) or `GLOSSARY.md` — the suite and
    `GLOSSARY.md` are verified unaffected by the Hero fix: the e2e suite is
    semantics-driven and never reads route arguments; the payload is still
    fetched by id, with the image URL travelling beside it.
*   No screenshot re-capture; `docs/second_round/` ships as-is.
*   No push of any e2e-related file — `tests/`, `e2e.config.ts`,
    `package.json`, `package-lock.json`, `node_modules/`, `.e2e/` — ever.

## Open Questions

*   None. All brainstorm decisions were resolved on 2026-11-08: README in
    English; `AGENTS.md` committed; `docs/screenshots/` kept; the Hero fix
    confirmed as the round's only code change.

## Critical User Journeys (CUJs)

### CUJ 1: Evaluator reads the repo

*   **Given**: the repo is public on GitHub at the final HEAD.
*   **When**: the evaluator opens the repo root and scrolls the README.
*   **Then**: they see the project's name and purpose, a screenshot
    walk-through (light, dark, large-font) whose images all render, a
    screen-to-rubric map, architecture summary, run instructions, and one
    factual line disclosing AI-assisted development. No broken image links.

### CUJ 2: Evaluator checks the bonus animation

*   **Given**: the app is installed from the published code.
*   **When**: the evaluator taps any meal card on Home.
*   **Then**: the meal image flies from the card into the details screen header
    (push direction), the details screen loads its data underneath, and
    the pop direction still animates. No "multiple heroes" crash, no flash of
    placeholder during the flight.

### CUJ 3: Evaluator audits repo hygiene

*   **Given**: the evaluator inspects `pubspec.yaml` and the tracked file tree
    at HEAD.
*   **Then**: exactly the five allowed dependencies are declared; no
    agent-tooling state files appear at HEAD (`.impeccable/` untracked going
    forward); no e2e tooling file is present; tracked docs contain no claims
    contradicted by the code.

--------------------------------------------------------------------------------

## Technical Plan (Architecture)

### Why the push flight is skipped

```text
MealCard(tap)
  └─ Navigator.pushNamed(details, arguments: meal.id)      meal_card.dart
       └─ settings.arguments as String                     app_router.dart:19
            └─ MealDetailsScreen(mealId: id)
                 └─ MealDetailsCubit.getMealDetails(id)    emits loading BEFORE
                 │                                         its first await
                 └─ FRAME 1 = LoadingWidget                no Hero in the tree
                      → HeroController samples frame 1,
                        finds no destination Hero,
                        silently skips the flight
```

The destination Hero (`meal_details_screen.dart:79`) is only built after the
network fetch succeeds — long after the one frame Flutter uses to collect
destination Heroes for a push. The pop direction works because both routes
already have Heroes mounted by then.

### The fix: frame-1 destination Hero from the route argument

1.  **Composite route argument.** A record typedef in
    `lib/core/routing/routes.dart`:
    `typedef MealDetailsArgs = ({String mealId, String imageUrl});`. Records
    carry structural equality, so the contract test can
    assert the pushed arguments without hand-written `==`. The screen gains a
    required `imageUrl` but still fetches by `mealId` — the data contract is
    unchanged and `GLOSSARY.md` ("always fetched fresh from the API by meal
    ID") stays true.
2.  **One shared header widget owns the destination Hero.** A private widget
    inside `meal_details_screen.dart` extracts the current `SliverAppBar`
    flexibleSpace (the collapsible app-bar background area: `Hero` →
    `CachedNetworkImage` + gradient). Both the loading and success branches
    render this same widget at the same tree position, with the Hero tag built
    from the route argument (`'meal-$mealId'`). Because the image was just
    painted in the Home grid card, `CachedNetworkImage` should resolve it from
    memory cache on frame 1; the 30-second manual flight check confirms no
    placeholder flash. If that check still shows a placeholder flash, the
    named fallback is `precacheImage(NetworkImage(imageUrl), context)` before
    the navigation push. The fix stays Home-only: `meals_grid_view.dart` is the
    only call site given a `heroTag`, because Home, Search, and Favorites all
    live inside one `IndexedStack` route — duplicate tags across tabs would
    throw the "multiple heroes" exception. Search and Favorites render the
    same header without a flight.
3.  **Branch map** (mutually exclusive subtrees, so two Heroes with one tag can
    never coexist in a frame):

    | Cubit state | Header (Hero) | Body |
    |---|---|---|
    | loading / initial | shared header, Hero from route argument (app bar without the favorite action — it needs the fetched meal) | `SliverFillRemaining(child: LoadingWidget())` |
    | success | same shared header, same position (favorite action present) | real content slivers |
    | error | none (no Hero) | `CustomErrorWidget` with Retry |

    A mid-flight error aborts the flight; Flutter handles the unmounted
    destination after the transition completes.
4.  **Lockstep contract change, one commit.** `app_router.dart:19` replaces the
    `as String` cast with record destructuring (a stale cast breaks every
    details navigation); `meal_card.dart` passes the record (it is the sole
    `pushNamed` caller — verified: no deep links, no go_router, no state
    restoration anywhere in `lib/`); `test/widgets_test.dart` asserts record
    equality instead of the old bare id.
5.  **Deterministic emulator-free test.** The harness installs a fast-failing
    `HttpClientAdapter` on the global `Dio` that `service_locator.dart` exposes
    as a public top-level, in `setUp` — the frame-1 fetch then fails
    immediately: no real network, no pending timeout timers, no SharedPreferences
    mocking (favorites load in `main.dart`, which the harness bypasses). The
    host is a `MaterialApp` with `home` set plus
    `onGenerateRoute: AppRouter.onGenerateRoute` — with `home` set, the router
    handles only the pushed `/meal-details` route, so the real cast at
    `app_router.dart:19` is exercised (the existing test's stub never does).
    Tap a card → one `pump()` (never `pumpAndSettle` — the cubit emits loading
    synchronously, so frame 1 is guaranteed to be the loading branch) → find
    the `Hero` **descendant of `MealDetailsScreen`** (scoped finder is
    mandatory: the source card's Hero coexists during the transition) → expect
    tag `'meal-$id'`. A mid-flight overlay assertion was considered and
    declined: it would test Flutter's own Hero machinery rather than the app,
    and its extra timed pumps widen the flake window the failing adapter
    removes.

### Two-wave rollout

```text
WAVE 1 — safe docs/chores                    WAVE 2 — isolated fix
┌─ docs: PRODUCT/CLAUDE corrections          ┌─ fix: Hero push flight
│        (wording only; design record →      │   (routes typedef + router +
│        lib/core/theming/)                  │    meal_card + shared header +
├─ docs: docs/second_round/ screenshots +    │    contract test + new Hero test)
│        new English README (bonus claims    ├─ flutter analyze
│        only the pop-direction flight)      ├─ flutter test
├─ chore: un-track .impeccable/ + gitignore; ├─ flutter build apk --debug ──┐
│        commit AGENTS.md; ignore patterns   ├─ e2e re-run (fresh APK) ◄────┘
│        for round-3 artifacts; drop         ├─ 30 s manual flight check
│        cupertino_icons; bare .e2e/         │   (emulator already up)
│        gitignore line                      └─ git push (wave 2)
├─ README case gate: grep links vs ls
├─ flutter analyze
└─ git push (wave 1)
```

The flaky emulator is the highest-variance step on this host. Wave separation
means an emulator failure can never hold the documentation value hostage:
wave 1 is gated by static analysis only and ships on its own. If wave 2
aborts, the follow-up `docs:` commit (item 17) corrects the record before
anything else ships. Two pushes carry no grading penalty — evaluators grade
final HEAD.

### README composition (summary)

Lead screenshot → what the app is and why it exists → screen-to-rubric map →
architecture summary (`core/` + `features/{data,logic,ui}`, Cubit-only, exactly
the five allowed packages) → bonus callout (500 ms debounce; the Hero flight
claimed in the pop direction — the item-17 follow-up commit extends it to the
push direction on success or corrects it on abort) → run instructions →
screenshots (the `docs/second_round/` set, filenames `01-`–`06-`, `10-`–`12-`,
`20-`, case-exact links) → one factual AI-assistance disclosure line. Source
material is `docs/first_round/README.md` re-verified claim by claim — that
document is the origin of the exact drift this round corrects.

--------------------------------------------------------------------------------

## Alternatives Considered

Entries A–F follow the Pros/Cons/Rejection template; entries G–I are author
decisions recorded below in compressed form, without that template.

### Alternative A: Single push at the end

*   **Pros**: one clean event; the remote never sees an intermediate state.
*   **Cons**: couples the only risky change (navigation code) to the
    highest-variance step (the flaky emulator); an e2e environment failure
    blocks every documentation improvement.
*   **Reason for Rejection**: evaluators grade final HEAD, so the intermediate
    remote state is never graded, and wave separation removes the emulator
    coupling (see the rollout diagram in Technical Plan).

### Alternative B: Run the e2e suite before the fix commit

*   **Pros**: confirms the baseline early; no waiting.
*   **Cons**: the suite is already green on the pre-fix HEAD
    (`.e2e/report.json`), so it proves nothing about post-fix HEAD; worse, the
    suite installs a prebuilt APK, so running it after code changes without
    `flutter build apk --debug` reports green for the wrong reason (stale
    binary).
*   **Reason for Rejection**: the confirmation run is only
    meaningful after the fix commit and an APK rebuild.

### Alternative C: Force-push rewrite to purge `.impeccable/`

*   **Pros**: removes agent-tooling state files from git history entirely.
*   **Cons**: seven `.impeccable/` files are already published on origin/main;
    a rewrite spends the one irreversible move (force-pushing a public repo)
    during the closing round, for marginal benefit and real risk.
*   **Reason for Rejection**: un-track + `.gitignore`
    going forward and accept that published files remain reachable in history;
    an evaluator has to dig deliberately to find them.

### Alternative D: Fix the Hero via fetch-then-navigate

*   **Pros**: guarantees the details screen's first frame has data, so a Hero
    trivially exists on frame 1.
*   **Cons**: delays navigation until the network answers — a blank gap on
    every tap; reintroduces exactly the perceived slowness the current
    loading-first design avoids.
*   **Reason for Rejection**: the composite route argument
    plus frame-1 Hero placeholder renders instantly from the image memory cache
    while the real data fetches underneath.

### Alternative E: Skip the Hero fix; reword docs to claim only the pop-direction flight

*   **Pros**: zero code risk; the submission ships today.
*   **Cons**: the rubric names the transition TO the details screen; a
    claimed-but-broken bonus is what an examiner checks by tapping.
*   **Reason for Rejection**: the fix is ~2 hours with a
    deterministic emulator-free test, and it restores a feature the project
    claims to have.

### Alternative F: Author a new `DESIGN.md` to satisfy PRODUCT.md's reference

*   **Pros**: makes the existing PRODUCT.md citation true; a single design
    record has long-term value.
*   **Cons**: authoring a new design document during a closing round creates
    one more artifact to keep true, under deadline.
*   **Reason for Rejection**: PRODUCT.md is corrected to
    point at `lib/core/theming/` (the real, tested design record) for one
    sentence of effort.

### Alternative G: Add features "if possible" (الاضافة ان امكن)

Rejected (author decision, 2026-11-08): zero new features in a closing round —
every addition carries regression risk against a green e2e suite and the flaky
emulator with zero rubric upside, and round 2 already spent the additions
budget (dark mode, large-font support, Hero, debounce); anything new waits
until after submission.

### Alternative H: Leave `AGENTS.md` floating untracked

Rejected: a floating file keeps `git status` dirty at review time and invites
an accidental `git add`; committed instead, consistent with the already-public
`CLAUDE.md`.

### Alternative I: Remove `docs/screenshots/` from HEAD

Rejected (author decision, 2026-11-08): the 11 round-1 captures there duplicate
files already in `docs/first_round/`, but the directory stays exactly where it
is — nothing references it outside itself.

--------------------------------------------------------------------------------

## Non-Functional Requirements

### Rollout & Rollback

Wave 1 is docs and chores only and reverts with a `git revert` of three
commits if anything is wrong; wave 2 is a single isolated `fix:` commit whose
revert restores the pre-fix navigation contract. There is no force-push path
anywhere in this design; rollback is always a new revert commit, never a
history rewrite.

### Security & Privacy

This round modifies no secrets. The never-pushed set is not just e2e
tooling — it is (a) the e2e tooling with network access (`tests/`,
`e2e.config.ts`, `package.json`, `package-lock.json`, `node_modules/`,
`.e2e/`), (b) credential-bearing agent state (`.zcode/`, `.agents/`,
`.mcp.json`), and (c) the round-3 working artifacts (`/food_app.md` the exam
brief, `/design_draft.md`, `/concepts_brief.md`, `/*_report.md`).
Explicit-path staging is the procedural control; the post-push tree check is
the detective control and must cover the whole set.

### Scalability

Out of scope — a no-new-features round introduces no new load paths.

## Additional Resources

*   `concepts_brief.md` (repo root; private, not committed) — the brainstorm
    output this design finalizes; every decision above traces to it.
*   `docs/first_round/README.md` — source material for the new README (to be
    re-verified, not trusted).
*   `AGENTS.md` — commit discipline, allow-list, emulator recovery order.
*   `.e2e/report.json` — the green e2e record against `fcffb0f` (private file).
*   `docs/designs/` — this document's directory.

## Future Improvements

*   **onSubmitted double-fire** (`lib/features/search/logic/search_cubit.dart`):
    submit bypasses the debounce timer without cancelling it, so
    submit-then-wait fires the same query twice. Known nit, out of scope for a
    closing round.
*   **DESIGN.md**: if the project continues past submission, a real design
    document at the cited path is worth authoring without deadline pressure
    (Alternative F).
*   **Old remote commits**: commits from before the earlier remote-history
    cleanup that preceded round 2 (b32e800-era) remain reachable by SHA on
    GitHub until garbage collection; a full purge requires GitHub Support and
    is not worth pursuing for content with no secrets.

--------------------------------------------------------------------------------

## Detailed Implementation Plan

Work lands in two waves. Every commit: explicit-path staging only,
`flutter analyze` green first, and the repo's message prefixes. No
e2e-related file is ever staged: `tests/`, `e2e.config.ts`, `package.json`,
`package-lock.json`, `node_modules/`, `.e2e/`.

### Target Files to Change

#### Wave 1 — documentation and repo composition (analyze gate only, then push)

1.  `PRODUCT.md` (Modify)

    *   **Type / Scope**: product document, tracked, public.
    *   **Proposed Changes**: (a) delete or rewrite the claim that Splash +
        Onboarding screens are implemented — only Splash exists under
        `lib/features/`; (b) replace both `DESIGN.md` citations with a pointer
        to `lib/core/theming/` (the tested design record: `colors.dart`,
        `category_colors.dart`, typography), so the document cites something
        that exists.

2.  `CLAUDE.md` (Modify)

    *   **Type / Scope**: agent instructions, tracked, public.
    *   **Proposed Changes**: line 3, "A Flutter food ordering application." →
        "A Flutter recipe browser application." (matches GLOSSARY.md; there is
        no ordering anywhere).

3.  `README.md` (Modify — full replacement)

    *   **Type / Scope**: repository front page, tracked, public. In English
        per author decision.
    *   **Proposed Changes**: replace the default Flutter template with: lead
        screenshot (`docs/second_round/02-home.png`) → what the app is (recipe
        browser on TheMealDB, DEPI practical assessment) → screen-to-rubric map
        (Home / Meal Details / Search / Favorites, each with its rubric line
        and one screenshot) → architecture summary (`lib/core/` +
        `lib/features/<f>/{data,logic,ui}`, Cubit-only, exactly the five
        allowed packages: dio, flutter_bloc, shared_preferences,
        cached_network_image, url_launcher) → bonus section (500 ms search
        debounce; Hero flight claimed in the pop direction — the item-17
        follow-up commit extends it to the push direction on success or
        corrects it on abort) → run instructions (`flutter pub get`,
        `flutter run`, APK build command) → screenshots gallery from
        `docs/second_round/` → one factual line: developed with AI coding
        assistance. Every factual sentence is re-verified against the code
        before writing; `docs/first_round/` material is the source but not the
        authority.

4.  `docs/second_round/` (Track — 10 PNGs)

    *   **Type / Scope**: round-2 screenshot evidence, currently untracked on
        disk.
    *   **Proposed Changes**: `git add` each file explicitly:
        `01-launch.png`, `02-home.png`, `03-category-beef.png`,
        `04-meal-details.png`, `05-search-results.png`, `06-search-empty.png`,
        `10-home-dark.png`, `11-details-dark.png`, `12-favorites-dark.png`,
        `20-home-large-font.png`. Without this commit the new README renders
        broken images on GitHub on day one.

5.  `AGENTS.md` (Track — commit the untracked file)

    *   **Type / Scope**: agent guidance, on disk, untracked. Committed per
        author decision, consistent with the already-public `CLAUDE.md`.
    *   **Proposed Changes**: `git add AGENTS.md` as-is. Leaving it floating
        keeps `git status` dirty at review time.

6.  `.gitignore` (Modify)

    *   **Type / Scope**: VCS configuration, tracked, public.
    *   **Proposed Changes**: (a) append `.impeccable/` (so the untracked
        agent-tooling state never returns) and a bare `.e2e/` (current entries
        cover results/, cache/, sessions/, logs/, videos/ and four named files
        — `.e2e/report.json`, `.e2e/ai-trace.json`, `.e2e/junit.xml`,
        `.e2e/summary.md` — not `burst/` with 13 PNGs or `poll/` with 34);
        (b) append pattern-based ignores for the round-3 working artifacts so
        no enumeration goes stale: `/design_draft.md`, `/food_app.md`,
        `/concepts_brief.md`, `/*_report.md` — the review reports, drafts, and
        exam brief (the root `food_app.md`) stay private while the finalized
        design document is committed deliberately (item 9); (c) sync
        `AGENTS.md`'s private-files list with the same patterns in the same
        chore commit.

7.  `.impeccable/` (Modify — un-track, files stay on disk)

    *   **Type / Scope**: agent-tooling state: 13 tracked files —
        `decision-payload.json`, `direction.md`, 2 `questions/*`, 4 `refs/*`,
        5 `surfaces/*`.
    *   **Proposed Changes**: `git rm -r --cached .impeccable/` in the same
        chore commit as item 6, which must land before the wave-1 push — a
        dropped or mis-ordered chore would publish the 6 tooling files that
        are still local-only. Seven of these files are already public on
        origin/main; this stops future accumulation. No history rewrite (see
        Alternative C).

8.  `pubspec.yaml` + `pubspec.lock` (Modify — one commit, together)

    *   **Type / Scope**: dependency manifest and lockfile, tracked, public.
    *   **Proposed Changes**: remove `cupertino_icons` (unused — no
        `CupertinoIcons` import anywhere in `lib/` or `test/`; outside the exam
        allow-list), run `flutter pub get`, commit both files together so the
        lock stays consistent.

9.  `docs/designs/round-3-closing-round.md` (Track — this document)

    *   **Type / Scope**: finalized design document, saved here per the
        finalization decision (2026-11-08).
    *   **Proposed Changes**: committed in the first wave-1 `docs:` commit
        (the PRODUCT/CLAUDE corrections) so the public repo carries its own
        design record. This document is committed publicly as process
        transparency (decided 2026-11-10): the examiner-facing language (the
        bonus-check framing, the rollout economics, the abort playbook, the
        EGM footer) stays, because an auditable design→review→execute trail is
        a credibility asset.

10. Push wave 1

    *   **Action — not a file change**: `git push origin main` after the
        docs/chore commits above and a green `flutter analyze`.

#### Wave 2 — the Hero fix (one `fix:` commit, full gate chain, then push)

11. `lib/core/routing/routes.dart` (Modify — route name constants)

    *   **Proposed Changes**: add `typedef MealDetailsArgs = ({String mealId,
        String imageUrl});` beside the route constants (mechanism: "The fix",
        step 1).

12. `lib/core/routing/app_router.dart` (Modify — `onGenerateRoute`)

    *   **Proposed Changes**: line 19 replaces `settings.arguments as String`
        with a guarded destructure of `MealDetailsArgs`, constructing
        `MealDetailsScreen(mealId: …, imageUrl: …)`; on malformed arguments
        (null or wrong type), duplicate the default branch's return — a Dart
        switch has no fallthrough, and that branch returns
        `_buildRoute(settings: settings, screen: const SplashScreen())`. Must
        land in the same commit as items 11 and 13–15 (mechanism: "The fix",
        step 4).

13. `lib/core/widgets/meal_card.dart` (Modify — the details route's sole
    `pushNamed` caller)

    *   **Proposed Changes**: the navigation call passes
        `(mealId: meal.id, imageUrl: meal.image)` instead of the bare id; the
        existing `heroTag` wiring (line 108) is unchanged; Search and
        Favorites construct `MealCard` without a `heroTag` and stay that way
        (mechanism: "The fix", steps 2 and 4).

14. `lib/features/meal_details/ui/meal_details_screen.dart` (Modify — the
    core of the fix)

    *   **Proposed Changes**: (a) the widget gains a required `imageUrl`
        field; the cubit call stays `getMealDetails(mealId)`; (b) extract the
        flexibleSpace at lines ~79–113 (`Hero` → `CachedNetworkImage` +
        gradient) into one private header widget in this file, parameterized
        by the route-argument URL; (c) the loading/initial branch renders the
        same `CustomScrollView` skeleton — pinned `SliverAppBar`,
        `expandedHeight: 280`, back-button `leading`, `actions: const []`, the
        shared header in flexibleSpace wrapped in the same `FlexibleSpaceBar`
        as the success branch, so the Hero's widget path is identical in both
        branches (element stability depends on it), and a body of
        `SliverFillRemaining(child: LoadingWidget())`; the success branch
        renders the same shared header; (d) the Hero tag is `'meal-$mealId'`
        from the route argument in both branches, replacing
        `'meal-${meal.id}'`; (e) the error branch is unchanged and contains
        no Hero (mechanism and branch map: "The fix", steps 2–3).

15. `test/widgets_test.dart` (Modify — widget tests: navigation + rendering)

    *   **Proposed Changes**: (a) line ~113: the pushed-arguments assertion
        becomes record equality — `pushedArguments` equals
        `(mealId: meal.id, imageUrl: meal.image)`; (b) one deterministic
        emulator-free test (mechanism: "The fix", step 5): `setUp` installs
        the fast-failing adapter — an adapter whose `fetch` throws
        `DioException` immediately, not a 500-response adapter (precedent:
        `_FakeMealAdapter implements HttpClientAdapter`,
        `test/logic_test.dart:25-29`); the test's `MaterialApp` is built
        inline exactly like the existing navigation test at line ~94 (the
        shared `appHost` helper takes no `onGenerateRoute` parameter), seeded
        with `home: Scaffold(body: MealCard(meal: testMeal,
        heroTag: 'meal-52771'))` and
        `onGenerateRoute: AppRouter.onGenerateRoute`; tap the card, exactly
        one `pump()` (never `pumpAndSettle`), then assert a `Hero`
        **descendant of `MealDetailsScreen`** has tag `'meal-52771'` (scoped
        finder; seeded-card precedent: `test/widgets_test.dart:61-68`); after
        the assertion, one flush pump drains dio's fetch kick-off timer (dio's
        `fetch` schedules a zero-duration `Future` timer, `dio_mixin.dart:529`)
        so no pending timer outlives the test.

16. Explicitly unchanged (see Non-Goals; verified during brainstorm)

    *   `GLOSSARY.md` — "always fetched fresh from the API by meal ID" remains
        true under the fix (the image URL travels in the route argument; the
        payload is still fetched by id).
    *   Everything else in the Non-Goals list — the e2e suites, the round-1
        record and screenshots, the search-cubit nit — stays untouched; this
        round has exactly one code change.

17. Follow-up `docs:` commit (fires on both wave-2 outcomes)

    *   **Action — not a file change**: on success, flips this document's
        Status from Proposed to Executed, extends the README bonus line from
        the pop-direction claim to the push-direction flight, and resolves
        the pop-direction-only wording; on abort, instead rewords the README
        bonus line and the `docs/first_round/README.md` Hero line (a one-line
        factual correction, not the forbidden restructuring) and sets this
        document's Status to "Partially executed".

### Verification Plan

*   **Static analysis**: `flutter analyze` — before every commit in both
    waves; currently clean, must stay clean.
*   **Unit + widget tests**: `flutter test` — wave 2 gate; must include the
    updated contract test and the new frame-1 Hero test, both green — the
    harness's fast-failing adapter means no real network and no pending
    timers.
*   **Build gate**: `flutter build apk --debug` — wave 2, after the fix commit
    and before e2e; the e2e suite installs this APK, so without the rebuild it
    validates the stale binary, not the fix.
*   **E2E**: `node node_modules/e2e/dist/cli/bin.js run tests/food_app.e2e.ts`
    on `emulator-5554` — confirmation only (the suite was green on the pre-fix
    HEAD); semantics-driven, cannot see the animation. Emulator recovery order
    per AGENTS.md under a 20-minute timebox; if e2e cannot be brought up
    within it, do not push wave 2 — keep the `fix:` commit local (already
    gated by analyze + test + build) and retry later; `git revert` of the fix
    commit is the fallback if it must be abandoned.
*   **Manual flight check** (about 60 seconds, emulator already up for e2e):
    tap a meal card from Home → the image visibly flies into the details
    header → no placeholder flash, no "multiple heroes" exception → back →
    pop still animates → repeat once in dark mode (`adb shell cmd uimode night
    yes` — the app follows the system theme; reset with `night no` after).
*   **README case gate** (wave 1, before push):
    `grep -oE '\]\((docs/second_round/[^)]+)\)' README.md` diffed against
    `ls docs/second_round` — bash comparison is case-sensitive even on
    Windows; GitHub is case-sensitive, the local filesystem is not. On
    failure, fix the links and `git commit --amend` the README commit.
*   **Post-push checks**: `git ls-tree -r origin/main --name-only
    docs/second_round/` lists exactly 10 PNGs; `git ls-tree -r origin/main
    --name-only .impeccable/` prints nothing; the full `git ls-tree -r
    origin/main --name-only` listing contains none of the complete
    never-pushed set — e2e tooling, credential-bearing agent state, and the
    round-3 working artifacts (see Security & Privacy above); and one image
    link clicked in the README on github.com renders.

--------------------------------------------------------------------------------

*Drafted with EGM (Elephant–Goldfish Model: an AI-assisted brainstorm →
draft → review pipeline); revised per the consolidated reviews (2026-11-09, 2026-11-10).*
