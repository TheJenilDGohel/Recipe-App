# Roadmap - Context-Aware Recipe Discovery

## Phases

- [ ] **Phase 1: Foundation & DevOps** - Scaffold project with CI/CD and architecture.
- [ ] **Phase 2: Core Discovery & Search** - Basic API integration, search, and loading states.
- [ ] **Phase 3: Offline Persistence & Resilience** - Favorites, caching, and offline state management.
- [ ] **Phase 4: Contextual Intelligence** - Time and location-based discovery logic.
- [ ] **Phase 5: Engagement & Polish** - Notifications and micro-interactions.

## Phase Details

### Phase 1: Foundation & DevOps
**Goal**: Establish the production-grade foundation and automated delivery pipeline.
**Depends on**: Nothing
**Requirements**: OPS-01, OPS-02, TECH-01
**Success Criteria**:
  1. GitHub Actions successfully runs analysis and tests on every push.
  2. A Release APK is automatically generated and uploaded to GitHub Releases.
  3. The chosen state management (Bloc/Riverpod/MobX) is configured and providing state to a root-level widget.
**Plans**:
- [x] 01-01-PLAN.md — Initialize project, architecture, and CI/CD pipeline.

### Phase 2: Core Discovery & Search
**Goal**: Enable users to discover and search for recipes with high perceived performance.
**Depends on**: Phase 1
**Requirements**: SMART-01, SMART-04, TECH-02, TECH-04
**Success Criteria**:
  1. User can search for recipes with debounced API calls (optimized overhead).
  2. Shimmer/Skeleton loaders appear during all asynchronous data fetches.
  3. A global error UI (Snackbars or empty states) handles network failures gracefully.
  4. Recipe list and detail views are functional with real data from TheMealDB.
**Plans**:
- [x] 02-01-PLAN.md — API & Data Foundation (Models, Data Sources, Repositories).
- [ ] 02-02-PLAN.md — Search & Home UI (Debounced search providers and list).
- [ ] 02-03-PLAN.md — Detail View & Polish (Recipe details, Shimmers, Global Error UI).
**UI hint**: yes

### Phase 3: Offline Persistence & Resilience
**Goal**: Ensure the app remains functional and useful without an internet connection.
**Depends on**: Phase 2
**Requirements**: OFF-01, OFF-02, OFF-03
**Success Criteria**:
  1. User can "Favorite" recipes, persisting them to local storage.
  2. Previously viewed recipe data and images load instantly from cache when offline.
  3. App transitions to "Offline Mode" UI (cached/favorites) automatically when the network fails.
**Plans**: TBD
**UI hint**: yes

### Phase 4: Contextual Intelligence
**Goal**: Automate discovery by tailoring content to the user's time and location.
**Depends on**: Phase 2
**Requirements**: SMART-02, SMART-03, ENG-02
**Success Criteria**:
  1. Homepage dynamically suggests categories based on local time (Breakfast/Lunch/Dinner).
  2. Cuisines relevant to the user's current GPS location are prioritized in discovery.
  3. Location permission denials are handled gracefully with fallbacks or informative prompts.
**Plans**: TBD
**UI hint**: yes

### Phase 5: Engagement & Polish
**Goal**: Increase user retention through proactive triggers and high-quality interactions.
**Depends on**: Phase 4
**Requirements**: ENG-01, TECH-03
**Success Criteria**:
  1. Scheduled notifications trigger at meal times (e.g., 8:00 AM) with recipe suggestions.
  2. The "Favorite" heart icon has a smooth implicit animation on state change.
  3. Hero transitions provide seamless visual continuity between the list and detail screens.
**Plans**: TBD
**UI hint**: yes

## Progress Table

| Phase | Plans Complete | Status | Completed |
|-------|----------------|--------|-----------|
| 1: Foundation & DevOps | 1/1 | Completed | 2026-04-25 |
| 2: Core Discovery & Search | 0/3 | Planning complete | - |
| 3: Offline Persistence & Resilience | 0/1 | Not started | - |
| 4: Contextual Intelligence | 0/1 | Not started | - |
| 5: Engagement & Polish | 0/1 | Not started | - |
