// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:math' as math;

import 'package:flutter/animation.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'scroll_metrics.dart';

const double _kMinThumbExtent = 18.0;
const double _kMinInteractiveSize = 48.0;

/// A [CustomPainter] for painting scrollbars.
///
/// The size of the scrollbar along its scroll direction is typically
/// proportional to the percentage of content completely visible on screen,
/// as long as its size isn't less than [minLength] and it isn't overscrolling.
///
/// Unlike [CustomPainter]s that subclasses [CustomPainter] and only repaint
/// when [shouldRepaint] returns true (which requires this [CustomPainter] to
/// be rebuilt), this painter has the added optimization of repainting and not
/// rebuilding when:
///
///  * the scroll position changes; and
///  * when the scrollbar fades away.
///
/// Calling [update] with the new [ScrollMetrics] will repaint the new scrollbar
/// position.
///
/// Updating the value on the provided [fadeoutOpacityAnimation] will repaint
/// with the new opacity.
///
/// You must call [dispose] on this [ScrollbarPainter] when it's no longer used.
///
/// See also:
///
///  * [Scrollbar] for a widget showing a scrollbar around a [Scrollable] in the
///    Material Design style.
///  * [CupertinoScrollbar] for a widget showing a scrollbar around a
///    [Scrollable] in the iOS style.
class ScrollbarPainter extends ChangeNotifier implements CustomPainter {
  /// Creates a scrollbar with customizations given by construction arguments.
  ScrollbarPainter({
    required Color color,
    Color trackColor = const Color(0x00000000),
    Color trackBorderColor = const Color(0x00000000),
    required TextDirection textDirection,
    required this.thickness,
    required this.fadeoutOpacityAnimation,
    EdgeInsets padding = EdgeInsets.zero,
    this.mainAxisMargin = 0.0,
    this.crossAxisMargin = 0.0,
    this.radius,
    this.minLength = _kMinThumbExtent,
    this.showTrack = false,
    double? minOverscrollLength,
  }) : assert(color != null),
       assert(trackColor != null),
       assert(trackBorderColor != null),
       assert(textDirection != null),
       assert(thickness != null),
       assert(fadeoutOpacityAnimation != null),
       assert(mainAxisMargin != null),
       assert(crossAxisMargin != null),
       assert(minLength != null),
       assert(minLength >= 0),
       assert(minOverscrollLength == null || minOverscrollLength <= minLength),
       assert(minOverscrollLength == null || minOverscrollLength >= 0),
       assert(padding != null),
       assert(padding.isNonNegative),
       assert(showTrack != null),
       _color = color,
       _trackColor = trackColor,
       _trackBorderColor = trackBorderColor,
       _textDirection = textDirection,
       _padding = padding,
       minOverscrollLength = minOverscrollLength ?? minLength {
    fadeoutOpacityAnimation.addListener(notifyListeners);
  }

  /// [Color] of the thumb. Mustn't be null.
  Color get color => _color;
  Color _color;
  set color(Color value) {
    assert(value != null);
    if (color == value)
      return;

    _color = value;
    notifyListeners();
  }

  /// Whether or not the track should be painted as part of the scrollbar.
  final bool showTrack;

  /// [Color] of the track. Mustn't be null.
  Color get trackColor => _trackColor;
  Color _trackColor;
  set trackColor(Color value) {
    assert(value != null);
    if (trackColor == value)
      return;

    _trackColor = value;
    notifyListeners();
  }

  /// [Color] of the track border. Mustn't be null.
  Color get trackBorderColor => _trackBorderColor;
  Color _trackBorderColor;
  set trackBorderColor(Color value) {
    assert(value != null);
    if (trackBorderColor == value)
      return;

    _trackBorderColor = value;
    notifyListeners();
  }

  /// [TextDirection] of the [BuildContext] which dictates the side of the
  /// screen the scrollbar appears in (the trailing side). Mustn't be null.
  TextDirection get textDirection => _textDirection;
  TextDirection _textDirection;
  set textDirection(TextDirection value) {
    assert(value != null);
    if (textDirection == value)
      return;

    _textDirection = value;
    notifyListeners();
  }

  /// Thickness of the scrollbar in its cross-axis in logical pixels. Mustn't be null.
  double thickness;

