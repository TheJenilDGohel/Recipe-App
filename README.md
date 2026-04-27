# Context-Aware Recipe Discovery

A production-grade Flutter application demonstrating proficiency in asynchronous programming, local persistence, location/time-based intelligence, and automated CI/CD pipelines.

## 🚀 Key Features

- **Smart Discovery**: Dynamic homepage suggestions based on the user's local time (Breakfast/Lunch/Dinner) and GPS location (Regional Cuisines).
- **Optimized Search**: Debounced search functionality to minimize API overhead and improve performance.
- **Offline-First Resilience**: 
  - **Local Persistence**: Save "Favorite" recipes using Drift (SQLite).
  - **Caching**: Robust caching for recipe data and images (`cached_network_image`).
  - **State Continuity**: Seamless transition to offline mode with visual feedback and access to cached content.
- **Proactive Engagement**:
  - **Meal Reminders**: Scheduled local notifications triggered at breakfast, lunch, and dinner times.
  - **Permission Resilience**: Graceful handling of location and notification permission requests.
- **Premium UI/UX**:
  - Shimmer/Skeleton loaders for all asynchronous operations.
  - Hero transitions for visual continuity between list and detail views.
  - Implicit animations for micro-interactions (e.g., favorite toggle pop).
  - Global error handling with dedicated views for empty states and network failures.

## 🏗️ Architecture

The project follows a **Feature-Driven Clean Architecture** to ensure scalability and maintainability:

- **Core**: Shared services (Location, Connectivity, Notifications), widgets, and constants.
- **Features**: Isolated vertical slices (e.g., `recipes`) containing:
  - **Data**: Repositories and Data Sources (TheMealDB API, Drift Database).
  - **Domain**: Models and Business Logic.
  - **Presentation**: UI widgets, screens, and Riverpod providers.

### Tech Stack
- **State Management**: [Riverpod](https://riverpod.dev/) (with code generation) for robust, testable state handling.
- **Local Database**: [Drift](https://drift.simonbinder.eu/) (SQLite) for high-performance persistence.
- **Networking**: [Dio](https://pub.dev/packages/dio) for optimized HTTP requests.
- **Models**: [Freezed](https://pub.dev/packages/freezed) for immutable data classes and JSON serialization.

## 🛠️ DevOps & CI/CD

The project includes a fully automated **GitHub Actions** pipeline (`.github/workflows/main.yml`):

### Pipeline Stages
1. **Analyze & Test**: Runs `flutter analyze` and `flutter test` on every push and pull request.
2. **Build Release**: On every push to the `main` branch, the pipeline builds a **Release APK**.
3. **Automated Release**: Automatically uploads the generated APK to **GitHub Releases** with incremented version tags.

### How to trigger the CI/CD
- **Pull Requests**: Simply opening a PR to `main` will trigger the verification (analysis and tests).
- **Deployment**: Any push or merge into the `main` branch will trigger the full build and create a new release with the APK artifact.

## 📦 Getting Started

1. **Clone the repository.**
2. **Install dependencies**: `flutter pub get`
3. **Generate code**: `dart run build_runner build --delete-conflicting-outputs`
4. **Run the app**: `flutter run`
