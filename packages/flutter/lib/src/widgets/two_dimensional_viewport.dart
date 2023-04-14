// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';

import 'framework.dart';
import 'scroll_delegate.dart';
import 'scroll_notification.dart';

export 'package:flutter/rendering.dart' show AxisDirection, GrowthDirection;

/// A widget that is bigger on the inside.
///
/// [TwoDimensionalViewport] is the visual workhorse of the two dimensional
/// scrolling machinery. It displays a subset of its children according to its
/// own dimensions and the given [horizontalOffset] an [verticalOffset]. As the
/// offsets vary, different children are visible through the viewport.
abstract class TwoDimensionalViewport extends RenderObjectWidget {
  /// Creates a widget that is bigger on the inside.
  ///
  /// The viewport listens to the [horizontalOffset] and [verticalOffset], which
  /// means you do not need to rebuild this widget when the offsets change.
  const TwoDimensionalViewport({
    super.key,
    required this.verticalOffset,
    required this.verticalAxisDirection,
    required this.horizontalOffset,
    required this.horizontalAxisDirection,
    required this.delegate,
    required this.mainAxis,
    this.cacheExtent,
    this.clipBehavior = Clip.hardEdge,
  }) : assert(verticalAxisDirection == AxisDirection.down || verticalAxisDirection == AxisDirection.up),
       assert(horizontalAxisDirection == AxisDirection.left || horizontalAxisDirection == AxisDirection.right);

  /// Which part of the content inside the viewport should be visible in the
  /// vertical axis.
  ///
  /// The [ViewportOffset.pixels] value determines the scroll offset that the
  /// viewport uses to select which part of its content to display. As the user
  /// scrolls the viewport vertically, this value changes, which changes the
  /// content that is displayed.
  ///
  /// Typically a [ScrollPosition].
  final ViewportOffset verticalOffset;

  /// The direction in which the [verticalOffset]'s [ViewportOffset.pixels]
  /// increases.
  ///
  /// For example, if the [axisDirection] is [AxisDirection.down], a scroll
  /// offset of zero is at the top of the viewport and increases towards the
  /// bottom of the viewport.
  ///
  /// Must be either [AxisDirection.down] or [AxisDirection.up] in correlation
  /// with an [Axis.vertical].
  final AxisDirection verticalAxisDirection;

  /// Which part of the content inside the viewport should be visible in the
  /// horizontal axis.
  ///
  /// The [ViewportOffset.pixels] value determines the scroll offset that the
  /// viewport uses to select which part of its content to display. As the user
  /// scrolls the viewport horizontally, this value changes, which changes the
  /// content that is displayed.
  ///
  /// Typically a [ScrollPosition].
  final ViewportOffset horizontalOffset;

  /// The direction in which the [horizontalOffset]'s [ViewportOffset.pixels]
  /// increases.
  ///
  /// For example, if the [axisDirection] is [AxisDirection.right], a scroll
  /// offset of zero is at the left of the viewport and increases towards the
  /// right of the viewport.
  ///
  /// Must be either [AxisDirection.left] or [AxisDirection.right] in correlation
  /// with an [Axis.horizontal].
  final AxisDirection horizontalAxisDirection;

  /// The main axis of the two.
  ///
  /// Used by subclasses to determine the visitor pattern for the
  /// children of the viewport.
  final Axis mainAxis;

  /// {@macro flutter.rendering.RenderViewportBase.cacheExtent}
  final double? cacheExtent;

  /// {@macro flutter.material.Material.clipBehavior}
  final Clip clipBehavior;

  /// A delegate that provides the children for the [TwoDimensionalViewport].
  final TwoDimensionalChildDelegate delegate;

  @override
  RenderObjectElement createElement() => _TwoDimensionalViewportElement(this);

  @override
  RenderObject createRenderObject(BuildContext context);

  @override
  void updateRenderObject(BuildContext context, RenderTwoDimensionalViewport renderObject);
}

