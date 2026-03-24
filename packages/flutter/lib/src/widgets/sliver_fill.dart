// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

/// @docImport 'nested_scroll_view.dart';
/// @docImport 'scroll_physics.dart';
/// @docImport 'scroll_view.dart';
/// @docImport 'sliver_prototype_extent_list.dart';
library;


import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';

import 'framework.dart';
import 'scroll_delegate.dart';
import 'sliver.dart';

/// A sliver whose box children each fill the viewport.
///
/// Each child is sized to be [viewportFraction] times the height of the
/// viewport (or the width, if the orientation is horizontal).
///
/// [SliverFillViewport] places its children in a linear array along the main
/// axis. Each child is forced to have the same size as the viewport in the main
/// axis and the cross axis.
///
/// See also:
///
///  * [SliverFixedExtentList], which has a fixed main axis extent that is not
///    necessarily the same size as the viewport.
///  * [SliverList], which does not require its children to have the same size
///    in the main axis.
///  * [SliverPrototypeExtentList], which is similar to [SliverFixedExtentList]
///    except that it uses a prototype widget instead of a pixel value to define
///    the main axis extent of each child.
class SliverFillViewport extends StatelessWidget {
  /// Creates a sliver whose box children each fill the viewport.
  const SliverFillViewport({
    super.key,
    required this.delegate,
    this.viewportFraction = 1.0,
    this.padEnds = true,
    this.allowImplicitScrolling = true,
    this.onVisibleChildrenChanged,
  }) : assert(viewportFraction > 0.0);

  /// Creates a sliver whose box children each fill the viewport from an
  /// explicit [List] of widgets.
  ///
  /// This constructor is appropriate for slivers with a small number of
  /// children because constructing the [List] requires doing work for every
  /// child that could possibly be displayed in the sliver, instead of just
  /// those children that are actually visible.
  ///
  /// Like other widgets in the framework, this widget expects that
  /// the [children] list will not be mutated after it has been passed in here.
  /// See the documentation at [SliverChildListDelegate.children] for more details.
  SliverFillViewport.list({
    super.key,
    required List<Widget> children,
    this.viewportFraction = 1.0,
    this.padEnds = true,
    bool addAutomaticKeepAlives = true,
    bool addRepaintBoundaries = true,
    bool addSemanticIndexes = true,
    this.allowImplicitScrolling = true,
    this.onVisibleChildrenChanged,
  }) : delegate = SliverChildListDelegate(
         children,
         addAutomaticKeepAlives: addAutomaticKeepAlives,
         addRepaintBoundaries: addRepaintBoundaries,
         addSemanticIndexes: addSemanticIndexes,
         onVisibleChildrenChanged: onVisibleChildrenChanged,
       ),
       assert(viewportFraction > 0.0);

  /// Creates a sliver whose box children each fill the viewport using widgets
  /// that are created on demand.
  ///
  /// This constructor is appropriate for slivers with a large (or infinite)
  /// number of children because the builder is called only for those children
  /// that are actually visible.
  ///
  /// Providing a non-null [itemCount] lets the [SliverFillViewport] compute the
  /// maximum scroll extent.
  ///
  /// [itemBuilder] will be called only with indices greater than or equal to
  /// zero and less than [itemCount].
  ///
  /// {@macro flutter.widgets.ListView.builder.itemBuilder}
  SliverFillViewport.builder({
    super.key,
    required NullableIndexedWidgetBuilder itemBuilder,
    int? itemCount,
    this.viewportFraction = 1.0,
    this.padEnds = true,
    bool addAutomaticKeepAlives = true,
    bool addRepaintBoundaries = true,
    bool addSemanticIndexes = true,
    this.allowImplicitScrolling = true,
    this.onVisibleChildrenChanged,
  }) : delegate = SliverChildBuilderDelegate(
         itemBuilder,
         childCount: itemCount,
         addAutomaticKeepAlives: addAutomaticKeepAlives,
         addRepaintBoundaries: addRepaintBoundaries,
         addSemanticIndexes: addSemanticIndexes,
         onVisibleChildrenChanged: onVisibleChildrenChanged,
       ),
       assert(viewportFraction > 0.0);

