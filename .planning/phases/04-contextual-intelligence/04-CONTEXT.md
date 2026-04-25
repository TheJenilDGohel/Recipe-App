# Phase 04: Contextual Intelligence - Context

**Gathered:** 2026-04-25
**Status:** Ready for planning

<domain>
## Phase Boundary

Automate discovery by tailoring content to the user's time and location.
</domain>

<decisions>
## Implementation Decisions

### Location Strategy
- Permission timing? On first Home screen load — highly contextual
- Fallback if denied? Default to 'Global' popular recipes — seamless fallback

### Time-Based Strategy
- Definition of "Meal times"? Fixed slots (e.g. 6-10am Breakfast)
- Content variation within time? Shuffle every hour

### UI Integration
- Where do suggestions appear? Top horizontal carousel on Home

### Claude's Discretion
All other details are at Claude's discretion.
</decisions>

<code_context>
## Existing Code Insights

### Reusable Assets
- `RecipeCard` widget.
- `HomeScreen` structure.

### Established Patterns
- Riverpod for states (e.g., location state provider).

### Integration Points
- Add `geolocator` and `geocoding` packages.
- Update `HomeScreen` to fetch context-based queries.
</code_context>

<specifics>
## Specific Ideas
None.
</specifics>

<deferred>
## Deferred Ideas
None.
</deferred>