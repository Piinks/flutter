// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../widgets/context_aware_preferred_size_test.dart';

void main() {
  testWidgets('TabBar respects ContextAwarePreferredSizeWidget tabs', (WidgetTester tester) async {
    // Initial: Portrait -> 80 height (from logic in ContextAwarePreferredSizeWidget)
    tester.view.physicalSize = const Size(400, 600);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(MaterialApp(
      home: DefaultTabController(
        length: 1,
        child: Scaffold(
          appBar: AppBar(
            bottom: const TabBar(
              tabs: <Widget>[
                ContextAwarePreferredSizeWidget(),
              ],
            ),
          ),
        ),
      ),
    ));

    // Verify TabBar height accommodates the tab
    // TabBar height = max(tabHeight) + indicatorWeight (2.0)
    final Finder appBar = find.byType(AppBar);
    final double portraitHeight = tester.getSize(appBar).height;
    // AppBar height = kToolbarHeight (56.0) + TabBar preferredHeight (82.0)
    if (portraitHeight != 138.0) {
       fail('AppBar Portrait Height mismatch: expected 138.0 (56+82), got $portraitHeight. (TabBar was 2.0?)');
    }

    // Change to Landscape -> 40 height
    tester.view.physicalSize = const Size(600, 400);
    await tester.pump();

    final double landscapeHeight = tester.getSize(appBar).height;
    // AppBar height = kToolbarHeight (56.0) + TabBar preferredHeight (50.0 + 2.0 = 52.0)
    if (landscapeHeight != 108.0) {
       fail('AppBar Landscape Height mismatch: expected 108.0 (56+52), got $landscapeHeight');
    }
  });
}