  /// An opacity [Animation] that dictates the opacity of the thumb.
  /// Changes in value of this [Listenable] will automatically trigger repaints.
  /// Mustn't be null.
  final Animation<double> fadeoutOpacityAnimation;

  /// Distance from the scrollbar's start and end to the edge of the viewport
  /// in logical pixels. It affects the amount of available paint area.
  ///
  /// Mustn't be null and defaults to 0.
  final double mainAxisMargin;

  /// Distance from the scrollbar's side to the nearest edge in logical pixels.
  ///
  /// Must not be null and defaults to 0.
  final double crossAxisMargin;

  /// [Radius] of corners if the scrollbar should have rounded corners.
  ///
  /// Scrollbar will be rectangular if [radius] is null.
  Radius? radius;

  /// The amount of space by which to inset the scrollbar's start and end, as
  /// well as its side to the nearest edge, in logical pixels.
  ///
  /// This is typically set to the current [MediaQueryData.padding] to avoid
  /// partial obstructions such as display notches. If you only want additional
  /// margins around the scrollbar, see [mainAxisMargin].
  ///
  /// Defaults to [EdgeInsets.zero]. Must not be null and offsets from all four
  /// directions must be greater than or equal to zero.
  EdgeInsets get padding => _padding;
  EdgeInsets _padding;
  set padding(EdgeInsets value) {
    assert(value != null);
    if (padding == value)
      return;

    _padding = value;
    notifyListeners();
  }


  /// The preferred smallest size the scrollbar can shrink to when the total
  /// scrollable extent is large, the current visible viewport is small, and the
  /// viewport is not overscrolled.
  ///
  /// The size of the scrollbar may shrink to a smaller size than [minLength] to
  /// fit in the available paint area. E.g., when [minLength] is
  /// `double.infinity`, it will not be respected if
  /// [ScrollMetrics.viewportDimension] and [mainAxisMargin] are finite.
  ///
  /// Mustn't be null and the value has to be within the range of 0 to
  /// [minOverscrollLength], inclusive. Defaults to 18.0.
  final double minLength;

  /// The preferred smallest size the scrollbar can shrink to when viewport is
  /// overscrolled.
  ///
  /// When overscrolling, the size of the scrollbar may shrink to a smaller size
  /// than [minOverscrollLength] to fit in the available paint area. E.g., when
  /// [minOverscrollLength] is `double.infinity`, it will not be respected if
  /// the [ScrollMetrics.viewportDimension] and [mainAxisMargin] are finite.
  ///
  /// The value is less than or equal to [minLength] and greater than or equal to 0.
  /// If unspecified or set to null, it will defaults to the value of [minLength].
  final double minOverscrollLength;

  ScrollMetrics? _lastMetrics;
  AxisDirection? _lastAxisDirection;
  Rect? _thumbRect;

  /// Update with new [ScrollMetrics]. The scrollbar will show and redraw itself
  /// based on these new metrics.
  ///
  /// The scrollbar will remain on screen.
  void update(
    ScrollMetrics metrics,
    AxisDirection axisDirection,
  ) {
    _lastMetrics = metrics;
    _lastAxisDirection = axisDirection;
    notifyListeners();
  }

  /// Update and redraw with new scrollbar thickness and radius.
  void updateThickness(double nextThickness, Radius nextRadius) {
    thickness = nextThickness;
    radius = nextRadius;
    notifyListeners();
  }

  Paint get _thumbPaint {
    return Paint()
      ..color = color.withOpacity(color.opacity * fadeoutOpacityAnimation.value);
  }

  Paint _trackPaint({ bool isBorder = false }) {
    if (isBorder)
      return Paint()
        ..color = _trackBorderColor.withOpacity(trackBorderColor.opacity * fadeoutOpacityAnimation.value)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.0;
    return Paint()
      ..color = _trackColor.withOpacity(trackColor.opacity * fadeoutOpacityAnimation.value);
  }