  /// The fraction of the viewport that each child should fill in the main axis.
  ///
  /// If this fraction is less than 1.0, more than one child will be visible at
  /// a time. If this fraction is greater than 1.0, each child will be larger
  /// than the viewport in the main axis.
  ///
  /// Defaults to 1.0.
  final double viewportFraction;

  /// Whether to add padding to both ends of the list.
  ///
  /// If this is true, and [viewportFraction] < 1.0, padding will be added
  /// such that the first and last child centered in the viewport.
  ///
  /// Defaults to true.
  final bool padEnds;

  /// The delegate that provides the children for this widget.
  ///
  /// The [SliverFillViewport.list] and [SliverFillViewport.builder]
  /// constructors create a custom [delegate], and properties such as
  /// [SliverChildListDelegate.children] and
  /// [SliverChildBuilderDelegate.itemBuilder] are used to configure it.
  ///
  /// {@macro flutter.widgets.SliverMultiBoxAdaptorWidget.delegate}
  final SliverChildDelegate delegate;

  /// {@macro flutter.widgets.PageView.allowImplicitScrolling}
  final bool allowImplicitScrolling;

  /// {@macro flutter.widgets.SliverChildBuilderDelegate.onVisibleChildrenChanged}
  final VisibleChildrenChangedCallback? onVisibleChildrenChanged;

  @override
  Widget build(BuildContext context) {
    return _SliverFractionalPadding(
      viewportFraction: padEnds ? clampDouble(1 - viewportFraction, 0, 1) / 2 : 0,
      sliver: _SliverFillViewportRenderObjectWidget(
        viewportFraction: viewportFraction,
        allowImplicitScrolling: allowImplicitScrolling,
        delegate: onVisibleChildrenChanged != null ? _DelegateWithCallback(delegate, onVisibleChildrenChanged!) : delegate,
      ),
    );
  }
}

class _DelegateWithCallback extends SliverChildDelegate {
  _DelegateWithCallback(this.delegate, this.onVisibleChildrenChanged);

  final SliverChildDelegate delegate;
  final VisibleChildrenChangedCallback onVisibleChildrenChanged;

  @override
  Widget? build(BuildContext context, int index) => delegate.build(context, index);

  @override
  double? estimateMaxScrollOffset(int firstIndex, int lastIndex, double leadingScrollOffset, double trailingScrollOffset) => delegate.estimateMaxScrollOffset(firstIndex, lastIndex, leadingScrollOffset, trailingScrollOffset);

  @override
  void didFinishLayout({int firstIndex = 0, int lastIndex = 0, Iterable<VisibleChildData>? visibleChildren}) {
    onVisibleChildrenChanged(visibleChildren ?? const <VisibleChildData>[]);
    delegate.didFinishLayout(firstIndex: firstIndex, lastIndex: lastIndex, visibleChildren: visibleChildren);
  }

  @override
  bool shouldRebuild(covariant _DelegateWithCallback oldDelegate) => delegate.shouldRebuild(oldDelegate.delegate) || onVisibleChildrenChanged != oldDelegate.onVisibleChildrenChanged;

  @override
  int? findIndexByKey(Key key) => delegate.findIndexByKey(key);
}

class _SliverFillViewportRenderObjectWidget extends SliverMultiBoxAdaptorWidget {
  const _SliverFillViewportRenderObjectWidget({
    required super.delegate,
    this.viewportFraction = 1.0,
    this.allowImplicitScrolling = true,
  }) : assert(viewportFraction > 0.0);

  final double viewportFraction;
  final bool allowImplicitScrolling;

  @override
  RenderSliverFillViewport createRenderObject(BuildContext context) {
    final element = context as SliverMultiBoxAdaptorElement;
    return RenderSliverFillViewport(
      childManager: element,
      viewportFraction: viewportFraction,
      allowImplicitScrolling: allowImplicitScrolling,
    );
  }

  @override
  void updateRenderObject(BuildContext context, RenderSliverFillViewport renderObject) {
    renderObject
      ..viewportFraction = viewportFraction
      ..allowImplicitScrolling = allowImplicitScrolling;
  }
}

class _SliverFractionalPadding extends SingleChildRenderObjectWidget {
  const _SliverFractionalPadding({this.viewportFraction = 0, Widget? sliver})
    : assert(viewportFraction >= 0),
      assert(viewportFraction <= 0.5),
      super(child: sliver);

  final double viewportFraction;

