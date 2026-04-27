# Phase 03 — UI Review

**Audited:** 2026-04-25
**Baseline:** UI-SPEC.md
**Screenshots:** Not captured (no dev server)

---

## Pillar Scores

| Pillar | Score | Key Finding |
|--------|-------|-------------|
| 1. Copywriting | 3/4 | Labels match spec, but missing dynamic search placeholder and toggle feedback. |
| 2. Visuals | 3/4 | Good hierarchy, but overlay opacity and card padding deviate from spec. |
| 3. Color | 4/4 | Correct use of accent color and surface mapping. |
| 4. Typography | 3/4 | Banner matches spec; card title uses default instead of spec 20px. |
| 5. Spacing | 3/4 | Mostly 8pt scale, but RecipeCard uses non-standard 12px padding. |
| 6. Experience Design | 3/4 | Global banner is excellent; missing specific offline error state in details. |

**Overall: 19/24**

---

## Top 3 Priority Fixes

1. **Specific Offline Error State** — User sees a generic "Error" when viewing an uncached recipe offline — Implement the `EmptyState` with "You're offline and this recipe isn't saved" in `RecipeDetailScreen`.
2. **Standardize RecipeCard Spacing** — `RecipeCard` uses 12px instead of the specified 16px — Update padding in `RecipeCard` to `EdgeInsets.all(16)`.
3. **Add Toggle Feedback** — Users don't get confirmation when a recipe is saved/removed — Add a `ScaffoldMessenger` snackbar with "Saved for offline" or "Removed from offline" in `FavoriteToggle`.

---

## Detailed Findings

### Pillar 1: Copywriting (3/4)
- **Matches:** "Your Cookbook is Empty", "Save recipes to access them even without internet.", "Explore Recipes", and "You are offline. Showing saved recipes." all match UI-SPEC exactly.
- **Mismatch:** `RecipeSearchBar` uses a static "Search for recipes..." placeholder. UI-SPEC requires "Search saved recipes..." when offline. (`lib/src/features/recipes/presentation/widgets/search_bar.dart:39`)
- **Missing:** UI-SPEC requires "Saved for offline" and "Removed from offline" feedback on toggle. Current implementation only has haptics and animation. (`lib/src/features/recipes/presentation/widgets/favorite_toggle.dart`)

### Pillar 2: Visuals (3/4)
- **Mismatch:** `FavoriteToggle` overlay opacity is `0.7` (`lib/src/features/recipes/presentation/widgets/recipe_card.dart:45`). UI-SPEC specifies `0.3`.
- **Mismatch:** `RecipeCard` internal padding is `12.0` (`lib/src/features/recipes/presentation/widgets/recipe_card.dart:63`). UI-SPEC specifically notes it should be standardized to `16.0`.

### Pillar 3: Color (4/4)
- **Correct:** `OfflineBanner` uses `#7C3AED` as background. (`lib/src/core/widgets/offline_banner.dart:23`)
- **Correct:** `FavoriteToggle` uses `#7C3AED` for the active favorite state. (`lib/src/features/recipes/presentation/widgets/favorite_toggle.dart:64`)

### Pillar 4: Typography (3/4)
- **Correct:** `OfflineBanner` text uses `12px` and `FontWeight.w600`, matching the `tiny` spec. (`lib/src/core/widgets/offline_banner.dart:34`)
- **Observation:** `RecipeCard` title uses `Theme.of(context).textTheme.titleLarge`, which is typically 22px. UI-SPEC asks for `20px`. (`lib/src/features/recipes/presentation/widgets/recipe_card.dart:69`)

### Pillar 5: Spacing (3/4)
- **Deviation:** `RecipeCard` uses `12.0` padding. The project uses an 8pt scale (`space-4` = 16px).
- **Correct:** `FavoritesScreen` uses `EdgeInsets.all(16)` and `bottom: 16` for list items, adhering to the 8pt scale.

### Pillar 6: Experience Design (3/4)
- **Correct:** Global `OfflineBanner` integrated via `MaterialApp.builder` provides a seamless awareness of network status.
- **Missing:** In `RecipeDetailScreen`, when a recipe is not in cache and device is offline, it shows a generic error message from the repository (`error_view.dart`). It should show a specific `EmptyState` with a "Go to Favorites" action as per UI-SPEC. (`lib/src/features/recipes/presentation/screens/recipe_detail_screen.dart:121`)

---

## Files Audited
- `lib/src/core/widgets/offline_banner.dart`
- `lib/src/features/recipes/presentation/widgets/favorite_toggle.dart`
- `lib/src/features/recipes/presentation/screens/favorites_screen.dart`
- `lib/src/features/recipes/presentation/widgets/recipe_card.dart`
- `lib/src/features/recipes/presentation/screens/home_screen.dart`
- `lib/src/features/recipes/presentation/screens/recipe_detail_screen.dart`
- `lib/src/features/recipes/presentation/widgets/search_bar.dart`
- `lib/src/core/widgets/empty_state.dart`
