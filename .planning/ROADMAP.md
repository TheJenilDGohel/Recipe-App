# Roadmap - Context-Aware Recipe Discovery

## Phases

- [x] **Phase 1: Foundation & DevOps** - Scaffold project with CI/CD and architecture.
- [x] **Phase 2: Core Discovery & Search** - Basic API integration, search, and loading states.
- [x] **Phase 3: Offline Persistence & Resilience** - Favorites, caching, and offline state management.
- [x] **Phase 4: Contextual Intelligence** - Time and location-based discovery logic.
- [x] **Phase 5: Engagement & Polish** - Notifications and micro-interactions.
- [x] **Phase 6: UI Refinement & Reference Alignment** - Overhaul UI to match modern aesthetic reference.
- [x] **Phase 7: Comprehensive E2E Testing** - Automated UI and flow verification using OpenMob (Skipped/Blocked).
- [x] **Phase 8: Edge Cases & Completeness Audit** - Resilient state handling, permission fallbacks, and timezone precision.
- [x] **Phase 9: Stability & Performance Audit** - Main-thread isolation for JSON and large dataset mapping.
- [x] **Phase 10: Architectural Refinement** - Centralize service logic to improve maintainability.

## Phase Details

### Phase 1: Foundation & DevOps
**Goal**: Establish the project structure and delivery pipeline.
**Depends on**: Nothing
**Requirements**: TECH-01, OPS-01, OPS-02
**Success Criteria**:
  1. Project compiles on all platforms.
  2. GitHub Actions builds APK successfully.
  3. Base architecture (Clean Architecture) is set up.
**Plans**: 1 plan
- [x] 01-01-PLAN.md — Foundation Setup.

### Phase 2: Core Discovery & Search
**Goal**: Implement the primary search and list functionality.
**Depends on**: Phase 1
**Requirements**: SMART-01, SMART-04, TECH-02, TECH-04
**Success Criteria**:
  1. User can search for recipes.
  2. Shimmer effects show during loading.
  3. Errors are handled gracefully via Snackbars.
**Plans**: 5 plans
- [x] 02-01-PLAN.md — Feature Scaffolding & Core Setup.
- [x] 02-02-PLAN.md — API Integration (TheMealDB).
- [x] 02-03-PLAN.md — UI Implementation (Search & List).
- [x] 02-04-PLAN.md — Debounced Search & Error UI.
- [x] 02-05-PLAN.md — Detail Screen Implementation.
**UI hint**: yes

### Phase 3: Offline Persistence & Resilience
**Goal**: Enable favorites and caching for offline use.
**Depends on**: Phase 2
**Requirements**: OFF-01, OFF-02, OFF-03
**Success Criteria**:
  1. User can favorite recipes.
  2. Recipes are cached for offline viewing.
  3. App works without internet using cached data.
**Plans**: 3 plans
- [x] 03-01-PLAN.md — Local Database Setup (Drift).
- [x] 03-02-PLAN.md — Favorite Integration.
- [x] 03-03-PLAN.md — Offline Resilience & Sync.
**UI hint**: yes

### Phase 4: Contextual Intelligence
**Goal**: Implement time and location-based discovery.
**Depends on**: Phase 3
**Requirements**: SMART-02, SMART-03, ENG-02
**Success Criteria**:
  1. Home screen shows relevant meals based on time.
  2. Recipe priorities shift based on location.
  3. Permissions are handled gracefully.
**Plans**: 3 plans
- [x] 04-01-PLAN.md — Context Providers (Time & Location).
- [x] 04-02-PLAN.md — Smart Recommendation Engine.
- [x] 04-03-PLAN.md — Contextual UI Integration.
**UI hint**: yes

### Phase 5: Engagement & Polish
**Goal**: Add notifications and micro-interactions.
**Depends on**: Phase 4
**Requirements**: ENG-01, TECH-03
**Success Criteria**:
  1. Scheduled notifications appear at meal times.
  2. Favorite icon has a pop animation.
  3. Smooth transitions between screens.
**Plans**: 3 plans
- [x] 05-01-PLAN.md — Notification System Setup.
- [x] 05-02-PLAN.md — Micro-interactions & Animations.
- [x] 05-03-PLAN.md — Engagement Polish.
**UI hint**: yes

### Phase 6: UI Refinement & Reference Alignment
**Goal**: Match modern aesthetic reference.
**Depends on**: Phase 5
**Requirements**: TECH-02, TECH-03
**Success Criteria**:
  1. UI matches the provided high-fidelity visual reference.
  2. Enhanced typography and spacing system.
  3. Polished card designs and layouts.
**Plans**: 1 plan
- [x] 06-01-PLAN.md — Visual Overhaul.
**UI hint**: yes

### Phase 7: Comprehensive E2E Testing
**Goal**: Verify all user flows automatically.
**Depends on**: Phase 6
**Requirements**: OPS-01
**Success Criteria**:
  1. All critical flows (search, favorite, context) pass in automation.
**Plans**: 1 plan
- [x] 07-01-PLAN.md — OpenMob E2E Suite (Skipped).

### Phase 8: Edge Cases & Completeness Audit
**Goal**: Ensure robust handling of unusual states.
**Depends on**: Phase 6
**Requirements**: OFF-03, ENG-02, TECH-04
**Success Criteria**:
  1. Permission denials don't crash the app.
  2. Empty states are consistently shown.
  3. Network transitions (on/off) are seamless.
**Plans**: 1 plan
- [x] 08-01-PLAN.md — Edge Case Handlers.

### Phase 9: Stability & Performance Audit
**Goal**: Resolve application freezing by moving heavy work off the UI thread.
**Depends on**: Phase 8
**Requirements**: TECH-04
**Success Criteria**:
  1. No UI freezing during large data fetches or caching.
  2. JSON parsing for lists is handled in background isolates.
  3. Database mapping for favorites and search results is isolated.
**Plans**: 1 plan
- [x] 09-01-PLAN.md — Stability & Performance Audit.

### Phase 10: Architectural Refinement
**Goal**: Improve code maintainability and reduce boilerplate by centralizing service logic.
**Depends on**: Phase 9
**Requirements**: TECH-01
**Success Criteria**:
  1. Dedicated RemoteApiService centralizes API configuration and request logic.
  2. Dedicated LocalStorageService (DAO pattern) centralizes database operations.
  3. DataSources are simplified by delegating to specialized services.
**Plans**: 1 plan
- [x] 10-01-PLAN.md — Data Layer Refinement.

## Progress Table

| Phase | Plans Complete | Status | Completed |
|-------|----------------|--------|-----------|
| 1: Foundation & DevOps | 1/1 | Completed | 2026-04-25 |
| 2: Core Discovery & Search | 5/5 | Completed | 2026-04-25 |
| 3: Offline Persistence & Resilience | 3/3 | Completed | 2026-04-25 |
| 4: Contextual Intelligence | 3/3 | Completed | 2026-04-26 |
| 5: Engagement & Polish | 3/3 | Completed | 2026-04-26 |
| 6: UI Refinement | 1/1 | Completed | 2026-04-26 |
| 7: E2E Testing | 1/1 | Completed | 2026-04-27 |
| 8: Edge Cases | 1/1 | Completed | 2026-04-26 |
| 9: Stability | 1/1 | Completed | 2026-04-26 |
| 10: Architectural Refinement | 1/1 | Completed | 2026-04-27 |
