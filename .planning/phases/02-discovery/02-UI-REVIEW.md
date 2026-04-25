# Phase 02 — UI Review

**Audited:** 2026-04-25
**Baseline:** 02-UI-SPEC.md
**Screenshots:** Not captured (no dev server detected)

---

## Pillar Scores

| Pillar | Score | Key Finding |
|--------|-------|-------------|
| 1. Copywriting | 3/4 | Minor deviations from CTA and label contract. |
| 2. Visuals | 3/4 | Search bar radius and card text truncation slightly off spec. |
| 3. Color | 2/4 | Seed color is orange instead of specified violet (#7C3AED). |
| 4. Typography | 3/4 | Using default Material 3 sizes instead of spec's 24/20/16/14 scale. |
| 5. Spacing | 3/4 | Mostly consistent 8pt scale, but used 12px in cards. |
| 6. Experience Design | 3/4 | Great state coverage, but debounce and error UI deviate from spec. |

**Overall: 17/24**

---

## Top 3 Priority Fixes

1. **Brand Color Alignment** — The app currently uses an orange seed color while the UI-SPEC mandates a Violet (#7C3AED) accent. — Update `seedColor` in `lib/main.dart`.
2. **Spacing Standardization** — `RecipeCard` uses `12px` padding which is not on the 8pt scale. — Change to `16px` (`space-4`) for consistency.
3. **Copywriting Sync** — Some buttons and titles don't match the Copywriting Contract (e.g., "RETRY" vs "Retry"). — Update strings in `ErrorView` and `HomeScreen`.

---

## Detailed Findings

### Pillar 1: Copywriting (3/4)
- **Home Title**: `HomeScreen.dart:21` uses "Recipe Discovery", spec says "Discover Recipes".
- **Empty State**: `HomeScreen.dart:37` uses "No recipes found for \"$searchQuery\". Try another search.", spec has a more descriptive prompt including examples ("Chicken" or "Pasta").
- **Retry Button**: `error_view.dart:42` uses "Retry", spec specifies uppercase "RETRY".
- **Search Placeholder**: Matches spec ("Search for recipes...").

### Pillar 2: Visuals (3/4)
- **Search Bar**: `search_bar.dart:44` uses `BorderRadius.circular(30)`, spec says `24px`.
- **Recipe Card**: `recipe_card.dart:58` uses `maxLines: 1`, spec allows `Max 2 lines` for recipe names.
- **Card Elevation**: Matches spec (elevation 2).
- **Aspect Ratio**: Matches spec (16:9).
- **Hero Animation**: Correctly implemented in `RecipeDetailScreen`.

### Pillar 3: Color (2/4)
- **Seed Color**: `main.dart:23` uses `seedColor: Colors.orange`. Spec requires `#7C3AED` as the accent color.
- **Hardcoded Colors**: 
  - `error_view.dart:24` uses `Colors.red`.
  - `recipe_shimmer.dart` uses `Colors.grey[300]` and `Colors.grey[100]`. Matches spec pulse range.
- **Surface Color**: Using standard M3 `surfaceContainerHighest` which is a good proxy for the secondary `#F5F3FF` but lacks the violet tint.

### Pillar 4: Typography (3/4)
- **Hierarchy**: Good use of `headlineSmall` for sections and `titleLarge` for cards, but doesn't strictly map to the specific pixel sizes in UI-SPEC.
- **Body Text**: `RecipeDetailScreen.dart:104` uses `bodyMedium` with `height: 1.5` which matches the line-height requirement but likely defaults to 14px instead of the requested 16px.

### Pillar 5: Spacing (3/4)
- **Grid/List Spacing**: `home_screen.dart` and `RecipeListShimmer` use `16px` (`space-4`). Matches spec.
- **Card Padding**: `recipe_card.dart:47` uses `12.0`. This is not a multiple of the 8pt scale defined in the spec.
- **Detail Spacing**: Uses `16px`, `24px`, and `32px` correctly.

### Pillar 6: Experience Design (3/4)
- **Debounce**: `search_provider.dart:16` uses `500ms`, spec says `300ms`.
- **Loading State**: Excellent shimmer coverage for both list and details.
- **Error State**: Implementation uses an in-place `ErrorView`. Spec requested a "Snackbar notification". While `ErrorView` is often better for initial loads, the spec was specific about the snackbar for error notifications.
- **Interaction**: Clear button in search bar works correctly.

---

## Files Audited
- `lib/main.dart`
- `lib/src/features/recipes/presentation/screens/home_screen.dart`
- `lib/src/features/recipes/presentation/screens/recipe_detail_screen.dart`
- `lib/src/features/recipes/presentation/widgets/recipe_card.dart`
- `lib/src/features/recipes/presentation/widgets/search_bar.dart`
- `lib/src/features/recipes/presentation/widgets/recipe_shimmer.dart`
- `lib/src/core/widgets/error_view.dart`
- `lib/src/core/widgets/empty_state.dart`
- `lib/src/features/recipes/presentation/providers/search_provider.dart`
