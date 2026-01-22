// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

/// @docImport 'package:flutter/material.dart';
library;

import 'package:flutter/rendering.dart';

import 'basic.dart';
import 'framework.dart';

/// An interface for widgets that can return the size this widget would prefer
/// if it were otherwise unconstrained.
///
/// There are a few cases, notably [AppBar] and [TabBar], where it would be
/// undesirable for the widget to constrain its own size but where the widget
/// needs to expose a preferred or "default" size. For example a primary
/// [Scaffold] sets its app bar height to the app bar's preferred height
/// plus the height of the system status bar.
///
/// Widgets that need to know the preferred size of their child can require
/// that their child implement this interface by using this class rather
/// than [Widget] as the type of their `child` property.
///
/// Use [PreferredSize] to give a preferred size to an arbitrary widget.
abstract class PreferredSizeWidget implements Widget {
  /// The size this widget would prefer if it were otherwise unconstrained.
  ///
  /// In many cases it's only necessary to define one preferred dimension.
  /// For example the [Scaffold] only depends on its app bar's preferred
  /// height. In that case implementations of this method can just return
  /// `Size.fromHeight(myAppBarHeight)`.
  ///
  /// Implementations can return a [ContextAwareSize] if the preferred size
  /// depends on the [BuildContext] (e.g. [MediaQuery] or [Theme]).
  /// Consumers of this widget should use the [ContextAwareSizeResolution.resolve]
  /// extension method to resolve the size with a context.
  Size get preferredSize;
}

/// A widget with a preferred size.
///
/// This widget does not impose any constraints on its child, and it doesn't
/// affect the child's layout in any way. It just advertises a preferred size
/// which can be used by the parent.
///
/// Parents like [Scaffold] use [PreferredSizeWidget] to require that their
/// children implement that interface. To give a preferred size to an arbitrary
/// widget so that it can be used in a `child` property of that type, this
/// widget, [PreferredSize], can be used.
///
/// Widgets like [AppBar] implement a [PreferredSizeWidget], so that this
/// [PreferredSize] widget is not necessary for them.
///
/// {@tool dartpad}
/// This sample shows a custom widget, similar to an [AppBar], which uses a
/// [PreferredSize] widget, with its height set to 80 logical pixels.
/// Changing the [PreferredSize] can be used to change the height
/// of the custom app bar.
///
/// ** See code in examples/api/lib/widgets/preferred_size/preferred_size.0.dart **
/// {@end-tool}
///
/// See also:
///
///  * [AppBar.bottom] and [Scaffold.appBar], which require preferred size widgets.
///  * [PreferredSizeWidget], the interface which this widget implements to expose
///    its preferred size.
///  * [AppBar] and [TabBar], which implement PreferredSizeWidget.
class PreferredSize extends StatelessWidget implements PreferredSizeWidget {
  /// Creates a widget that has a preferred size that the parent can query.
  const PreferredSize({super.key, required this.preferredSize, required this.child});

  /// The widget below this widget in the tree.
  ///
  /// {@macro flutter.widgets.ProxyWidget.child}
  final Widget child;

  @override
  final Size preferredSize;

  @override
  Widget build(BuildContext context) => child;
}

/// A [Size] that can be resolved with a [BuildContext].
///
/// This custom [Size] subclass allows [PreferredSizeWidget]s to depend on the
/// [BuildContext] (and thus inherited widgets like [MediaQuery] or [Theme])
/// when their preferred size is queried.
///
/// While [PreferredSizeWidget.preferredSize] returns a [Size], widgets that
/// support context-aware sizing (like [Scaffold] or [AppBar]) will call
/// [resolve] on the returned size. If the size is a [ContextAwareSize], the
/// [resolver] callback is invoked with the context.
///
/// See also:
///
/// * [ContextAwareSizeResolution], an extension that adds the [resolve] method to [Size].
class ContextAwareSize extends Size {
  /// Creates a [Size] that is resolved using the provided [resolver] callback.
  ///
  /// The [width] and [height] are used as fallbacks if [resolve] is never
  /// called (e.g. by a parent widget that does not support context-aware sizing).
  /// They default to 0.0.
  const ContextAwareSize(this.resolver, [double width = 0.0, double height = 0.0]) : super(width, height);

  /// A callback that returns the actual [Size] given a [BuildContext].
  final Size Function(BuildContext context) resolver;

  @override
  String toString() => 'ContextAwareSize($resolver)';
}

/// Utility extension to resolve a [Size] with a [BuildContext].
extension ContextAwareSizeResolution on Size {
  /// Resolves this [Size] using the provided [context].
  ///
  /// If this [Size] is a [ContextAwareSize], its [ContextAwareSize.resolver]
  /// is called. Otherwise, returns `this`.
  Size resolve(BuildContext context) {
    if (this is ContextAwareSize) {
      return (this as ContextAwareSize).resolver(context);
    }
    return this;
  }
}
