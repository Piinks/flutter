Note: Not every section applies to every design doc. Use the sections that are relevant to the proposal.

# SUMMARY

This proposal introduces a mechanism to track visible children in `ListView` and other sliver-based scroll views. It exposes a `onVisibleChildrenChanged` callback that provides rich metadata (`VisibleChildData`) about currently visible items, including their index, visible extent, and viewport offset.

**Author: Kate Lovett**
**Go Link: flutter.dev/go/list-view-visible-children**
**Created:** 02/2026   /  **Last updated:** 02/2026

# WHAT PROBLEM IS THIS SOLVING?

Developers often need to know exactly which items are currently visible in a scrollable list. Common use cases include:
-   **Analytics**: Tracking which content impressions were actually seen by the user.
-   **Infinite Scrolling**: Triggering data fetches when specific items (e.g., the 5th to last) become visible.
-   **UI Feedback**: Highlighting a "current" item in a navigation rail based on the center-most visible item.
-   **Auto-playing Media**: playing videos only when they are fully visible.

Currently, developers have to resort to complex calculations using `ScrollController`, global keys (which break lazy loading if not careful), or external packages like `visibility_detector`. These solutions are often inefficient or difficult to get right with lazily built slivers.

* Who are the intended users?
    -   Flutter app developers building feed-based applications, media lists, or data-intensive scroll views.
* What is the problem this solution can help the intended users solve?
    -   It provides a native, performant, and accurate way to get visibility updates without manual geometry calculations or abandoning lazy loading.

# BACKGROUND

Flutter's scrolling system uses "slivers" to achieve lazy loading. `RenderSliverMultiBoxAdaptor` is the base class for slivers that have multiple children (like `ListView` and `GridView`). It uses a `SliverChildDelegate` to build children on demand.

Currently, the `SliverChildDelegate` knows *when* it builds a child, but it doesn't inherentily provide a stream of "currently visible" indices to the user after layout is complete. The visibility information is known during the layout phase of the render object but was previously discarded or internal.

# OVERVIEW

We introduce:
1.  `VisibleChildData`: A data class holding visibility metrics (`index`, `visibleExtent`, `totalExtent`, `viewportOffset`).
2.  `onVisibleChildrenChanged`: A callback added to `SliverChildDelegate` (and exposed in `ListView` constructors).
3.  `calculateVisibleRange()`: A method in `RenderSliverMultiBoxAdaptor` that efficiently identifies visible children at the end of layout.

### Non-goals

-   We are not providing a "percentage visible" widget wrapper (like `VisibilityDetector`) that works for arbitrary widgets in the tree. This is specifically for sliver children.
-   We are not changing the layout algorithm itself, only exposing its results.

# USAGE EXAMPLES

### Basic Usage

Logging visible items for analytics:

```dart
ListView.builder(
  itemCount: 100,
  onVisibleChildrenChanged: (visibleChildren) {
    for (final child in visibleChildren) {
      if (child.visibleFraction > 0.5) {
        Analytics.logImpression(child.index);
      }
    }
  },
  itemBuilder: (context, index) => Text('Item $index'),
)
```

### Auto-playing Video

Finding the most visible item to play video:

```dart
ListView.builder(
  onVisibleChildrenChanged: (visibleChildren) {
    // Find the item closest to the center or covering the most screen area
    final centralItem = visibleChildren.reduce((curr, next) {
      return curr.visibleExtent > next.visibleExtent ? curr : next;
    });
    ref.read(videoPlayerProvider).playIndex(centralItem.index);
  },
  itemBuilder: (context, index) => VideoPlayerItem(index),
)
```

# DETAILED DESIGN/DISCUSSION

## `VisibleChildData`

This immutable class holds the data for a single visible child.

```dart
class VisibleChildData {
  final int index;
  final double visibleExtent; // Amount of pixels visible
  final double totalExtent;   // Total size of the child
  final double viewportOffset; // Offset relative to viewport start

  double get visibleFraction => visibleExtent / totalExtent;
}
```

The `viewportOffset` is particularly useful. It is negative if the child starts *before* the viewport (scrolled partially out of view at the top).

## logic in `RenderSliverMultiBoxAdaptor`

The `calculateVisibleRange` method iterates through the *materialized* children (which is a small subset of the total children, typically just those visible + `cacheExtent`).

It checks the intersection of each child's paint bounds with the viewport bounds.
-   `childStart`: Derived from `childScrollOffset(child)`.
-   `viewportStart`: `constraints.scrollOffset`.
-   `viewportEnd`: `constraints.scrollOffset + constraints.remainingPaintExtent`.

This calculation is `O(N)` where `N` is the number of materialized children, making it very fast.

## `SliverChildDelegate` Update

We added `onVisibleChildrenChanged` to the base `SliverChildDelegate` and plumbed it through `didFinishLayout`.

```dart
void didFinishLayout({
  int firstIndex = 0,
  int lastIndex = 0,
  Iterable<VisibleChildData>? visibleChildren
}) {
    onVisibleChildrenChanged?.call(visibleChildren);
}
```

## INTEGRATION WITH EXISTING FEATURES

-   **`ListView` constructors**: `ListView`, `ListView.builder`, `ListView.separated`, and `ListView.custom` now all accept `onVisibleChildrenChanged`.
-   **Slivers**: Since this is implemented in `RenderSliverMultiBoxAdaptor`, it works for `SliverList`, `SliverGrid` (conceptually similar, though grid delegates might need specific handling if they override `didFinishLayout`), and `SliverFixedExtentList`.

# OPEN QUESTIONS

-   **Throttling**: The callback fires every layout (potentially every frame during scrolling). Should we built-in throttle it?
    -   *Decision*: No, we expose the raw stream for maximum flexibility. The user can throttle it if needed. We added a performance warning to the documentation.
-   **KeepAlive**: Does this include kept-alive (off-screen) children?
    -   *Decision*: No, `calculateVisibleRange` strictly filters for children that intersect the viewport.

# TESTING PLAN

New test file `test/widgets/list_view_visible_children_test.dart` covers:
-   **Initial State**: Correct children reported on first frame.
-   **Scrolling**: Offsets and extents update correctly as user scrolls.
-   **Edge Cases**:
    -   Items larger than viewport.
    -   Items partially occluded.
    -   Variable item heights.

Regression testing with `test/widgets/list_view_test.dart` passes.

# DOCUMENTATION PLAN

-   Added detailed DartDoc to `VisibleChildData` explaining coordinate systems.
-   Added performance warning to `onVisibleChildrenChanged`.
-   This design doc serves as the architectural record.

# MIGRATION PLAN

This is a non-breaking additive change. No migration is required for existing users.