  @override
  RenderObject createRenderObject(BuildContext context) =>
      _RenderSliverFractionalPadding(viewportFraction: viewportFraction);

  @override
  void updateRenderObject(BuildContext context, _RenderSliverFractionalPadding renderObject) {
    renderObject.viewportFraction = viewportFraction;
  }
}

class _RenderSliverFractionalPadding extends RenderSliverEdgeInsetsPadding {
  _RenderSliverFractionalPadding({double viewportFraction = 0})
    : assert(viewportFraction <= 0.5),
      assert(viewportFraction >= 0),
      _viewportFraction = viewportFraction;

  SliverConstraints? _lastResolvedConstraints;

  double get viewportFraction => _viewportFraction;
  double _viewportFraction;
  set viewportFraction(double newValue) {
    if (_viewportFraction == newValue) {
      return;
    }
    _viewportFraction = newValue;
    _markNeedsResolution();
  }

  @override
  EdgeInsets? get resolvedPadding => _resolvedPadding;
  EdgeInsets? _resolvedPadding;

  void _markNeedsResolution() {
    _resolvedPadding = null;
    markNeedsLayout();
  }

  void _resolve() {
    if (_resolvedPadding != null && _lastResolvedConstraints == constraints) {
      return;
    }

    final double paddingValue = constraints.viewportMainAxisExtent * viewportFraction;
    _lastResolvedConstraints = constraints;
    _resolvedPadding = switch (constraints.axis) {
      Axis.horizontal => EdgeInsets.symmetric(horizontal: paddingValue),
      Axis.vertical => EdgeInsets.symmetric(vertical: paddingValue),
    };

    return;
  }

  @override
  void performLayout() {
    _resolve();
    super.performLayout();
  }
}

/// A sliver that contains a single box child that fills the remaining space in
/// the viewport.
///
/// _To learn more about slivers, see [CustomScrollView.slivers]._
///
/// [SliverFillRemaining] will size its [child] to fill the viewport in the
/// cross axis. The extent of the sliver and its child's size in the main axis
/// is computed conditionally, described in further detail below.
///
/// Typically this will be the last sliver in a viewport, since (by definition)
/// there is never any room for anything beyond this sliver.
///
/// ## Main Axis Extent
///
/// ### When [SliverFillRemaining] has a scrollable child
///
/// The [hasScrollBody] flag indicates whether the sliver's child has a
/// scrollable body. This value is never null, and defaults to true. A common
/// example of this use is a [NestedScrollView]. In this case, the sliver will
/// size its child to fill the maximum available extent. [SliverFillRemaining]
/// will not constrain the scrollable area, as it could potentially have an
/// infinite depth. This is also true for use cases such as a [ScrollView] when
/// [ScrollView.shrinkWrap] is true.
///
/// ### When [SliverFillRemaining] does not have a scrollable child
///
/// When [hasScrollBody] is set to false, the child's size is taken into account
/// when considering the extent to which it should fill the space. The extent to
/// which the preceding slivers have been scrolled is also taken into
/// account in deciding how to layout this sliver.
///
/// [SliverFillRemaining] will size its [child] to fill the viewport in the
/// main axis if that space is larger than the child's extent, and the amount
/// of space that has been scrolled beforehand has not exceeded the main axis
/// extent of the viewport.
///
/// {@tool dartpad}
/// In this sample the [SliverFillRemaining] sizes its [child] to fill the
/// remaining extent of the viewport in both axes. The icon is centered in the
/// sliver, and would be in any computed extent for the sliver.
///
/// ** See code in examples/api/lib/widgets/sliver_fill/sliver_fill_remaining.0.dart **
/// {@end-tool}
///
/// [SliverFillRemaining] will defer to the size of its [child] if the
/// child's size exceeds the remaining space in the viewport.
///
/// {@tool dartpad}
/// In this sample the [SliverFillRemaining] defers to the size of its [child]
/// because the child's extent exceeds that of the remaining extent of the
/// viewport's main axis.
///
/// ** See code in examples/api/lib/widgets/sliver_fill/sliver_fill_remaining.1.dart **
/// {@end-tool}
///
/// [SliverFillRemaining] will defer to the size of its [child] if the
/// [SliverConstraints.precedingScrollExtent] exceeded the length of the viewport's main axis.
///
/// {@tool dartpad}
/// In this sample the [SliverFillRemaining] defers to the size of its [child]
/// because the [SliverConstraints.precedingScrollExtent] has gone
/// beyond that of the viewport's main axis.
///
/// ** See code in examples/api/lib/widgets/sliver_fill/sliver_fill_remaining.2.dart **
/// {@end-tool}
///
/// For [ScrollPhysics] that allow overscroll, such as
/// [BouncingScrollPhysics], setting the [fillOverscroll] flag to true allows
/// the size of the [child] to _stretch_, filling the overscroll area. It does
/// this regardless of the path chosen to provide the child's size.
///
/// {@animation 250 500 https://flutter.github.io/assets-for-api-docs/assets/widgets/sliver_fill_remaining_fill_overscroll.mp4}
///
/// {@tool dartpad}
/// In this sample the [SliverFillRemaining]'s child stretches to fill the
/// overscroll area when [fillOverscroll] is true. This sample also features a
/// button that is pinned to the bottom of the sliver, regardless of size or
/// overscroll behavior. Try switching [fillOverscroll] to see the difference.
///
/// This sample only shows the overscroll behavior on devices that support
/// overscroll.
///
/// ** See code in examples/api/lib/widgets/sliver_fill/sliver_fill_remaining.3.dart **
/// {@end-tool}
///
///
/// See also:
///
///  * [SliverFillViewport], which sizes its children based on the
///    size of the viewport, regardless of what else is in the scroll view.
///  * [SliverList], which shows a list of variable-sized children in a
///    viewport.
class SliverFillRemaining extends StatelessWidget {
  /// Creates a sliver that fills the remaining space in the viewport.
  const SliverFillRemaining({
    super.key,
    this.child,
    this.hasScrollBody = true,
    this.fillOverscroll = false,
  });

