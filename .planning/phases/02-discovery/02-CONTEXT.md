# Phase 02: Core Discovery & Search - Context

**Gathered:** 2026-04-25
**Status:** Ready for planning

<domain>
## Phase Boundary

Enable users to discover and search for recipes with high perceived performance.
</domain>

<decisions>
## Implementation Decisions

### Search Behavior
- Debounced on type (300ms) — feels fast but saves API calls
- Show popular/recent categories — encourages discovery

### Loading States
- Pulse animation — feels more active
- Match actual list items — less jarring pop-in

### Error Handling
- Snackbar with retry — unobtrusive but actionable
- Local placeholder image — maintains layout

### Claude's Discretion

</decisions>

<code_context>
## Existing Code Insights

### Reusable Assets
- Foundational architecture, DI, and routing from Phase 1.

### Established Patterns
- Riverpod for state management.
- Freezed for immutable models.
- Dio for API integration.

### Integration Points
- Connects to TheMealDB API via Dio repository.
- Root widget provides Riverpod scope.
</code_context>

<specifics>
## Specific Ideas

No specific requirements — open to standard approaches
</specifics>

<deferred>
## Deferred Ideas

None — discussion stayed within phase scope
</deferred>