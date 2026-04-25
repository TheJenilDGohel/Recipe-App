---
status: draft
phase: 02
name: Core Discovery & Search
---

# UI Spec: Phase 02 - Core Discovery & Search

## Overview
This phase focuses on the recipe discovery and search experience. The goal is to provide a fast, responsive interface that allows users to find recipes from TheMealDB API with high perceived performance using skeleton loaders and debounced search.

## Spacing Scale (8-point)
| Token | Value | Use Case |
|-------|-------|----------|
| `space-1` | 4px | Fine adjustments, tight clusters |
| `space-2` | 8px | Component internal padding, small gaps |
| `space-4` | 16px | Standard page margins, list item spacing |
| `space-6` | 24px | Section headers, card internal padding |
| `space-8` | 32px | Large sections, top-level groupings |
| `space-12` | 48px | Hero element margins |
| `space-16` | 64px | Maximum vertical padding |

## Typography
| Category | Size | Weight | Line Height | Usage |
|----------|------|--------|-------------|-------|
| `display` | 24px | 600 | 1.2 | Main page titles |
| `heading` | 20px | 600 | 1.2 | Card titles, section headers |
| `body` | 16px | 400 | 1.5 | General text, ingredient lists |
| `caption` | 14px | 400 | 1.5 | Categories, meta information |

## Color Contract (60/30/10)
| Layer | Role | HEX | Element Mapping |
|-------|------|-----|-----------------|
| **Dominant (60%)** | Surface | `#FFFFFF` | Backgrounds, Card surfaces |
| **Secondary (30%)** | UI Elements | `#F5F3FF` | Search bar background, empty states background |
| **Accent (10%)** | Action | `#7C3AED` | Primary CTA, Search icon, Active indicators |
| **Semantic** | Error | `#EF4444` | Error messages, destructive actions |

## Component Inventory

### 1. Recipe Search Bar
- **Visuals:** Rounded corners (24px), light grey background, leading search icon.
- **Interaction:** 
  - Updates query on type.
  - **Debounce:** 300ms (Source: CONTEXT.md).
  - Clear button (X) appears when text is entered.

### 2. Recipe Card
- **Visuals:** 
  - Rounded corners: 12px.
  - Elevation: 2 (Subtle shadow).
  - Aspect Ratio: 16:9 for image.
- **Content:** Thumbnail image, Recipe Name (Max 2 lines), Category tag.
- **Interaction:** Hero transition to detail view on tap.

### 3. Recipe Detail View
- **Visuals:** 
  - Large hero image at top.
  - Sticky back button.
- **Sections:**
  - Header: Title, Category, Area (Cuisine).
  - Ingredients: Checkable list style (visual only for now).
  - Instructions: Numbered steps or clear paragraphs.

## Loading & Error States

### Loading State (TECH-02)
- **Pattern:** Shimmer/Skeleton loader.
- **Visual:** Light grey pulse animation (`#E2E8F0` to `#EDF2F7`).
- **Structure:** Matches the layout of `RecipeCard` (for list) and `RecipeDetailView` (for details).

### Empty State
- **Copy:** "No recipes found. Try searching for something else like 'Chicken' or 'Pasta'."
- **Visual:** Simple centered illustration or icon.

### Error State (TECH-04)
- **Interaction:** Snackbar notification.
- **Copy:** "Failed to load recipes. Please check your connection."
- **Action:** "Retry" button that re-triggers the provider.

## Copywriting Contract

| Key | Value |
|-----|-------|
| Primary CTA | "Discover Recipes" |
| Search Placeholder | "Search for recipes..." |
| No Results Title | "Nothing found" |
| Error Message | "Something went wrong. Please try again." |
| Retry Button | "RETRY" |

## Registry
- **System:** Flutter Material 3
- **Third-party:** 
  - `shimmer` package for loading states.
  - `cached_network_image` for remote images.
  - `cupertino_icons` for platform-specific feel where needed.