class _TwoDimensionalViewportElement extends RenderObjectElement
    with NotifiableElementMixin, ViewportElementMixin implements _TwoDimensionalChildManager {
  _TwoDimensionalViewportElement(super.widget);

  @override
  TwoDimensionalViewport get widget => super.widget as TwoDimensionalViewport;

  @override
  RenderTwoDimensionalViewport get renderObject => super.renderObject as RenderTwoDimensionalViewport;

  // Contains all children, incl those that are keyed.
  Map<ChildVicinity, Element> _indexToChild = <ChildVicinity, Element>{};
  Map<Key, Element> _keyToChild = <Key, Element>{};
  // Used between _startLayout() & _endLayout() to compute the new values for
  // _indexToChild and _keyToChild.
  Map<ChildVicinity, Element>? _newIndexToChild;
  Map<Key, Element>? _newKeyToChild;

  @override
  void performRebuild() {
    super.performRebuild();
    // Children list is updated during layout since we only know during layout
    // which children will be visible.
    renderObject.markNeedsLayout(
      withChildRebuild: true,
      withDelegateRebuild: true,
    );
  }

  @override
  void forgetChild(Element child) {
    assert(!_debugIsDoingLayout);
    super.forgetChild(child);
    _indexToChild.remove(child.slot);
    if (child.widget.key != null) {
      _keyToChild.remove(child.widget.key);
    }
  }

  @override
  void insertRenderObjectChild(RenderBox child, ChildVicinity slot) {
    renderObject._insertChild(child, slot);
  }

  @override
  void moveRenderObjectChild(RenderBox child, ChildVicinity oldSlot, ChildVicinity newSlot) {
    renderObject._moveChild(child, from: oldSlot, to: newSlot);
  }

  @override
  void removeRenderObjectChild(RenderBox child, ChildVicinity slot) {
    renderObject._removeChild(child, slot);
  }

  @override
  void visitChildren(ElementVisitor visitor) {
    _indexToChild.values.forEach(visitor);
  }

  @override
  List<DiagnosticsNode> debugDescribeChildren() {
    final List<Element> children = _indexToChild.values.toList()..sort(_compareChildren);
    return children.map((Element child) {
      return child.toDiagnosticsNode(name: child.slot.toString());
    }).toList();
  }

  int _compareChildren(Element a, Element b) {
    final ChildVicinity aSlot = a.slot! as ChildVicinity;
    final ChildVicinity bSlot = b.slot! as ChildVicinity;
    return aSlot.compareTo(bSlot);
  }

  // ---- ChildManager implementation ----

  bool get _debugIsDoingLayout => _newKeyToChild != null && _newIndexToChild != null;

  @override
  void startLayout() {
    assert(!_debugIsDoingLayout);
    _newIndexToChild = <ChildVicinity, Element>{};
    _newKeyToChild = <Key, Element>{};
  }

  @override
  void buildChild(ChildVicinity vicinity) {
    assert(_debugIsDoingLayout);
    owner!.buildScope(this, () {
      final Widget newWidget = widget.delegate.build(this, vicinity);
      final Element? oldElement = _retrieveOldElement(newWidget, vicinity);
      final Element? newChild = updateChild(oldElement, newWidget, vicinity);
      assert(newChild != null); // because newWidget is never null.
      _newIndexToChild![vicinity] = newChild!;
      if (newWidget.key != null) {
        _newKeyToChild![newWidget.key!] = newChild;
      }
    });
  }

  Element? _retrieveOldElement(Widget newWidget, ChildVicinity index) {
    if (newWidget.key != null) {
      final Element? result = _keyToChild.remove(newWidget.key);
      if (result != null) {
        _indexToChild.remove(result.slot);
      }
      return result;
    }
    final Element? potentialOldElement = _indexToChild[index];
    if (potentialOldElement != null && potentialOldElement.widget.key == null) {
      return _indexToChild.remove(index);
    }
    return null;
  }

  @override
  void reuseChild(ChildVicinity index) {
    assert(_debugIsDoingLayout);
    final Element? elementToReuse = _indexToChild.remove(index);
    assert(elementToReuse != null); // has to exist since we are reusing it.
    _newIndexToChild![index] = elementToReuse!;
    if (elementToReuse.widget.key != null) {
      assert(_keyToChild.containsKey(elementToReuse.widget.key));
      assert(_keyToChild[elementToReuse.widget.key] == elementToReuse);
      _newKeyToChild![elementToReuse.widget.key!] = _keyToChild.remove(elementToReuse.widget.key)!;
    }
  }

  @override
  void endLayout() {
    assert(_debugIsDoingLayout);

    // Unmount all elements that have not been reused in the layout cycle.
    for (final Element element in _indexToChild.values) {
      if (element.widget.key == null) {
        // If it has a key, we handle it below.
        updateChild(element, null, null);
      } else {
        assert(_keyToChild.containsValue(element));
      }
    }
    for (final Element element in _keyToChild.values) {
      assert(element.widget.key != null);
      updateChild(element, null, null);
    }

    _indexToChild = _newIndexToChild!;
    _keyToChild = _newKeyToChild!;
    _newIndexToChild = null;
    _newKeyToChild = null;
    assert(!_debugIsDoingLayout);
  }
}

