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
/// [TwoDimensionalViewport] is the visual workhorse of the scrolling machinery.
/// It displays a subset of its children according to its own dimensions and the
/// given [horizontalOffset] an [verticalOffset]. As the offsets vary,
/// different children are visible through the viewport.
abstract class TwoDimensionalViewport extends RenderObjectWidget {
  /// Creates a widget that is bigger on the inside.
  ///
  /// The viewport listens to the [horizontalOffset] and [verticalOffset], which
  /// means you do not need to rebuild this widget when the offsets change.
  const TwoDimensionalViewport({
    super.key,
    required this.verticalOffset,
    required this.horizontalOffset,
    required this.delegate,
    required this.mainAxis,
    this.cacheExtent,
    this.clipBehavior = Clip.hardEdge,
  });

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

  /// The main axis of the two.
  ///
  /// Can be used by subclasses to determine paint order or focus traversal.
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
  void buildChild(ChildVicinity index) {
    assert(_debugIsDoingLayout);
    owner!.buildScope(this, () {
      final Widget newWidget = widget.delegate.build(this, index.yIndex, index.xIndex);
      final Element? oldElement = _retrieveOldElement(newWidget, index);
      final Element? newChild = updateChild(oldElement, newWidget, index);
      assert(newChild != null); // because newWidget is never null.
      _newIndexToChild![index] = newChild!;
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

/// This class exists to dissociate [KeepAlive] from
/// [RenderTwoDimensionalViewport].
///
/// [RenderTwoDimensionalChildrenWithKeepAliveMixin.setupParentData] must be
/// implemented to use a parentData class that uses the right mixin or whatever
/// is appropriate.
mixin RenderTwoDimensionalChildrenWithKeepAliveMixin implements RenderBox {
  /// Alerts the developer that the child's parentData needs to be of type
  /// [KeepAliveParentDataMixin].
  @override
  void setupParentData(RenderObject child) {
    assert(child.parentData is KeepAliveParentDataMixin);
  }
}

/// Parent data structure used by [RenderTwoDimensionalViewport].
class TwoDimensionalViewportParentData extends BoxParentData with KeepAliveParentDataMixin {
  /// The next sibling in the parent's child list.
  RenderBox? nextSibling;

  /// The previous sibling in the parent's child list.
  RenderBox? previousSibling;

  // TODO(Piinks): Add assertions for invalid locales
  /// The logical positioning of children in two dimensions.
  ///
  /// While children may not be strictly laid out in [ChildVicinity.xIndex]s and
  /// [ChildVicinity.yIndex]s, the relative positioning determines traversal of
  /// children in row or column major format.
  ChildVicinity locale = ChildVicinity.invalid;

  @override
  bool get keptAlive => _keptAlive;
  bool _keptAlive = false;

  @override
  String toString() => 'locale=$locale; ${keepAlive == true ? "keepAlive; " : ""}${super.toString()}';
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
    required ViewportOffset verticalOffset,
    required TwoDimensionalChildDelegate delegate,
    required Axis mainAxis,
    // TODO(Piinks): I dunno if this is what Goderbauer meant
    required RenderObjectElement childManager,
    double cacheExtent = RenderAbstractViewport.defaultCacheExtent,
    Clip clipBehavior = Clip.hardEdge,
  }) : _childManager = childManager as _TwoDimensionalChildManager,
       _horizontalOffset = horizontalOffset,
       _verticalOffset = verticalOffset,
       _delegate = delegate,
       _mainAxis = mainAxis,
       _cacheExtent = cacheExtent,
       _clipBehavior = clipBehavior {
    assert(() {
      _debugDanglingKeepAlives = <RenderBox>[];
      return true;
    }());
  }

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

  /// The main axis of the two.
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
  double  get cacheExtent => _cacheExtent;
  double _cacheExtent;
  set cacheExtent(double value) {
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

  /// The nodes being kept alive despite not being visible.
  final Map<ChildVicinity, RenderBox> _keepAliveBucket = <ChildVicinity, RenderBox>{};
  late List<RenderBox> _debugDanglingKeepAlives;

  /// Indicates whether integrity check is enabled.
  ///
  /// Setting this property to true will immediately perform an integrity check.
  ///
  /// The integrity check consists of:
  ///
  /// 1. Verify that the children index in childList is in ascending order.
  /// 2. Verify that there is no dangling keepalive child as the result of [move].
  // TODO(Piinks): Revisit after fixing keep alive.
  bool get debugChildIntegrityEnabled => _debugChildIntegrityEnabled;
  bool _debugChildIntegrityEnabled = true;
  set debugChildIntegrityEnabled(bool enabled) {
    assert(() {
      _debugChildIntegrityEnabled = enabled;
      // TODO(Piinks): Re-implement _debugVerifyChildOrder with mainAxis
      return //_debugVerifyChildOrder() &&
        (!_debugChildIntegrityEnabled || _debugDanglingKeepAlives.isEmpty);
    }());
  }

  void _handleDelegateNotification() => markNeedsLayout(withChildRebuild: true, withDelegateRebuild: true);

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
    for (final RenderBox child in _keepAliveBucket.values) {
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
    for (final RenderBox child in _keepAliveBucket.values) {
      child.detach();
    }
  }

  @override
  void redepthChildren() {
    for (final RenderBox child in _children.values) {
      child.redepthChildren();
    }
    _keepAliveBucket.values.forEach(redepthChild);
  }

  @override
  void visitChildren(RenderObjectVisitor visitor) {
    _children.values.forEach(visitor);
    _keepAliveBucket.values.forEach(visitor);
  }

  @override
  void visitChildrenForSemantics(RenderObjectVisitor visitor) {
    _children.values.forEach(visitor);
    // Do not visit children in [_keepAliveBucket].
  }

  @override
  List<DiagnosticsNode> debugDescribeChildren() {
    final List<DiagnosticsNode> debugChildren = <DiagnosticsNode>[
      ..._children.keys.map<DiagnosticsNode>((ChildVicinity index) {
        return _children[index]!.toDiagnosticsNode(name: index.toString());
      })
    ];
    if (_keepAliveBucket.isNotEmpty) {
      final List<ChildVicinity> indices = _keepAliveBucket.keys.toList()..sort();
      for (final ChildVicinity index in indices) {
        debugChildren.add(_keepAliveBucket[index]!.toDiagnosticsNode(
          name: 'child with index [${index.xIndex}, ${index.yIndex}] (kept alive but not laid out)',
          style: DiagnosticsTreeStyle.offstage,
        ));
      }
    }
    return debugChildren;
  }

  @override
  bool get isRepaintBoundary => true;

  @override
  bool get sizedByParent => true;

  @override
  Size computeDryLayout(BoxConstraints constraints) {
    assert(() {
      if (!constraints.hasBoundedHeight || !constraints.hasBoundedWidth) {
        // TODO(Piinks): Error message
        throw FlutterError('Unbound constraints not allowed');
      }
      return true;
    }());
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

  ///
  // TODO(Piinks): This is flattened for easy traversal, but should it be 2D to
  //  more easily incorporate row/col major order?
  // TODO(Piinks): Incorporate mainAxis
  @protected
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
      didResize = true;
    }
  }

  bool _needsChildRebuild = true;

  /// Should be used by subclasses to invalidate any cached data from the
  /// [delegate].
  ///
  /// Must be false when [endLayout] is called.
  @protected
  bool needsDelegateRebuild = true;

  /// Should be used by subclasses to invalidate any cached metrics for the
  /// viewport.
  ///
  /// This is set to true when the viewport has been resized, indicating that
  /// any cached metrics are invalid. Must be false when [endLayout] is called.
  // TODO(Piinks): Can likely be private/getter is set to false in endLayout instead.
  @protected
  bool didResize = true;

  @override
  void markNeedsLayout({bool withChildRebuild = false, bool withDelegateRebuild = false}) {
    _needsChildRebuild = _needsChildRebuild || withChildRebuild;
    needsDelegateRebuild = needsDelegateRebuild || withDelegateRebuild;
    super.markNeedsLayout();
  }

  /// Primary work horse of [performLayout].
  ///
  /// Subclasses must implement this method,
  void layoutChildren();

  @override
  void performLayout() {
    _childManager.startLayout();

    layoutChildren();

    // TODO(Piinks): Do over, collect keep alives.
    // And wrap all these up in a debug method.
    _needsChildRebuild = false;
    assert(_debugOrphans?.isEmpty ?? true);
    assert(needsDelegateRebuild == false);
    assert(didResize == false);
    invokeLayoutCallback<BoxConstraints>((BoxConstraints _) {
      _childManager.endLayout();
    });
  }

  /// Returns the child for a given [ChildVicinity], creating it is it has not
  /// been already, or will reuse it if it already exists.
  RenderBox createOrObtainChildFor(ChildVicinity locale) {
    if (_needsChildRebuild || !_children.containsKey(locale)) {
      invokeLayoutCallback<BoxConstraints>((BoxConstraints _) {
        _childManager.buildChild(locale);
      });
    } else {
      _childManager.reuseChild(locale);
    }

    assert(_children.containsKey(locale));
    return _children[locale]!;
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

  @override
  RevealedOffset getOffsetToReveal(RenderObject target, double alignment, {Rect? rect, AxisDirection? revealingAxisDirection}) {
    // We need to know what axis to reveal in 2D
    assert(revealingAxisDirection != null);
    late final ViewportOffset offset;
    switch (axisDirectionToAxis(revealingAxisDirection!)) {
      case Axis.vertical:
        offset = _verticalOffset;
        break;
      case Axis.horizontal:
        offset = _horizontalOffset;
    }

    double leadingScrollOffset = offset.pixels;
    // Starting at `target` and walking towards the root:
    //  - `child` will be the last object before we reach this viewport, and
    //  - `pivot` will be the last RenderBox before we reach this viewport.
    RenderObject child = target;
    RenderBox? pivot;
    while (child.parent != this) {
      final RenderObject parent = child.parent! as RenderObject;
      assert(child is RenderBox);
      pivot = child as RenderBox;
      child = parent;
    }

    // `rect` in the new intermediate coordinate system.
    final Rect rectLocal;
    // Our new reference frame render object's main axis extent.
    final double pivotExtent;

    if (pivot != null) {
      assert(pivot.parent != null);
      assert(pivot.parent != this);
      assert(pivot != this);
      switch (axisDirectionToAxis(revealingAxisDirection)) {
        case Axis.horizontal:
          pivotExtent = pivot.size.width;
          break;
        case Axis.vertical:
          pivotExtent = pivot.size.height;
          break;
      }
      rect ??= target.paintBounds;
      rectLocal = MatrixUtils.transformRect(target.getTransformTo(pivot), rect);
    } else {
      assert(rect != null);
      return RevealedOffset(offset: offset.pixels, rect: rect!);
    }
    if (revealingAxisDirection == AxisDirection.up) {
      print(rect);
      print(rectLocal);
    }

    assert(child.parent == this);

    final double targetMainAxisExtent;
    // The scroll offset of `rect` within `child`.
    // TODO(Piinks): come back and fix for up and left when reverse layout is fixed
    switch (revealingAxisDirection) {
      case AxisDirection.up:
        leadingScrollOffset += pivotExtent - rectLocal.bottom;
        targetMainAxisExtent = rectLocal.height;
        break;
      case AxisDirection.right:
        leadingScrollOffset += rectLocal.left;
        if (alignment == 0) {
          leadingScrollOffset -= rectLocal.width;
        }
        targetMainAxisExtent = rectLocal.width;
        break;
      case AxisDirection.down:
        leadingScrollOffset += rectLocal.top;
        if (alignment == 0) {
          leadingScrollOffset -= rectLocal.width;
        }
        targetMainAxisExtent = rectLocal.height;
        break;
      case AxisDirection.left:
        leadingScrollOffset += pivotExtent - rectLocal.right;
        targetMainAxisExtent = rectLocal.width;
        break;
    }

    // The scroll offset in the viewport to `rect`.
    // leadingScrollOffset = child.parentData;

    // This step assumes the viewport's layout is up-to-date, i.e., if
    // offset.pixels is changed after the last performLayout, the new scroll
    // position will not be accounted for.
    final Matrix4 transform = target.getTransformTo(this);
    Rect targetRect = MatrixUtils.transformRect(transform, rect);

    final double mainAxisExtent;
    switch (axisDirectionToAxis(revealingAxisDirection)) {
      case Axis.horizontal:
        mainAxisExtent = size.width;
        break;
      case Axis.vertical:
        mainAxisExtent = size.height;
        break;
    }
    final double targetOffset = leadingScrollOffset - (mainAxisExtent - targetMainAxisExtent) * alignment;

    final RevealedOffset rOffset = RevealedOffset(offset: targetOffset, rect: targetRect);
    if (revealingAxisDirection == AxisDirection.up) {
      print(
          '$leadingScrollOffset - ($mainAxisExtent - $targetMainAxisExtent) * $alignment');
      print('targetOffset: $targetOffset');

      print(rOffset);
    }
    return rOffset;
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
    return '(column: $yIndex, row: $xIndex)';
  }
}
