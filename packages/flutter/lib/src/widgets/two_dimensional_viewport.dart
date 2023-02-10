// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';

import 'framework.dart';
import 'scroll_notification.dart';

export 'package:flutter/rendering.dart' show AxisDirection, GrowthDirection;

///
abstract class TwoDimensionalChildDelegate extends ChangeNotifier {
  ///
  TwoDimensionalChildDelegate({ this.mainAxis = Axis.vertical});

  // TODO(Piinks): Move main axis implementation here
  ///
  final Axis mainAxis;

  ///
  Widget build(BuildContext context, int column, int row);

  ///
  bool shouldRebuild(covariant TwoDimensionalChildDelegate oldDelegate);

  // toString

  // debugFillDescription
}

///
abstract class TwoDimensionalViewport extends RenderObjectWidget {
  ///
  const TwoDimensionalViewport({
    super.key,
    // required this.mainAxis,
    required this.verticalOffset,
    required this.horizontalOffset,
    required this.delegate,
    this.cacheExtent,
    this.clipBehavior = Clip.hardEdge,
  });

  ///
  // TODO(Piinks): Move to delegate
  // final Axis mainAxis;

  ///
  final ViewportOffset verticalOffset;

  ///
  final ViewportOffset horizontalOffset;

  ///
  final double? cacheExtent;

  ///
  final Clip clipBehavior;

  ///
  final TwoDimensionalChildDelegate delegate;

  @override
  RenderObjectElement createElement() => _TwoDimensionalViewportElement(this);

  @override
  RenderObject createRenderObject(BuildContext context);

  @override
  void updateRenderObject(BuildContext context, RenderTwoDimensionalViewport renderObject);
}

