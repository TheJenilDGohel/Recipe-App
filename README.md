# Context-Aware Recipe Discovery
## Flutter Recruitment Assignment - ICSPL

This repository contains the implementation of the "Context-Aware Recipe Discovery" application as per the recruitment assignment requirements.

## 🏗️ Architectural Choices

The application is built using **Feature-Driven Clean Architecture**. This choice was made to ensure the code remains modular, testable, and scalable.

### 1. Layered Separation (Clean Architecture)
- **Data Layer**: Handles all external data interactions. We use the **Repository Pattern** to abstract data sources (TheMealDB API and Drift SQLite) from the rest of the app. This allows us to implement offline-first logic seamlessly.
- **Domain Layer**: Contains the core business logic and entities. This layer is independent of any external libraries or UI components, ensuring it's easy to test and maintain.
- **Presentation Layer**: Built with Flutter widgets and managed by **Riverpod**.

### 2. State Management: Riverpod
I chose **Riverpod** over Bloc or MobX for its:
- **Compile-time safety**: No more `ProviderNotFoundException`.
- **Flexibility**: Easier to handle asynchronous data with `AsyncValue`.
- **Testability**: Simple to override providers during testing without boilerplate.

### 3. Persistence: Drift (SQLite)
For local storage, **Drift** was selected because it provides:
- **Type-safe queries**: Generated code ensures we don't have runtime SQL errors.
- **Performance**: High-speed interactions for a smooth offline experience.
- **Reactive updates**: UI updates automatically when data in the database changes.

### 4. Background Isolation
To prevent UI freezing (jank), all heavy JSON parsing and database mapping are performed in **background isolates**. This ensures a consistent 60 FPS even when processing large recipe lists.

---

## 🚀 CI/CD Pipeline & Trigger Instructions

The project includes a fully automated **GitHub Actions** pipeline (`.github/workflows/main.yml`) that handles verification and deployment.

### Automated Triggers
- **Verification**: Every **Pull Request** or **Push** to any branch triggers the `Analyze & Test` job to ensure code quality and stability.
- **Release**: Every **Push to the `master` branch** triggers the full pipeline, which builds a Release APK and uploads it to the GitHub Releases section.

### How to Manually Trigger the Pipeline
For evaluation purposes, the workflow supports manual triggers:
1. Navigate to the **"Actions"** tab in this GitHub repository.
2. Select the **"CI/CD Pipeline"** workflow from the left sidebar.
3. Click the **"Run workflow"** button.
4. Select the branch (usually `master`) and click **"Run workflow"**.

### 📦 Artifact (Release APK)
The latest successfully built APK can always be found in the **[Releases](../../releases)** section of this repository.

---

## ✨ Implementation Highlights

- **Smart Context**: Homepage dynamically suggests meals based on the user's **local time** (Breakfast/Lunch/Dinner) and **GPS location** (Local Cuisines).
- **Offline Resilience**: Full support for favoriting and viewing recipes offline with cached images.
- **Proactive Engagement**: Scheduled notifications for meal reminders with graceful permission handling.
- **Premium UI**: Shimmer loaders, Hero transitions, and implicit animations for a polished feel.

## 🛠️ Setup & Running

1. **Clone the repository.**
2. **Install dependencies**: `flutter pub get`
3. **Generate code**: `dart run build_runner build --delete-conflicting-outputs`
4. **Run the app**: `flutter run`
