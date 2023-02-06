// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/foundation.dart';

import 'box.dart';
import 'object.dart';
import 'sliver_multi_box_adaptor.dart';
import 'viewport.dart';
import 'viewport_offset.dart';

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

///
class TwoDimensionalViewportParentData extends BoxParentData with KeepAliveParentDataMixin {

  RenderBox? nextSibling;

  RenderBox? previousSibling;

  ChildIndex index = ChildIndex.invalid;

  @override
  bool get keptAlive => _keptAlive;
  bool _keptAlive = false;

  @override
  String toString() => 'index=$index; ${keepAlive == true ? "keepAlive; " : ""}${super.toString()}';
}

///
abstract class RenderTwoDimensionalViewport extends RenderBox implements RenderAbstractViewport {
  ///
  RenderTwoDimensionalViewport({
    required ViewportOffset horizontalOffset,
    required ViewportOffset verticalOffset,
    required RawTwoDimensionalDelegate delegate,
    required this.childManager,
    // TODO
    required this.mainAxis,
    this.cacheExtent,
    this.clipBehavior = Clip.hardEdge,
  }) : _horizontalOffset = horizontalOffset,
       _verticalOffset = verticalOffset,
       _delegate = delegate {
    assert(() {
      _debugDanglingKeepAlives = <RenderBox>[];
      return true;
    }());
  }

  // TODO(Piinks): Add getters and setters
  Axis mainAxis;
  double? cacheExtent;
  Clip clipBehavior = Clip.hardEdge;

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

  RawTwoDimensionalDelegate get delegate => _delegate;
  RawTwoDimensionalDelegate _delegate;
  set delegate(RawTwoDimensionalDelegate value) {
    if (_delegate == value) {
      return;
    }
    if (attached) {
      _delegate.removeListener(_handleDelegateNotification);
    }
    final RawTwoDimensionalDelegate oldDelegate = value;
    _delegate = value;
    if (attached) {
      _delegate.addListener(_handleDelegateNotification);
    }
    if (_delegate.runtimeType != oldDelegate.runtimeType || _delegate.shouldRebuild(oldDelegate)) {
      _handleDelegateNotification();
    }
  }

  final TwoDimensionalChildManager childManager;

  /// The nodes being kept alive despite not being visible.
  final Map<ChildIndex, RenderBox> _keepAliveBucket = <ChildIndex, RenderBox>{};

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
    for (final RenderBox child in children.values) {
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
    for (final ChildIndex cellIndex in children.keys) {
      children[cellIndex]!.detach();
    }
    for (final RenderBox child in _keepAliveBucket.values) {
      child.detach();
    }
  }

  @override
  void redepthChildren() {
    for (final RenderBox child in children.values) {
      child.redepthChildren();
    }
    _keepAliveBucket.values.forEach(redepthChild);
  }

  @override
  void visitChildren(RenderObjectVisitor visitor) {
    children.values.forEach(visitor);
    _keepAliveBucket.values.forEach(visitor);
  }

  @override
  void visitChildrenForSemantics(RenderObjectVisitor visitor) {
    children.values.forEach(visitor);
    // Do not visit children in [_keepAliveBucket].
  }

  @override
  List<DiagnosticsNode> debugDescribeChildren() {
    final List<DiagnosticsNode> debugChildren = <DiagnosticsNode>[
      ...children.keys.map<DiagnosticsNode>((ChildIndex index) {
        return children[index]!.toDiagnosticsNode(name: index.toString());
      })
    ];
    if (_keepAliveBucket.isNotEmpty) {
      final List<ChildIndex> indices = _keepAliveBucket.keys.toList()..sort();
      for (final ChildIndex index in indices) {
        debugChildren.add(_keepAliveBucket[index]!.toDiagnosticsNode(
          name: 'child with index [${index.x}, ${index.y}] (kept alive but not laid out)',
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
    for (final RenderBox child in children.values) {
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
  @protected
  final Map<ChildIndex, RenderBox> children = <ChildIndex, RenderBox>{};

  @override
  void performResize() {
    final Size? oldSize = hasSize ? size : null;
    super.performResize();
    // Ignoring return value since we are doing a layout either way
    // (performLayout will be invoked next).
    horizontalOffset.applyViewportDimension(size.width);
    verticalOffset.applyViewportDimension(size.height);
    // TODO(Piinks): what did this break?
    if (oldSize != size) {
      // Specs can depend on viewport size.
      needsMetricsUpdate = true;
    }
  }

  @override
  @mustCallSuper
  void performLayout() {
    // TODO(Piinks): Document this should be called at the end of subclass.performLayout
    // And wrap these up in a debug method.
    assert(_debugOrphans?.isEmpty ?? true);
    assert(needsChildRebuild == false);
    assert(needsDelegateRebuild == false);
    assert(needsMetricsUpdate == false);
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
    // TODO(Piinks): set _needsDimensionUpdate if we depend on size of children (e.g. after implementing prototype-based sizing).
    super.markNeedsLayout();
  }

  // ---- Called from _TwoDimensionalViewportElement ----
  ///
  void insertChild(RenderBox child, ChildIndex slot) {
    if (slot.x == 0 && slot.y == 0) {
      print('insertChild $slot');
    }
    assert(_debugTrackOrphans(newOrphan: children[slot]));
    children[slot] = child;
    adoptChild(child);
  }

  ///
  void moveChild(RenderBox child, {required ChildIndex from, required ChildIndex to}) {
    print('moveChild');
    if (children[from] == child) {
      children.remove(from);
    }
    assert(_debugTrackOrphans(newOrphan: children[to], noLongerOrphan: child));
    children[to] = child;
  }

  ///
  void removeChild(RenderBox child, ChildIndex slot) {
    if (slot.x == 0 && slot.y == 0) {
      print('removeChild: $slot');
    }
    if (children[slot] == child) {
      children.remove(slot);
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
    // TODO(Piinks): implement getOffsetToReveal
    throw UnimplementedError();
  }
}

///
abstract class RawTwoDimensionalDelegate extends ChangeNotifier {
  ///
  RawTwoDimensionalDelegate();

  ///
  bool shouldRebuild(RawTwoDimensionalDelegate oldDelegate);
}

abstract class TwoDimensionalChildManager {
  // Should the children object be encapsulated here?
  // final Map<ChildIndex, RenderBox> children = <ChildIndex, RenderBox>{};

  void startLayout();
  void buildChild(ChildIndex index);
  void reuseChild(ChildIndex index);
  void endLayout();
}

///
@immutable
class ChildIndex implements Comparable<ChildIndex> {
  ///
  const ChildIndex({required this.x, required this.y});

  static const ChildIndex invalid = ChildIndex(x: -1, y: -1);

  // Child represented like row/col
  final int x;
  final int y;

  // TODO(Piinks): Include offset? Could allow scroll-to-index
  // Or put in parent data?

  @override
  bool operator ==(Object other) {
    return other is ChildIndex
        && other.x == x
        && other.y == y;
  }

  @override
  int get hashCode => Object.hash(x, y);

  @override
  int compareTo(ChildIndex other) {
    if (x == other.x) {
      return y - other.y;
    }
    return x - other.x;
  }

  @override
  String toString() {
    return '(y: $y, x: $x)';
  }
}