class _TwoDimensionalViewportElement extends RenderObjectElement
    with NotifiableElementMixin, ViewportElementMixin implements TwoDimensionalChildManager {
  _TwoDimensionalViewportElement(super.widget);

  @override
  TwoDimensionalViewport get widget => super.widget as TwoDimensionalViewport;

  @override
  RenderTwoDimensionalViewport get renderObject => super.renderObject as RenderTwoDimensionalViewport;

  // Contains all children, incl those that are keyed.
  Map<ChildLocale, Element> _indexToChild = <ChildLocale, Element>{};
  Map<Key, Element> _keyToChild = <Key, Element>{};
  // Used between _startLayout() & _endLayout() to compute the new values for
  // _indexToChild and _keyToChild.
  Map<ChildLocale, Element>? _newIndexToChild;
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
  void insertRenderObjectChild(RenderBox child, ChildLocale slot) {
    renderObject._insertChild(child, slot);
  }

  @override
  void moveRenderObjectChild(RenderBox child, ChildLocale oldSlot, ChildLocale newSlot) {
    renderObject._moveChild(child, from: oldSlot, to: newSlot);
  }

  @override
  void removeRenderObjectChild(RenderBox child, ChildLocale slot) {
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
    final ChildLocale aSlot = a.slot! as ChildLocale;
    final ChildLocale bSlot = b.slot! as ChildLocale;
    return aSlot.compareTo(bSlot);
  }

  // ---- ChildManager implementation ----

  bool get _debugIsDoingLayout => _newKeyToChild != null && _newIndexToChild != null;

  @override
  void _startLayout() {
    assert(!_debugIsDoingLayout);
    _newIndexToChild = <ChildLocale, Element>{};
    _newKeyToChild = <Key, Element>{};
  }

  @override
  void _buildChild(ChildLocale index) {
    assert(_debugIsDoingLayout);
    owner!.buildScope(this, () {
      final Widget newWidget = widget.delegate.build(this, index.column, index.row);
      final Element? oldElement = _retrieveOldElement(newWidget, index);
      final Element? newChild = updateChild(oldElement, newWidget, index);
      assert(newChild != null); // because newWidget is never null.
      _newIndexToChild![index] = newChild!;
      if (newWidget.key != null) {
        _newKeyToChild![newWidget.key!] = newChild;
      }
    });
  }

  Element? _retrieveOldElement(Widget newWidget, ChildLocale index) {
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
  void _reuseChild(ChildLocale index) {
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
  void _endLayout() {
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
  /// While children may not be strictly laid out in [ChildLocale.row]s and
  /// [ChildLocale.column]s, the relative positioning determines traversal of
  /// children in row or column major format.
  ChildLocale locale = ChildLocale.invalid;

  @override
  bool get keptAlive => _keptAlive;
  bool _keptAlive = false;

  @override
  String toString() => 'locale=$locale; ${keepAlive == true ? "keepAlive; " : ""}${super.toString()}';
}

///
abstract class RenderTwoDimensionalViewport extends RenderBox implements RenderAbstractViewport {
  ///
  RenderTwoDimensionalViewport({
    required ViewportOffset horizontalOffset,
    required ViewportOffset verticalOffset,
    required TwoDimensionalChildDelegate delegate,
    required TwoDimensionalChildManager childManager,
    // required this.mainAxis,
    this.cacheExtent = RenderAbstractViewport.defaultCacheExtent,
    this.clipBehavior = Clip.hardEdge,
  }) : _childManager = childManager,
        _horizontalOffset = horizontalOffset,
        _verticalOffset = verticalOffset,
        _delegate = delegate {
    assert(() {
      _debugDanglingKeepAlives = <RenderBox>[];
      return true;
    }());
  }

  // TODO(Piinks): Add getters and setters
  // Axis mainAxis;
  double cacheExtent;
  Clip clipBehavior;

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

  final TwoDimensionalChildManager _childManager;

  /// The nodes being kept alive despite not being visible.
  final Map<ChildLocale, RenderBox> _keepAliveBucket = <ChildLocale, RenderBox>{};
  late List<RenderBox> _debugDanglingKeepAlives;

  /// Indicates whether integrity check is enabled.
  ///
  /// Setting this property to true will immediately perform an integrity check.
  ///
  /// The integrity check consists of:
  ///
  /// 1. Verify that the children index in childList is in ascending order.
  /// 2. Verify that there is no dangling keepalive child as the result of [move].
  bool get debugChildIntegrityEnabled => _debugChildIntegrityEnabled;
  bool _debugChildIntegrityEnabled = true;
  set debugChildIntegrityEnabled(bool enabled) {
    assert(() {
      _debugChildIntegrityEnabled = enabled;
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
    for (final ChildLocale cellIndex in _children.keys) {
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
      ..._children.keys.map<DiagnosticsNode>((ChildLocale index) {
        return _children[index]!.toDiagnosticsNode(name: index.toString());
      })
    ];
    if (_keepAliveBucket.isNotEmpty) {
      final List<ChildLocale> indices = _keepAliveBucket.keys.toList()..sort();
      for (final ChildLocale index in indices) {
        debugChildren.add(_keepAliveBucket[index]!.toDiagnosticsNode(
          name: 'child with index [${index.row}, ${index.column}] (kept alive but not laid out)',
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
  @protected
  final Map<ChildLocale, RenderBox> _children = <ChildLocale, RenderBox>{};

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
      needsMetricsUpdate = true;
    }
  }

  @protected
  bool needsChildRebuild = true;

  @protected
  bool needsDelegateRebuild = true;

  @protected
  bool needsMetricsUpdate = true;

  @override
  void markNeedsLayout({bool withChildRebuild = false, bool withDelegateRebuild = false}) {
    needsChildRebuild = needsChildRebuild || withChildRebuild;
    needsDelegateRebuild = needsDelegateRebuild || withDelegateRebuild;
    super.markNeedsLayout();
  }

  ///
  void startLayout() {
    _childManager._startLayout();
  }

  @override
  void performLayout();

  ///
  RenderBox createOrObtainChildFor(ChildLocale locale) {
    if (needsChildRebuild || !_children.containsKey(locale)) {
      invokeLayoutCallback<BoxConstraints>((BoxConstraints _) {
        _childManager._buildChild(locale);
      });
    } else {
      _childManager._reuseChild(locale);
    }

    assert(_children.containsKey(locale));
    return _children[locale]!;
  }

  ///
  RenderBox? getChildFor(ChildLocale locale) {
    if (_children.containsKey(locale)) {
      return _children[locale]!;
    }
    return null;
  }



  ///
  void endLayout() {
    // TODO(Piinks): Collect keep alives.
    // And wrap these up in a debug method.
    assert(_debugOrphans?.isEmpty ?? true);
    assert(needsChildRebuild == false);
    assert(needsDelegateRebuild == false);
    assert(needsMetricsUpdate == false);
    invokeLayoutCallback<BoxConstraints>((BoxConstraints _) {
      _childManager._endLayout();
    });
  }

  // ---- Called from _TwoDimensionalViewportElement ----
  ///
  void _insertChild(RenderBox child, ChildLocale slot) {
    if (slot.row == 0 && slot.column == 0) {
    }
    assert(_debugTrackOrphans(newOrphan: _children[slot]));
    _children[slot] = child;
    adoptChild(child);
  }

  ///
  void _moveChild(RenderBox child, {required ChildLocale from, required ChildLocale to}) {
    if (_children[from] == child) {
      _children.remove(from);
    }
    assert(_debugTrackOrphans(newOrphan: _children[to], noLongerOrphan: child));
    _children[to] = child;
  }

  ///
  void _removeChild(RenderBox child, ChildLocale slot) {
    if (slot.row == 0 && slot.column == 0) {
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
  RevealedOffset getOffsetToReveal(RenderObject target, double alignment, {Rect? rect}) {
    // TODO(Piinks): implement getOffsetToReveal, what does RevealedOffset look like in 2D?
    throw UnimplementedError();
  }
}


abstract class TwoDimensionalChildManager {
  void _startLayout();
  void _buildChild(ChildLocale index);
  void _reuseChild(ChildLocale index);
  void _endLayout();
}

/// The relative positioning of children in a [TwoDimensionalViewport].
@immutable
class ChildLocale implements Comparable<ChildLocale> {
  /// Creates an reference to a child in a two dimensional plane, with the [row]
  /// and [column] being relative to other children in the viewport.
  const ChildLocale({required this.row, required this.column});

  /// Represents an unassigned child position. The given child may be in the
  /// process of moving from one position to another.
  static const ChildLocale invalid = ChildLocale(row: -1, column: -1);

  /// The index of the child in the horizontal axis, relative to neighboring
  /// children.
  ///
  /// While children's offset and positioning may not be strictly defined in
  /// terms of rows and columns, like a table, [ChildLocale.row] and
  /// [ChildLocale.column] can represent order of traversal in row or column
  /// major format.
  final int row;

  /// The index of the child in the vertical axis, relative to neighboring
  /// children.
  ///
  /// While children's offset and positioning may not be strictly defined in
  /// terms of rows and columns, like a table, [ChildLocale.row] and
  /// [ChildLocale.column] can represent order of traversal in row or column
  /// major format.
  final int column;

  @override
  bool operator ==(Object other) {
    return other is ChildLocale
        && other.row == row
        && other.column == column;
  }

  @override
  int get hashCode => Object.hash(row, column);

  @override
  int compareTo(ChildLocale other) {
    if (row == other.row) {
      return column - other.column;
    }
    return row - other.row;
  }

  @override
  String toString() {
    return '(column: $column, row: $row)';
  }
}