/// Parent data structure used by [RenderTwoDimensionalViewport].
class TwoDimensionalViewportParentData extends BoxParentData {
  /// The logical positioning of children in two dimensions.
  ///
  /// While children may not be strictly laid out in rows and columns, the
  /// relative positioning determines traversal of
  /// children in row or column major format.
  ChildVicinity vicinity = ChildVicinity.invalid;

  @override
  String toString() => 'vicinity=$vicinity; ${super.toString()}';
}

/// A base class for viewing render objects that scroll in two dimensions.
///
/// The viewport listens to two [ViewportOffset]s, which determines the
/// visible content.
///
/// Subclasses must override [performLayout], and use the [delegate] to retrieve
/// and layout children.
abstract class RenderTwoDimensionalViewport extends RenderBox implements RenderAbstractViewport {
  /// Initializes fields for subclasses.
  RenderTwoDimensionalViewport({
    required ViewportOffset horizontalOffset,
    required AxisDirection horizontalAxisDirection,
    required ViewportOffset verticalOffset,
    required AxisDirection verticalAxisDirection,
    required TwoDimensionalChildDelegate delegate,
    required Axis mainAxis,
    required RenderObjectElement childManager,
    double? cacheExtent,
    Clip clipBehavior = Clip.hardEdge,
  }) : _childManager = childManager as _TwoDimensionalChildManager,
       _horizontalOffset = horizontalOffset,
       _horizontalAxisDirection = horizontalAxisDirection,
       _verticalOffset = verticalOffset,
        _verticalAxisDirection = verticalAxisDirection,
       _delegate = delegate,
       _mainAxis = mainAxis,
       _cacheExtent = cacheExtent ?? RenderAbstractViewport.defaultCacheExtent,
       _clipBehavior = clipBehavior;

  /// Which part of the content inside the viewport should be visible in the
  /// horizontal axis.
  ///
  /// The [ViewportOffset.pixels] value determines the scroll offset that the
  /// viewport uses to select which part of its content to display. As the user
  /// scrolls the viewport horizontally, this value changes, which changes the
  /// content that is displayed.
  ///
  /// Typically a [ScrollPosition].
  ViewportOffset get horizontalOffset => _horizontalOffset;
  ViewportOffset _horizontalOffset;
  set horizontalOffset(ViewportOffset value) {
    if (_horizontalOffset == value) {
      return;
    }
    if (attached) {
      _horizontalOffset.removeListener(markNeedsLayout);
    }
    _horizontalOffset = value;
    if (attached) {
      _horizontalOffset.addListener(markNeedsLayout);
    }
    markNeedsLayout();
  }

