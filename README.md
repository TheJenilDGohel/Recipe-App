# 🍳 Context-Aware Recipe Discovery
## Flutter Recruitment Assignment - ICSPL

[![CI/CD Pipeline](https://github.com/TheJenilDGohel/Recipe-App/actions/workflows/main.yml/badge.svg)](https://github.com/TheJenilDGohel/Recipe-App/actions)
[![Release](https://img.shields.io/github/v/release/TheJenilDGohel/Recipe-App?include_prereleases)](https://github.com/TheJenilDGohel/Recipe-App/releases)

A production-grade Flutter application that provides an intelligent, offline-capable recipe discovery experience. It leverages real-time context (Location & Time) to suggest the perfect meal.

---

## 🏗️ Architectural Choices

The application is built using **Feature-Driven Clean Architecture**. This choice ensures the codebase remains modular, testable, and scalable.

### 1. Layered Separation (Clean Architecture)
- **Data Layer**: Handles all external data interactions. We use the **Repository Pattern** to abstract data sources (TheMealDB API and Drift SQLite).
- **Domain Layer**: Contains the core business logic, entities, and repository interfaces. Independent of external libraries or UI.
- **Presentation Layer**: Built with Flutter widgets and managed by **Riverpod**.

### 2. State Management: Riverpod
I chose **Riverpod** over Bloc or MobX for its:
- **Compile-time safety**: Eliminates `ProviderNotFoundException`.
- **Async Handling**: Native support for asynchronous data with `AsyncValue`.
- **Provider Overrides**: Simplifies testing by allowing easy dependency injection.

### 3. Persistence: Drift (SQLite)
For local storage, **Drift** provides:
- **Type-safe queries**: Prevents runtime SQL errors through code generation.
- **Performance**: High-speed batch operations for a smooth offline experience.
- **Reactive updates**: Automatically refreshes UI when data changes.

### 4. Background Isolation
To maintain a consistent 60 FPS, all heavy JSON parsing and database mapping are performed in **background isolates**, preventing UI jank.

---

## 🎨 Branding & Visual Identity

### The "Context Cloche" Logo
The app features a custom-designed minimalist brand identity:
- **The Cloche (Plate Cover)**: Represents the high-quality culinary content.
- **The Location Pin Handle**: Symbolizes location-aware discovery.
- **The Clock Hand**: Highlights time-based contextual logic.

### Premium Design System
- **Primary Theme**: Deep Navy (`#2D3142`) for a sophisticated, professional feel.
- **Accent**: Vibrant Purple (`#7C3AED`) for key actions and branding elements.
- **Visual Polish**: Integrated **Shimmer/Skeleton** loaders, **Hero transitions**, and **Native Splash Screens**.

---

## 🚀 CI/CD Pipeline & Trigger Instructions

The project includes a robust **GitHub Actions** pipeline (`.github/workflows/main.yml`) that automates quality control and distribution.

### Automated Triggers
- **Verification**: Every **Pull Request** or **Push** to `master` triggers linting and unit tests.
- **Release**: Every **Push to the `master` branch** builds a Release APK and uploads it to GitHub Releases.

### How to Manually Trigger
1. Go to the **"Actions"** tab.
2. Select **"CI/CD Pipeline"**.
3. Click **"Run workflow"** and select the `master` branch.

### 📦 Download Artifact (Release APK)
The latest successfully built APK is available in the **[Releases](../../releases)** section.

---

## 🛠️ Tech Stack & Setup

### Core Technologies
- **Framework**: Flutter 3.x
- **State Management**: Riverpod (Generators)
- **Database**: Drift (SQLite)
- **Networking**: Dio
- **Intelligence**: Geolocator, Geocoding, Time-zone logic
- **Engagement**: Flutter Local Notifications

### Setup & Running

1. **Clone the repository.**
2. **Install dependencies**:
   ```bash
   flutter pub get
   ```
3. **Generate required code** (Drift/Riverpod/Freezed):
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```
4. **Generate Assets** (Icons/Splash):
   ```bash
   dart run flutter_launcher_icons
   ```
5. **Run the app**:
   ```bash
   flutter run
   ```

---

## ✨ Implementation Highlights

- **Smart Context**: Homepage dynamically adjusts based on **local time** (Breakfast/Lunch/Dinner) and **GPS location** (Region-specific recipes).
- **Offline Resilience**: Seamless transition to local data when network fails; favorited recipes are always available.
- **Proactive Engagement**: Scheduled meal-time notifications with graceful permission handling.
