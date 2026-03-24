# Implementation Plan: Child Visibility Tracking in Slivers (Prioritized)

This plan outlines the steps to split the large change for child visibility tracking, with priority given to Material and Cupertino libraries due to upcoming code freezes.

## Phase 1: `SliverLayoutDimensions` Refactor
*   **Goal**: Introduce a public `layoutDimensions` getter in `RenderSliverFixedExtentBoxAdaptor` and clean up `RenderTreeSliver`. This is a prerequisite for some of the cleaner implementations in later phases.

## Phase 2: Core Visibility Infrastructure & Base Implementation
*   **Goal**: Define the data structures (`VisibleChildData`) and the base rendering logic (`calculateVisibleRange`) in `widgets` and `rendering`. This is the foundational dependency for all subsequent phases.

## Phase 3: Material & Cupertino Library Support (PRIORITY)
*   **Goal**: Land all changes to the `material` and `cupertino` packages before the 2-week deadline.
*   **Changes**:
    *   **Material**: `CarouselView`, `ReorderableListView`.
    *   **Cupertino**: `CupertinoPicker`.
    *   **Related Tests**: `carousel_test.dart`, `reorderable_list_test.dart`.

## Phase 4: Standard Widget Support
*   **Goal**: Expose the visibility callback in common high-level `widgets` library scrollables.
*   **Changes**:
    *   `ListView`, `GridView`, `SliverList`, `SliverGrid`, `SliverFixedExtentList`, `SliverFill`, etc.
    *   **Related Tests**: `list_view_test.dart`, `grid_view_test.dart`, `slivers_test.dart`.

## Phase 5: Other Specialized Support
*   **Goal**: Finalize implementation for specialized `widgets` components.
*   **Changes**:
    *   **2D Scrolling**: `TwoDimensionalViewport`, `TwoDimensionalChildDelegate`.
    *   **Tree Structures**: `TreeSliver`, `RenderTreeSliver`.
    *   **Animated Lists**: `AnimatedListView`, `SliverAnimatedList`, etc.