  /// The direction in which the [horizontalOffset] increases.
  ///
  /// For example, if the [axisDirection] is [AxisDirection.right], a scroll
  /// offset of zero is at the right of the viewport and increases towards the
  /// left of the viewport.
  AxisDirection get horizontalAxisDirection => _horizontalAxisDirection;
  AxisDirection _horizontalAxisDirection;
  set horizontalAxisDirection(AxisDirection value) {
    if (_horizontalAxisDirection == value) {
      return;
    }
    _horizontalAxisDirection = value;
    markNeedsLayout();
  }

  /// Which part of the content inside the viewport should be visible in the
  /// vertical axis.
  ///
  /// The [ViewportOffset.pixels] value determines the scroll offset that the
  /// viewport uses to select which part of its content to display. As the user
  /// scrolls the viewport vertically, this value changes, which changes the
  /// content that is displayed.
  ///
  /// Typically a [ScrollPosition].
  ViewportOffset get verticalOffset => _verticalOffset;
  ViewportOffset _verticalOffset;
  set verticalOffset(ViewportOffset value) {
    if (_verticalOffset == value) {
      return;
    }
    if (attached) {
      _verticalOffset.removeListener(markNeedsLayout);
    }
    _verticalOffset = value;
    if (attached) {
      _verticalOffset.addListener(markNeedsLayout);
    }
    markNeedsLayout();
  }

  /// The direction in which the [verticalOffset] increases.
  ///
  /// For example, if the [axisDirection] is [AxisDirection.down], a scroll
  /// offset of zero is at the top the viewport and increases towards the
  /// bottom of the viewport.
  AxisDirection get verticalAxisDirection => _verticalAxisDirection;
  AxisDirection _verticalAxisDirection;
  set verticalAxisDirection(AxisDirection value) {
    if (_verticalAxisDirection == value) {
      return;
    }
    _verticalAxisDirection = value;
    markNeedsLayout();
  }

  /// Supplies children for layout in the viewport.
  TwoDimensionalChildDelegate get delegate => _delegate;
  TwoDimensionalChildDelegate _delegate;
  set delegate(TwoDimensionalChildDelegate value) {
    if (_delegate == value) {
      return;
    }
    if (attached) {
      _delegate.removeListener(_handleDelegateNotification);
    }
    final TwoDimensionalChildDelegate oldDelegate = value;
    _delegate = value;
    if (attached) {
      _delegate.addListener(_handleDelegateNotification);
    }
    if (_delegate.runtimeType != oldDelegate.runtimeType || _delegate.shouldRebuild(oldDelegate)) {
      _handleDelegateNotification();
    }
  }

  /// The major axis of the two dimensions.
  ///
  /// This is can be used by subclasses to determine paint order,
  /// visitor patterns like row and column major ordering, or hit test
  /// precedence.
  Axis  get mainAxis => _mainAxis;
  Axis _mainAxis;
  set mainAxis(Axis value) {
    if (_mainAxis == value) {
      return;
    }
    _mainAxis = value;
    markNeedsLayout();
  }

  /// {@macro flutter.rendering.RenderViewportBase.cacheExtent}
  double?  get cacheExtent => _cacheExtent;
  double? _cacheExtent;
  set cacheExtent(double? value) {
    if (_cacheExtent == value) {
      return;
    }
    _cacheExtent = value;
    markNeedsLayout();
  }

  /// {@macro flutter.material.Material.clipBehavior}
  Clip get clipBehavior => _clipBehavior;
  Clip _clipBehavior;
  set clipBehavior(Clip value) {
    if (_clipBehavior == value) {
      return;
    }
    _clipBehavior = value;
    markNeedsLayout();
  }

  final _TwoDimensionalChildManager _childManager;

