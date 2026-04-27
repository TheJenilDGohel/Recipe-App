<p align="center">
  <img src="assets/images/app_logo.png" width="160" height="160" alt="App Logo">
</p>

# 🍳 Context-Aware Recipe Discovery
## Flutter Recruitment Assignment - ICSPL

[![CI/CD Pipeline](https://github.com/TheJenilDGohel/Recipe-App/actions/workflows/main.yml/badge.svg)](https://github.com/TheJenilDGohel/Recipe-App/actions)
[![Release](https://img.shields.io/github/v/release/TheJenilDGohel/Recipe-App?include_prereleases)](https://github.com/TheJenilDGohel/Recipe-App/releases)

A production-grade Flutter application that provides an intelligent, offline-capable recipe discovery experience. It leverages real-time context (Location & Time) to suggest the perfect meal.

---

## 🏗️ Architectural Choices

The application is built using **Feature-Driven Clean Architecture**, emphasizing modularity, testability, and a superior user experience.

### 1. Layered Separation (Clean Architecture)
- **Data Layer**: Implements the **Repository Pattern** to abstract data sources (TheMealDB API and Drift SQLite).
- **Domain Layer**: Houses core business logic, entities, and repository interfaces, remaining independent of external frameworks.
- **Presentation Layer**: Built with highly responsive Flutter widgets and managed by **Riverpod (2.x)**.

### 2. State Management & Logic
- **Riverpod**: Used for its compile-time safety and robust handling of asynchronous data states (`AsyncValue`).
- **Persistence (Drift/SQLite)**: Provides a type-safe, reactive database for 100% offline access to favorites and cached searches.
- **Settings (Shared Preferences)**: Persists user preferences and interaction flags (e.g., permission prompt history) for a consistent UX across sessions.

### 3. Performance & Stability
- **120Hz Support**: Integrated `flutter_displaymode` to unlock the highest available refresh rates on Android, ensuring buttery-smooth scrolling.
- **Isolate-Safe Mapping**: All data mapping is architected for stability, preventing common "unsendable object" crashes during background processing.
- **Perceived Performance**: Extensive use of **Shimmer/Skeleton** loaders and **Hero animations** to eliminate perceived wait times.

---

## 🎨 Branding & Visual Identity

### The "Context Cloche"
A custom-designed minimalist brand identity:
- **The Cloche**: High-quality culinary content.
- **Map Marker Pin**: Location-aware discovery.
- **Clock Hand**: Time-based meal suggestions.

### Premium Design System
- **Theme**: Deep Navy (`#2D3142`) and Vibrant Purple (`#7C3AED`) accent.
- **UX Ethics**: Implements an **Informative Permission Flow**. The app explains *why* it needs access (e.g., "Discover local cuisines") before triggering system prompts, building user trust.

---

## 🚀 CI/CD Pipeline & Trigger Instructions

Automated via **GitHub Actions** (`.github/workflows/main.yml`).

### Triggers
- **Verification**: Every PR or Push to `master` triggers linting and unit tests.
- **Release**: Every Push to `master` builds a production APK and uploads it to GitHub Releases.
- **Manual**: Supports `workflow_dispatch` for on-demand evaluator runs.

### How to Manually Trigger
1. Go to the **"Actions"** tab in GitHub.
2. Select **"CI/CD Pipeline"**.
3. Click **"Run workflow"** on the `master` branch.

### 📦 Download Artifact (Release APK)
Find the latest build in the **[Releases](../../releases)** section.

---

## 🛠️ Tech Stack & Setup

### Requirements
- **Framework**: Flutter 3.x (Stable)
- **Engine**: Impeller (Vulkan) enabled for Android stability.

### Setup
```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
dart run flutter_launcher_icons
dart run flutter_native_splash:create
flutter run
```

---

## ✨ Functional Compliance Checklist

- [x] **Smart Discovery**: Time-based (Breakfast/Lunch/Dinner) + Location-aware (Local Area).
- [x] **Search**: Debounced search with fallback to local favorites on network failure.
- [x] **Offline-First**: SQL persistence, image caching, and graceful state resilience.
- [x] **Engagement**: Local scheduled notifications for meal reminders.
- [x] **Stability**: 120Hz scrolling, overflow-safe Error views, and robust permission handling.
