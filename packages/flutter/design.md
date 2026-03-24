# SUMMARY

This proposal introduces a mechanism to track child visibility in sliver-based scroll views via an `onVisibleChildrenChanged` callback. It provides metadata about children intersecting the viewport, including their index, visible extent, total extent, and viewport offset.

**Author: Kate Lovett (Piinks)**
**Go Link: flutter.dev/go/visible-scroll-children**
**Created:** 02/2026   /  **Last updated:** 03/2026

# WHAT PROBLEM IS THIS SOLVING?

Developers often need to identify which items are currently visible in a scrollable list to support features such as:

* **Analytics**: Tracking content impressions accurately.
* **Infinite Scrolling**: Triggering data fetches when specific indices (e.g., the last few items) enter the viewport.
* **UI Synchronization**: Updating peripheral UI components (e.g., navigation rails or scroll indicators) based on the center-most visible item.
* **Media Management**: Automating play/pause logic for video or animated content as it enters or exits the viewport.

Currently, developers must rely on `ScrollController` listener calculations, `GlobalKey` monitoring, or external packages like [`visibility_detector`](https://pub.dev/packages/visibility_detector) (which has not been updated in 3 years). These approaches can be complex to implement correctly for variable-sized items, may impact performance by requiring extra layout passes, or can break lazy loading if not handled carefully.

# BACKGROUND

In Flutter's scrolling system, `RenderSliverMultiBoxAdaptor` manages the lazy loading and layout of multi-child slivers. While the rendering layer determines child visibility during its layout phase, this information is not natively exposed to the widget or delegate layers.

### Audience

This document is intended for Flutter framework contributors and developers interested in the internal layout protocol of sliver-based scroll views.

### Glossary

* **Built Child**: A child that has been built and laid out by the sliver, typically including those visible in the viewport plus a small buffer (the `cacheExtent`).
* **Visible Extent**: The portion of a child's total size (in pixels) that is currently within the viewport bounds.

# OVERVIEW

We introduce:

1. `VisibleChildData`: A data class encapsulating visibility metrics for a single child.
2. `onVisibleChildrenChanged`: A callback added to `SliverChildDelegate` and exposed in common scrollable widgets.
3. `calculateVisibleRange()`: A method in `RenderSliverMultiBoxAdaptor` and other viewports to identify children intersecting the viewport.

### Non-goals

* Providing general-purpose visibility tracking for non-sliver widgets.
* Modifying the core layout or scrolling algorithms of slivers.

# USAGE EXAMPLES

### Analytics Impressions

Logging an impression when an item is more than 50% visible:

| ListView.builder(  itemCount: 100,  onVisibleChildrenChanged: (visibleChildren) {    for (final child in visibleChildren) {      if (child.visibleFraction \> 0.5) {        Analytics.logImpression(child.index);      }    }  },  itemBuilder: (context, index) \=\> ListTile(title: Text('Item $index')),) |
| :---- |

### Auto-playing Video

Identifying the most prominent item in the viewport:

| ListView.builder(  onVisibleChildrenChanged: (visibleChildren) {    if (visibleChildren.isEmpty) return;    final mostVisible \= visibleChildren.reduce((a, b) \=\>       a.visibleExtent \> b.visibleExtent ? a : b);    videoController.play(mostVisible.index);  },  itemBuilder: (context, index) \=\> VideoItem(index),) |
| :---- |

# DETAILED DESIGN/DISCUSSION

## `VisibleChildData`

This class holds the layout state for a visible child:

| class VisibleChildData {  final int index;  final double visibleExtent;  // Pixels visible in the viewport.  final double totalExtent;    // Total size of the child.  final double viewportOffset; // Offset relative to the viewport start.  double get visibleFraction \=\> visibleExtent / totalExtent;} |
| :---- |

A `TwoDimensionalVisibleChildData` equivalent is provided for 2D scroll views.

## Framework Implementation

The tracking is integrated directly into the layout protocol:

1. **`RenderSliverMultiBoxAdaptor.calculateVisibleRange`**: Iterates through the currently built children (O(n) complexity of built children) and intersects their paint bounds with the `SliverConstraints`. Similar logic is implemented for `RenderListWheelViewport` and `RenderTwoDimensionalViewport`.
2. **`SliverChildDelegate.didFinishLayout`**: A new method invoked at the end of the layout phase, receiving the `Iterable<VisibleChildData>`.
3. **`SliverMultiBoxAdaptorElement`**: Acts as the bridge, calling `didFinishLayout` on the delegate when the render object completes its layout.

## ACCESSIBILITY

This proposal does not modify semantic boundaries or accessibility announcements. It is purely a data-reporting mechanism.

## INTERNATIONALIZATION

This proposal is agnostic to locale and text direction, as it operates on raw layout extents.

## INTEGRATION WITH EXISTING FEATURES

This is an additive change. The `onVisibleChildrenChanged` callback has been added to:

* `ListView` and `GridView` (all constructors)
* `AnimatedListView` and `AnimatedList`
* `SliverAnimatedList` and `SliverAnimatedGrid`
* `ListWheelScrollView` and `CupertinoPicker`
* `TwoDimensionalScrollView` (via `TwoDimensionalChildDelegate`)
* `ReorderableListView`
* `CarouselView`

# OPEN QUESTIONS

* **Throttling**: The callback fires every layout pass (potentially every frame during scrolling).
  * *Decision*: We provide the raw stream for maximum flexibility. Users should implement throttling or use `SchedulerBinding.addPostFrameCallback` if triggering heavy side effects.
* **KeepAlive**: Should off-screen items kept alive by `AutomaticKeepAlive` be included?
  * *Decision*: No. `calculateVisibleRange` strictly filters for items with a non-zero intersection with the viewport.

# TESTING PLAN

Comprehensive verification across the framework, including:

* `test/widgets/list_view_visible_children_test.dart`: Core validation for list views.
* `test/widgets/animated_scroll_view_visibility_test.dart`: Validation for animated lists and grids.
* `test/widgets/two_dimensional_viewport_test.dart`: Validation for 2D scrolling.
* `test/widgets/list_wheel_scroll_view_test.dart`: Validation for wheel-based scrolling.
* `test/material/carousel_test.dart`: Validation for the Carousel widget.
* `test/material/reorderable_list_test.dart`: Validation for reorderable lists.
* `test/widgets/slivers_test.dart` and `test/widgets/grid_view_test.dart`: Regression and integration tests.

# DOCUMENTATION PLAN

* Comprehensive DartDocs for `VisibleChildData` and `onVisibleChildrenChanged`.
* Performance guidance in the API documentation regarding high-frequency updates.

# MIGRATION PLAN

This is a non-breaking additive change to the framework's scrolling APIs.

### Compatibility Considerations

The `didFinishLayout` method has been added as a concrete method with a no-op implementation in `SliverChildDelegate`, `ListWheelChildDelegate`, and `TwoDimensionalChildDelegate`. This ensures that existing custom subclasses of these delegates remain compatible without modification.

Developers who have implemented custom delegates and wish to support the new visibility tracking should override `didFinishLayout` to handle the `VisibleChildData` stream.