  void _handleDelegateNotification() {
    return markNeedsLayout(
      withChildRebuild: true,
      withDelegateRebuild: true,
    );
  }

  @override
  void setupParentData(RenderBox child) {
    if (child.parentData is! TwoDimensionalViewportParentData) {
      child.parentData = TwoDimensionalViewportParentData();
    }
  }

  @override
  void attach(PipelineOwner owner) {
    super.attach(owner);
    _horizontalOffset.addListener(markNeedsLayout);
    _verticalOffset.addListener(markNeedsLayout);
    _delegate.addListener(_handleDelegateNotification);
    for (final RenderBox child in _children.values) {
      child.attach(owner);
    }
  }

  @override
  void detach() {
    super.detach();
    _horizontalOffset.removeListener(markNeedsLayout);
    _verticalOffset.removeListener(markNeedsLayout);
    _delegate.removeListener(_handleDelegateNotification);
    for (final ChildVicinity cellIndex in _children.keys) {
      _children[cellIndex]!.detach();
    }
  }

  @override
  void redepthChildren() {
    for (final RenderBox child in _children.values) {
      child.redepthChildren();
    }
  }

  @override
  void visitChildren(RenderObjectVisitor visitor) {
    _children.values.forEach(visitor);
  }

  @override
  void visitChildrenForSemantics(RenderObjectVisitor visitor) {
    _children.values.forEach(visitor);
  }

  @override
  List<DiagnosticsNode> debugDescribeChildren() {
    final List<DiagnosticsNode> debugChildren = <DiagnosticsNode>[
      ..._children.keys.map<DiagnosticsNode>((ChildVicinity index) {
        return _children[index]!.toDiagnosticsNode(name: index.toString());
      })
    ];
    return debugChildren;
  }

  @override
  bool get isRepaintBoundary => true;

  @override
  bool get sizedByParent => true;

  @override
  Size computeDryLayout(BoxConstraints constraints) {
    debugCheckHasBoundedAxis(Axis.vertical, constraints);
    debugCheckHasBoundedAxis(Axis.horizontal, constraints);
    return constraints.biggest;
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    for (final RenderBox child in _children.values) {
      final TwoDimensionalViewportParentData parentData = child.parentData! as TwoDimensionalViewportParentData;
      final Rect childRect = parentData.offset & child.size;
      if (childRect.contains(position)) {
        result.addWithPaintOffset(
          offset: parentData.offset,
          position: position,
          hitTest: (BoxHitTestResult result, Offset transformed) {
            assert(transformed == position - parentData.offset);
            return child.hitTest(result, position: transformed);
          },
        );
        return true;
      }
    }
    return false;
  }

  final Map<ChildVicinity, RenderBox> _children = <ChildVicinity, RenderBox>{};

  @override
  void performResize() {
    final Size? oldSize = hasSize ? size : null;
    super.performResize();
    // Ignoring return value since we are doing a layout either way
    // (performLayout will be invoked next).
    horizontalOffset.applyViewportDimension(size.width);
    verticalOffset.applyViewportDimension(size.height);
    if (oldSize != size) {
      // Specs can depend on viewport size.
      _didResize = true;
    }
  }

  bool _needsChildRebuild = true;

  /// Should be used by subclasses to invalidate any cached metrics for the
  /// viewport.
  ///
  /// This is set to true when the viewport has been resized, indicating that
  /// any cached metrics are invalid.
  bool get didResize => _didResize;
  bool _didResize = true;

  /// Should be used by subclasses to invalidate any cached data from the
  /// [delegate].
  ///
  /// Must be false when [endLayout] is called.
  @protected
  bool needsDelegateRebuild = true;

  @override
  void markNeedsLayout({bool withChildRebuild = false, bool withDelegateRebuild = false}) {
    _needsChildRebuild = _needsChildRebuild || withChildRebuild;
    needsDelegateRebuild = needsDelegateRebuild || withDelegateRebuild;
    super.markNeedsLayout();
  }

