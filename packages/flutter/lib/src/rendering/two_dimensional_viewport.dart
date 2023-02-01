// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/foundation.dart';

import 'box.dart';
import 'object.dart';
import 'viewport.dart';
import 'viewport_offset.dart';

///
abstract class RenderTwoDimensionalViewport extends RenderBox implements RenderAbstractViewport {
  ///
  RenderTwoDimensionalViewport({
    required ViewportOffset horizontalOffset,
    required ViewportOffset verticalOffset,
    required RawTwoDimensionalDelegate delegate,
    required this.childManager,
  }) : _horizontalOffset = horizontalOffset,
       _verticalOffset = verticalOffset,
       _delegate = delegate;

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
  }

  @override
  void detach() {
    super.detach();
    _horizontalOffset.removeListener(markNeedsLayout);
    _verticalOffset.removeListener(markNeedsLayout);
    _delegate.removeListener(_handleDelegateNotification);
    for (final ChildIndex cellIndex in _children.keys) {
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
  List<DiagnosticsNode> debugDescribeChildren() {
    return _children.keys.map<DiagnosticsNode>((ChildIndex index) {
      return _children[index]!.toDiagnosticsNode(name: index.toString());
    }).toList();
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

  final Map<ChildIndex, RenderBox> _children = <ChildIndex, RenderBox>{};

  @override
  void performResize() {
    // final Size? oldSize = hasSize ? size : null;
    super.performResize();
    // Ignoring return value since we are doing a layout either way
    // (performLayout will be invoked next).
    horizontalOffset.applyViewportDimension(size.width);
    verticalOffset.applyViewportDimension(size.height);
    // TODO(Piinks): what did this break?
    // if (oldSize != size) {
    //   // Specs can depend on viewport size.
    //   _needsExtentUpdate = true;
    // }
  }

  @override
  void performLayout();

  bool _needsChildRebuild = true;
  bool _needsDelegateRebuild = true;

  @override
  void markNeedsLayout({bool withChildRebuild = false, bool withDelegateRebuild = false}) {
    _needsChildRebuild = _needsChildRebuild || withChildRebuild;
    _needsDelegateRebuild = _needsDelegateRebuild || withDelegateRebuild;
    // TODO(Piinks): set _needsDimensionUpdate if we depend on size of children (e.g. after implementing prototype-based sizing).
    super.markNeedsLayout();
  }

  // ---- Called from _TwoDimensionalViewportElement ----
  ///
  void insertChild(RenderBox child, ChildIndex slot) {
    assert(_debugTrackOrphans(newOrphan: _children[slot]));
    _children[slot] = child;
    adoptChild(child);
  }

  ///
  void moveChild(RenderBox child, {required ChildIndex from, required ChildIndex to}) {
    if (_children[from] == child) {
      _children.remove(from);
    }
    assert(_debugTrackOrphans(newOrphan: _children[to], noLongerOrphan: child));
    _children[to] = child;
  }

  ///
  void removeChild(RenderBox child, ChildIndex slot) {
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
    // TODO(Piinks): implement getOffsetToReveal
    throw UnimplementedError();
  }
}

///
abstract class RawTwoDimensionalDelegate extends ChangeNotifier {
  // This class is intended to be used as an interface, and should not be
  // extended directly; this constructor prevents instantiation and extension.
  RawTwoDimensionalDelegate._();

  ///
  bool shouldRebuild(RawTwoDimensionalDelegate oldDelegate);
}

class TwoDimensionalViewportParentData extends BoxParentData {
  RenderBox? nextSibling;
  RenderBox? previousSibling;
  ChildIndex index = ChildIndex.invalid;
}

abstract class TwoDimensionalChildManager {
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

  final int x;
  final int y;

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
