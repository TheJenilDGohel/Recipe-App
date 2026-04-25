---
status: draft
phase: 04
name: Contextual Intelligence
---

# UI Spec: Phase 04 - Contextual Intelligence

## Overview
This phase enhances the discovery experience by introducing time-of-day and location-based recipe suggestions. The primary UI addition is a horizontal carousel on the Home screen that proactively suggests relevant meals based on the user's current context.

## Spacing Scale (8-point)
| Token | Value | Use Case |
|-------|-------|----------|
| `space-1` | 4px | Fine adjustments |
| `space-2` | 8px | Section heading to Carousel gap |
| `space-4` | 16px | Page margins, Carousel item padding |
| `space-6` | 24px | Vertical gap between search and carousel |
| `space-8` | 32px | Large section breaks |

## Typography
| Category | Size | Weight | Line Height | Usage |
|----------|------|--------|-------------|-------|
| `display` | 24px | 600 | 1.2 | Page titles |
| `heading` | 20px | 600 | 1.2 | "Good Morning", "Lunch Ideas" headers |
| `body` | 16px | 400 | 1.5 | General text |
| `caption` | 14px | 400 | 1.5 | "Based on your location" labels |
| `tiny` | 12px | 600 | 1.2 | Small tags or metadata |

## Color Contract (60/30/10)
*Consistent with Phase 02/03 for brand integrity.*

| Layer | Role | HEX | Element Mapping |
|-------|------|-----|-----------------|
| **Dominant (60%)** | Surface | `#FFFFFF` | Backgrounds, Card surfaces |
| **Secondary (30%)** | UI Elements | `#F5F3FF` | Card backgrounds, search bar |
| **Accent (10%)** | Action | `#7C3AED` | Primary CTA, **Permission buttons** |
| **Semantic** | Informational| `#3B82F6` | "Location-based" subtle badges |

## Component Inventory

### 1. Contextual Carousel Header
- **Visuals:** 
  - Title: `heading` (20px, 600).
  - Subtitle (Optional): `caption` (14px, 400, Color: Gray).
- **Behavior:** Changes based on time of day (Breakfast, Lunch, Dinner, Snack).

### 2. Mini Recipe Card (for Carousel)
- **Visuals:** 
  - Width: 160px.
  - Height: ~220px (dynamic based on content).
  - Aspect Ratio (Image): 1:1 or 4:3.
  - Corner Radius: 12px.
- **Content:** 
  - Thumbnail (clipped).
  - Recipe Name (Max 2 lines, `caption` size).
  - Cuisine/Area Tag (Optional).
- **Interaction:** Tap to navigate to Recipe Detail.

### 3. Location Permission Banner/Dialog
- **Visuals:** 
  - Appears on first Home screen load.
  - Action button: `#7C3AED` (Accent).
- **Copy:** "Discover local flavors? We use your location to suggest recipes popular in your region."

## Loading & Error States

### Carousel Shimmer
- **Pattern:** Horizontal list of `Mini Recipe Card` skeletons.
- **Visual:** Light grey pulse, consistent with existing shimmers.

### Permission Denied State
- **Behavior:** Hide the "Location-based" subtitle.
- **Fallback:** Carousel shows "Global Popular Recipes" instead of region-specific ones.

## Copywriting Contract

| Key | Value | Context |
|-----|-------|---------|
| Breakfast Header | "Rise & Shine! Breakfast Ideas" | 6:00 AM - 10:00 AM |
| Lunch Header | "Lunchtime Favorites" | 11:00 AM - 2:00 PM |
| Dinner Header | "What's for Dinner Tonight?" | 5:00 PM - 9:00 PM |
| Snack Header | "Feeling Snackish?" | Default / Other times |
| Location Subtitle | "Popular in [Region]" | When location is active |
| Fallback Subtitle | "Trending Globally" | When location is denied |
| Permission CTA | "Discover Regional Recipes" | Permission prompt |

## Registry
- **System:** Flutter Material 3
- **Context:** 
  - `geolocator`: For fetching user coordinates.
  - `geocoding`: For converting coordinates to region/country names.
- **Components:** 
  - Custom `ContextualCarousel` widget.
  - Custom `MiniRecipeCard` widget.