  void _paintScrollbar(Canvas canvas, Size size, double thumbOffset, double thumbExtent, AxisDirection direction) {
    final double x, y;
    final Size thumbSize, trackSize;
    final Offset trackOffset;

    switch (direction) {
      case AxisDirection.down:
        thumbSize = Size(thickness, thumbExtent);
        trackSize = Size(thickness, _trackExtent);
        x = textDirection == TextDirection.rtl
          ? crossAxisMargin + padding.left
          : size.width - thickness - crossAxisMargin - padding.right;
        y = thumbOffset;
        trackOffset = Offset(x, 0.0);
        break;
      case AxisDirection.up:
        thumbSize = Size(thickness, thumbExtent);
        trackSize = Size(thickness, _trackExtent);
        x = textDirection == TextDirection.rtl
          ? crossAxisMargin + padding.left
          : size.width - thickness - crossAxisMargin - padding.right;
        y = thumbOffset;
        trackOffset = Offset(x, 0.0);
        break;
      case AxisDirection.left:
        thumbSize = Size(thumbExtent, thickness);
        trackSize = Size(_trackExtent, thickness);
        x = thumbOffset;
        y = size.height - thickness - crossAxisMargin - padding.bottom;
        trackOffset = Offset(0.0, y);
        break;
      case AxisDirection.right:
        thumbSize = Size(thumbExtent, thickness);
        trackSize = Size(_trackExtent, thickness);
        x = thumbOffset;
        y = size.height - thickness - crossAxisMargin - padding.bottom;
        trackOffset = Offset(0.0, y);
        break;
    }
    print('showTrack: $showTrack');
    if (showTrack) {
      print('Going to paint track');
      print('track at: ${trackOffset & trackSize}');
      canvas.drawRect(trackOffset & trackSize, _trackPaint());
      print('border from : $trackOffset to ${Offset(trackOffset.dx, trackOffset.dy + _trackExtent)}');
      canvas.drawLine(
        trackOffset,
        Offset(trackOffset.dx, trackOffset.dy + _trackExtent),
        _trackPaint(isBorder: true),
      );
    }
    print('Going to paint thumb');
    _thumbRect = Offset(x, y) & thumbSize;
    print('thumb at: $_thumbRect');
    if (radius == null)
      canvas.drawRect(_thumbRect!, _thumbPaint);
    else
      canvas.drawRRect(RRect.fromRectAndRadius(_thumbRect!, radius!), _thumbPaint);
  }

  double _thumbExtent() {
    // Thumb extent reflects fraction of content visible, as long as this
    // isn't less than the absolute minimum size.
    // _totalContentExtent >= viewportDimension, so (_totalContentExtent - _mainAxisPadding) > 0
    final double fractionVisible = ((_lastMetrics!.extentInside - _mainAxisPadding) / (_totalContentExtent - _mainAxisPadding))
      .clamp(0.0, 1.0);

    final double thumbExtent = math.max(
      math.min(_trackExtent, minOverscrollLength),
      _trackExtent * fractionVisible,
    );

    final double fractionOverscrolled = 1.0 - _lastMetrics!.extentInside / _lastMetrics!.viewportDimension;
    final double safeMinLength = math.min(minLength, _trackExtent);
    final double newMinLength = (_beforeExtent > 0 && _afterExtent > 0)
      // Thumb extent is no smaller than minLength if scrolling normally.
      ? safeMinLength
      // User is overscrolling. Thumb extent can be less than minLength
      // but no smaller than minOverscrollLength. We can't use the
      // fractionVisible to produce intermediate values between minLength and
      // minOverscrollLength when the user is transitioning from regular
      // scrolling to overscrolling, so we instead use the percentage of the
      // content that is still in the viewport to determine the size of the
      // thumb. iOS behavior appears to have the thumb reach its minimum size
      // with ~20% of overscroll. We map the percentage of minLength from
      // [0.8, 1.0] to [0.0, 1.0], so 0% to 20% of overscroll will produce
      // values for the thumb that range between minLength and the smallest
      // possible value, minOverscrollLength.
      : safeMinLength * (1.0 - fractionOverscrolled.clamp(0.0, 0.2) / 0.2);

    // The `thumbExtent` should be no greater than `trackSize`, otherwise
    // the scrollbar may scroll towards the wrong direction.
    return thumbExtent.clamp(newMinLength, _trackExtent);
  }

  @override
  void dispose() {
    fadeoutOpacityAnimation.removeListener(notifyListeners);
    super.dispose();
  }

