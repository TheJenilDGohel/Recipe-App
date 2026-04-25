---
status: draft
phase: 03
name: Offline Persistence & Resilience
---

# UI Spec: Phase 03 - Offline Persistence & Resilience

## Overview
This phase introduces offline capabilities, allowing users to browse their favorite recipes and previously viewed content without an internet connection. The UI must gracefully handle connectivity changes and provide clear feedback when the app is in offline mode.

## Spacing Scale (8-point)
| Token | Value | Use Case |
|-------|-------|----------|
| `space-1` | 4px | Fine adjustments, tight clusters |
| `space-2` | 8px | Component internal padding, small gaps |
| `space-4` | 16px | Standard page margins, list item spacing |
| `space-6` | 24px | Section headers, card internal padding |
| `space-8` | 32px | Large sections, top-level groupings |

*Note: Standardize `RecipeCard` padding to `space-4` (16px) instead of 12px.*

## Typography
| Category | Size | Weight | Line Height | Usage |
|----------|------|--------|-------------|-------|
| `heading` | 20px | 600 | 1.2 | Page titles, section headers, card titles |
| `body` | 16px | 400 | 1.5 | General text, ingredient lists |
| `caption` | 14px | 400 | 1.5 | Categories, meta information |
| `tiny` | 12px | 600 | 1.2 | Offline banner text, small tags |

*Weights: Regular (400), SemiBold (600)*

## Color Contract (60/30/10)
| Layer | Role | HEX | Element Mapping |
|-------|------|-----|-----------------|
| **Dominant (60%)** | Surface | `#FFFFFF` | Backgrounds, Card surfaces |
| **Secondary (30%)** | UI Elements | `#F5F3FF` | Search bar background, secondary buttons |
| **Accent (10%)** | Action | `#7C3AED` | Primary CTA, **Offline Banner**, **Active Favorite Indicator** |
| **Semantic** | Success | `#10B981` | Positive feedback (Saved successfully) |
| **Semantic** | Offline | `#4B5563` | Gray scale for offline placeholders |

## Component Inventory

### 1. Connectivity Banner
- **Visuals:** 
  - Background: `#7C3AED` (Accent).
  - Text Color: `#FFFFFF`.
  - Icon: `wifi_off` (16px).
  - Height: 32px.
- **Behavior:** 
  - Slides down from below the AppBar when connection is lost.
  - Persistent while offline.
  - Slides up and disappears when connection is restored.

### 2. Favorite Toggle Button
- **Visuals:** 
  - Unselected: `Icons.favorite_border` (Outline).
  - Selected: `Icons.favorite` (Filled, Color: `#7C3AED`).
- **Placement:** 
  - **Recipe Card:** Top-right corner, overlaying the image with a subtle circular background (opacity 0.3).
  - **Detail View:** Action button in the AppBar.
- **Interaction:** 
  - Micro-interaction: Scale up to 1.2x and back to 1.0x on toggle.
  - Haptic feedback on tap.

### 3. Favorites Tab/Section
- **Visuals:** 
  - A dedicated view for saved recipes.
  - Uses the same `RecipeCard` layout.
- **Empty State:**
  - Copy: "No favorites yet. Save some recipes to view them offline."
  - Action: "Explore Recipes" button (navigates back to search/discovery).

## Loading & Error States (Offline)

### Cache Only State
- **Scenario:** User views a recipe while online, then goes offline and views it again.
- **Behavior:** Show the cached content. If image is not in cache, show a placeholder icon (`Icons.image_not_supported`).

### No Connection + No Cache
- **Copy:** "You're offline and this recipe isn't saved."
- **Visual:** `EmptyState` component with `cloud_off` icon.
- **Action:** "Go to Favorites" button.

## Copywriting Contract

| Key | Value | Source |
|-----|-------|--------|
| Offline Banner | "You are offline. Showing saved recipes." | CONTEXT.md |
| Favorites Empty Title | "Your Cookbook is Empty" | Claude |
| Favorites Empty Msg | "Save recipes to access them even without internet." | Claude |
| Search Placeholder (Offline) | "Search saved recipes..." | Claude |
| Save Feedback | "Saved for offline" | Claude |
| Remove Feedback | "Removed from offline" | Claude |

## Registry
- **System:** Flutter Material 3
- **Local Persistence:** `drift` (User specified)
- **Connectivity:** `connectivity_plus` package for monitoring network state.
- **Images:** `cached_network_image` (Configured to use cache when offline).