  /// Primary work horse of [performLayout].
  ///
  /// Subclasses must implement this method to layout and position the children
  /// of the viewport. The [BoxParentData.offset] must be set during this method
  /// in order for the children to be positioned during [paint], the subclass is
  /// overriding the paint method. // TODO(Piinks): Add paint!
  ///
  /// The primary methods used for laying out, painting & positioning children
  /// are:
  ///
  ///   * [buildOrObtainChildFor], which takes a [ChildVicinity] that is used
  ///     by the [TwoDimensionalChildDelegate]. If a child is not provided by
  ///     the delegate for the provided vicinity, the method will return null,
  ///     otherwise, it will return the [RenderBox] of the child.
  ///   * [getChildFor], which takes a [ChildVicinity] that is used to retrieve
  ///     a child that already exists, such as for painting.
  ///   * [computeAbsolutePaintOffsetFor], which takes a child and applies the
  ///     [AxisDirection] to the [BoxParentData.offset] in order to position the
  ///     child. // TODO(Piinks): add this!
  void layoutChildren();

  @override
  void performLayout() {
    _childManager.startLayout();

    layoutChildren();

    _needsChildRebuild = false;
    _didResize = false;
    assert(_debugOrphans?.isEmpty ?? true);
    assert(needsDelegateRebuild == false);
    invokeLayoutCallback<BoxConstraints>((BoxConstraints _) {
      _childManager.endLayout();
    });
  }

  /// Returns the child for a given [ChildVicinity].
  ///
  /// This method will build the child if it has not been already, or will reuse
  /// it if it already exists.
  RenderBox? buildOrObtainChildFor(ChildVicinity vicinity) {
    if (_needsChildRebuild || !_children.containsKey(vicinity)) {
      invokeLayoutCallback<BoxConstraints>((BoxConstraints _) {
        _childManager.buildChild(vicinity);
      });
    } else {
      _childManager.reuseChild(vicinity);
    }
    if (!_children.containsKey(vicinity)) {
      // There is no child for this vicinity, we may have reached the end of the
      // children in one or both od the x/y indices.
      return null;
    }

    assert(_children.containsKey(vicinity));
    return _children[vicinity]!;
  }

  /// Returns a the child for the given [ChildVicinity] if it has been created.
  RenderBox? getChildFor(ChildVicinity locale) {
    if (_children.containsKey(locale)) {
      return _children[locale]!;
    }
    return null;
  }

  // ---- Called from _TwoDimensionalViewportElement ----

  void _insertChild(RenderBox child, ChildVicinity slot) {
    if (slot.xIndex == 0 && slot.yIndex == 0) {
    }
    assert(_debugTrackOrphans(newOrphan: _children[slot]));
    _children[slot] = child;
    adoptChild(child);
  }

  void _moveChild(RenderBox child, {required ChildVicinity from, required ChildVicinity to}) {
    if (_children[from] == child) {
      _children.remove(from);
    }
    assert(_debugTrackOrphans(newOrphan: _children[to], noLongerOrphan: child));
    _children[to] = child;
  }

  void _removeChild(RenderBox child, ChildVicinity slot) {
    if (slot.xIndex == 0 && slot.yIndex == 0) {
    }
    if (_children[slot] == child) {
      _children.remove(slot);
    }
    assert(_debugTrackOrphans(noLongerOrphan: child));
    dropChild(child);
  }

  List<RenderBox>? _debugOrphans;

  // When a child is inserted into a slot currently occupied by another child,
  // it becomes an orphan until it is either moved to another slot or removed.
  bool _debugTrackOrphans({RenderBox? newOrphan, RenderBox? noLongerOrphan}) {
    assert(() {
      _debugOrphans ??= <RenderBox>[];
      if (newOrphan != null) {
        _debugOrphans!.add(newOrphan);
      }
      if (noLongerOrphan != null) {
        _debugOrphans!.remove(noLongerOrphan);
      }
      return true;
    }());
    return true;
  }