  /// Box child widget that fills the remaining space in the viewport.
  ///
  /// The main [SliverFillRemaining] documentation contains more details.
  final Widget? child;

  /// Indicates whether the child has a scrollable body, this value cannot be
  /// null.
  ///
  /// Defaults to true such that the child will extend beyond the viewport and
  /// scroll, as seen in [NestedScrollView].
  ///
  /// Setting this value to false will allow the child to fill the remainder of
  /// the viewport and not extend further. However, if the
  /// [SliverConstraints.precedingScrollExtent] and/or the [child]'s
  /// extent exceeds the size of the viewport, the sliver will defer to the
  /// child's size rather than overriding it.
  final bool hasScrollBody;

  /// Indicates whether the child should stretch to fill the overscroll area
  /// created by certain scroll physics, such as iOS' default scroll physics.
  /// This flag is only relevant when [hasScrollBody] is false.
  ///
  /// Defaults to false, meaning that the default behavior is for the child to
  /// maintain its size and not extend into the overscroll area.
  final bool fillOverscroll;

  @override
  Widget build(BuildContext context) {
    if (hasScrollBody) {
      return _SliverFillRemainingWithScrollable(child: child);
    }
    if (!fillOverscroll) {
      return _SliverFillRemainingWithoutScrollable(child: child);
    }
    return _SliverFillRemainingAndOverscroll(child: child);
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<Widget>('child', child));
    final flags = <String>[if (hasScrollBody) 'scrollable', if (fillOverscroll) 'fillOverscroll'];
    if (flags.isEmpty) {
      flags.add('nonscrollable');
    }
    properties.add(IterableProperty<String>('mode', flags));
  }
}

class _SliverFillRemainingWithScrollable extends SingleChildRenderObjectWidget {
  const _SliverFillRemainingWithScrollable({super.child});

  @override
  RenderSliverFillRemainingWithScrollable createRenderObject(BuildContext context) =>
      RenderSliverFillRemainingWithScrollable();
}

class _SliverFillRemainingWithoutScrollable extends SingleChildRenderObjectWidget {
  const _SliverFillRemainingWithoutScrollable({super.child});

  @override
  RenderSliverFillRemaining createRenderObject(BuildContext context) => RenderSliverFillRemaining();
}

class _SliverFillRemainingAndOverscroll extends SingleChildRenderObjectWidget {
  const _SliverFillRemainingAndOverscroll({super.child});

  @override
  RenderSliverFillRemainingAndOverscroll createRenderObject(BuildContext context) =>
      RenderSliverFillRemainingAndOverscroll();
}