  bool get _isVertical => _lastAxisDirection == AxisDirection.down || _lastAxisDirection == AxisDirection.up;
  bool get _isReversed => _lastAxisDirection == AxisDirection.up || _lastAxisDirection == AxisDirection.left;
  // The amount of scroll distance before and after the current position.
  double get _beforeExtent => _isReversed ? _lastMetrics!.extentAfter : _lastMetrics!.extentBefore;
  double get _afterExtent => _isReversed ? _lastMetrics!.extentBefore : _lastMetrics!.extentAfter;
  // Padding of the thumb track.
  double get _mainAxisPadding => _isVertical ? padding.vertical : padding.horizontal;
  // The size of the thumb track.
  double get _trackExtent => _lastMetrics!.viewportDimension - 2 * mainAxisMargin - _mainAxisPadding;

  // The total size of the scrollable content.
  double get _totalContentExtent {
    return _lastMetrics!.maxScrollExtent
      - _lastMetrics!.minScrollExtent
      + _lastMetrics!.viewportDimension;
  }

  /// Convert between a thumb track position and the corresponding scroll
  /// position.
  ///
  /// thumbOffsetLocal is a position in the thumb track. Cannot be null.
  double getTrackToScroll(double thumbOffsetLocal) {
    assert(thumbOffsetLocal != null);
    final double scrollableExtent = _lastMetrics!.maxScrollExtent - _lastMetrics!.minScrollExtent;
    final double thumbMovableExtent = _trackExtent - _thumbExtent();

    return scrollableExtent * thumbOffsetLocal / thumbMovableExtent;
  }

  // Converts between a scroll position and the corresponding position in the
  // thumb track.
  double _getScrollToTrack(ScrollMetrics metrics, double thumbExtent) {
    final double scrollableExtent = metrics.maxScrollExtent - metrics.minScrollExtent;

    final double fractionPast = (scrollableExtent > 0)
      ? ((metrics.pixels - metrics.minScrollExtent) / scrollableExtent).clamp(0.0, 1.0)
      : 0;

    return (_isReversed ? 1 - fractionPast : fractionPast) * (_trackExtent - thumbExtent);
  }

  @override
  void paint(Canvas canvas, Size size) {
    if (_lastAxisDirection == null
        || _lastMetrics == null
        || fadeoutOpacityAnimation.value == 0.0)
      return;

    // Skip painting if there's not enough space.
    if (_lastMetrics!.viewportDimension <= _mainAxisPadding || _trackExtent <= 0) {
      return;
    }

    final double beforePadding = _isVertical ? padding.top : padding.left;
    final double thumbExtent = _thumbExtent();
    final double thumbOffsetLocal = _getScrollToTrack(_lastMetrics!, thumbExtent);
    final double thumbOffset = thumbOffsetLocal + mainAxisMargin + beforePadding;

    return _paintScrollbar(canvas, size, thumbOffset, thumbExtent, _lastAxisDirection!);
  }

  /// Same as hitTest, but includes some padding to make sure that the region
  /// isn't too small to be interacted with by the user.
  bool hitTestInteractive(Offset position) {
    if (_thumbRect == null) {
      return false;
    }
    // The thumb is not able to be hit when transparent.
    if (fadeoutOpacityAnimation.value == 0.0) {
      return false;
    }
    final Rect interactiveThumbRect = _thumbRect!.expandToInclude(
      Rect.fromCircle(center: _thumbRect!.center, radius: _kMinInteractiveSize / 2),
    );
    return interactiveThumbRect.contains(position);
  }

  // Scrollbars can be interactive in Cupertino.
  @override
  bool? hitTest(Offset? position) {
    if (_thumbRect == null) {
      return null;
    }
    // The thumb is not able to be hit when transparent.
    if (fadeoutOpacityAnimation.value == 0.0) {
      return false;
    }
    return _thumbRect!.contains(position!);
  }

  @override
  bool shouldRepaint(ScrollbarPainter old) {
    // Should repaint if any properties changed.
    return color != old.color
        || textDirection != old.textDirection
        || thickness != old.thickness
        || fadeoutOpacityAnimation != old.fadeoutOpacityAnimation
        || mainAxisMargin != old.mainAxisMargin
        || crossAxisMargin != old.crossAxisMargin
        || radius != old.radius
        || minLength != old.minLength
        || padding != old.padding;
  }

  @override
  bool shouldRebuildSemantics(CustomPainter oldDelegate) => false;

  @override
  SemanticsBuilderCallback? get semanticsBuilder => null;
}