  /// Throws an exception saying that the object does not support returning
  /// intrinsic dimensions if, in debug mode, we are not in the
  /// [RenderObject.debugCheckingIntrinsics] mode.
  ///
  /// This is used by [computeMinIntrinsicWidth] et al because viewports do not
  /// generally support returning intrinsic dimensions. See the discussion at
  /// [computeMinIntrinsicWidth].
  @protected
  bool debugThrowIfNotCheckingIntrinsics() {
    assert(() {
      if (!RenderObject.debugCheckingIntrinsics) {
        throw FlutterError.fromParts(<DiagnosticsNode>[
          ErrorSummary('$runtimeType does not support returning intrinsic dimensions.'),
          ErrorDescription(
            'Calculating the intrinsic dimensions would require instantiating every child of '
            'the viewport, which defeats the point of viewports being lazy.',
          ),
        ]);
      }
      return true;
    }());
    return true;
  }

  @override
  double computeMinIntrinsicWidth(double height) {
    assert(debugThrowIfNotCheckingIntrinsics());
    return 0.0;
  }

  @override
  double computeMaxIntrinsicWidth(double height) {
    assert(debugThrowIfNotCheckingIntrinsics());
    return 0.0;
  }

  @override
  double computeMinIntrinsicHeight(double width) {
    assert(debugThrowIfNotCheckingIntrinsics());
    return 0.0;
  }

  @override
  double computeMaxIntrinsicHeight(double width) {
    assert(debugThrowIfNotCheckingIntrinsics());
    return 0.0;
  }
}

/// A delegate used by [RenderTwoDimensionalViewport] to manage its children.
///
/// [RenderTwoDimensionalViewport] objects reify their children lazily to avoid
/// spending resources on children that are not visible in the viewport. This
/// delegate lets these objects create, reuse and remove children.
abstract class _TwoDimensionalChildManager {
  void startLayout();
  void buildChild(ChildVicinity index);
  void reuseChild(ChildVicinity index);
  void endLayout();
}

/// The relative positioning of children in a [TwoDimensionalViewport].
@immutable
class ChildVicinity implements Comparable<ChildVicinity> {
  /// Creates an reference to a child in a two dimensional plane, with the [xIndex]
  /// and [yIndex] being relative to other children in the viewport.
  const ChildVicinity({required this.xIndex, required this.yIndex});

  /// Represents an unassigned child position. The given child may be in the
  /// process of moving from one position to another.
  static const ChildVicinity invalid = ChildVicinity(xIndex: -1, yIndex: -1);

  /// The index of the child in the horizontal axis, relative to neighboring
  /// children.
  ///
  /// While children's offset and positioning may not be strictly defined in
  /// terms of rows and columns, like a table, [ChildVicinity.xIndex] and
  /// [ChildVicinity.yIndex] can represent order of traversal in row or column
  /// major format.
  final int xIndex;

  /// The index of the child in the vertical axis, relative to neighboring
  /// children.
  ///
  /// While children's offset and positioning may not be strictly defined in
  /// terms of rows and columns, like a table, [ChildVicinity.xIndex] and
  /// [ChildVicinity.yIndex] can represent order of traversal in row or column
  /// major format.
  final int yIndex;

  @override
  bool operator ==(Object other) {
    return other is ChildVicinity
      && other.xIndex == xIndex
      && other.yIndex == yIndex;
  }

  @override
  int get hashCode => Object.hash(xIndex, yIndex);

  @override
  int compareTo(ChildVicinity other) {
    if (xIndex == other.xIndex) {
      return yIndex - other.yIndex;
    }
    return xIndex - other.xIndex;
  }

  @override
  String toString() {
    return '(yIndex: $yIndex, xIndex: $xIndex)';
  }
}
