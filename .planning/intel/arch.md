---
updated_at: "2026-04-27T02:00:00.000Z"
---

## Architecture Overview

Clean Architecture with Feature-First Organization. The project uses Riverpod for state management and Drift for local persistence.

## Key Components

| Component | Path | Responsibility |
|-----------|------|---------------|
| App Entry | `lib/main.dart` | Initializes services and starts the app. |
| Home Screen | `lib/src/features/recipes/presentation/screens/home_screen.dart` | Main discovery UI with search and contextual carousel. |
| Favorites Screen | `lib/src/features/recipes/presentation/screens/favorites_screen.dart` | Displays offline-persisted favorite recipes. |
| Recipe Details | `lib/src/features/recipes/presentation/screens/recipe_detail_screen.dart` | Detailed view of a recipe with ingredients and instructions. |
| API Service | `lib/src/core/network/api_service.dart` | Generic wrapper for HTTP calls with background isolate mapping. |
| Local Storage | `lib/src/core/database/local_storage_service.dart` | Generic wrapper for Drift database operations. |
| Error View | `lib/src/core/widgets/error_view.dart` | Standardized error display widget. |
| Empty State | `lib/src/core/widgets/empty_state.dart` | Standardized empty state display widget. |

## Data Flow

`Presentation (Widget)` -> `Riverpod Provider` -> `Repository` -> `DataSource (Remote/Local)` -> `ApiService/LocalStorageService`

## Conventions

- **Feature-First**: Code is organized by feature (e.g., `features/recipes`).
- **Isolation**: Heavy parsing and database operations are moved to background isolates.
- **Provider-based DI**: Riverpod is used for dependency injection and state management.
- **Code Generation**: uses `build_runner` for Riverpod, Drift, Freezed, and JSON serialization.
