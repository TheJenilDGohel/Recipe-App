# Phase 7: Comprehensive E2E Testing Context

## Objective
Verify the entire app functionality on the OnePlus physical device (ID: `192.168.0.102:40601`) using OpenMob. This phase ensures that all previous features (Search, Persistence, Contextual Discovery, Polish, UI Refinement) work together seamlessly in a real-world environment.

## Device Information
- **Device ID:** `192.168.0.102:40601`
- **Model:** OnePlus
- **Connection:** Wireless Debugging

## Application Information
- **Package Name:** `com.ivtex.recipeapp.recipe_app`
- **Main Screens:** Discover (Home), Search, Recipe Detail, Favorites.

## Decisions
- **D-07-01:** Use `192.168.0.102:40601` as the primary testing device.
- **D-07-02:** Verify search using the keyword "Chicken" as it's a common ingredient with expected results.
- **D-07-03:** Use element indices for interaction where possible to ensure reliability across screen sizes.

## Constraints
- Device must be connected and authorized.
- App must be installed on the device (automated in the plan).

## User setup
- Ensure OpenMob Hub is running.
- Ensure the OnePlus device is connected via WiFi (adb connect 192.168.0.102:40601).
