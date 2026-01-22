// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// Test implementation of a context-aware preferred size widget
class ContextAwarePreferredSizeWidget extends StatelessWidget implements PreferredSizeWidget {
  const ContextAwarePreferredSizeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(color: Colors.red);
  }

  @override
  Size get preferredSize {
    // Return a ContextAwareSize that uses MediaQuery
    return ContextAwareSize((BuildContext context) {
      if (MediaQuery.orientationOf(context) == Orientation.landscape) {
        return const Size.fromHeight(50);
      }
      return const Size.fromHeight(80);
    });
  }
}

void main() {
  testWidgets('ContextAwareSize resolves correctly with context', (WidgetTester tester) async {
    // 1. Test direct resolution
    const Size baseSize = Size.square(10);
    await tester.pumpWidget(const SizedBox());
    final BuildContext context = tester.element(find.byType(SizedBox));
    
    final Size resolvedBase = baseSize.resolve(context); 
    expect(resolvedBase, baseSize);

    // Test ContextAwareSize
    final ContextAwareSize awareSize = ContextAwareSize((BuildContext c) => const Size(20, 20));
    expect(awareSize.resolve(context), const Size(20, 20));
  });

  testWidgets('Scaffold respects ContextAwarePreferredSizeWidget derived size', (WidgetTester tester) async {
    // Initial: Portrait -> 80 height
    tester.view.physicalSize = const Size(400, 600);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(const MaterialApp(
      home: Scaffold(
        appBar: ContextAwarePreferredSizeWidget(),
        body: Center(child: Text('Body')),
      ),
    ));

    // Verify AppBar height is 80
    final Finder appBar = find.byType(ContextAwarePreferredSizeWidget);
    expect(tester.getSize(appBar).height, 80.0);

    // Change to Landscape -> 50 height
    tester.view.physicalSize = const Size(600, 400);
    await tester.pump();

    expect(tester.getSize(appBar).height, 50.0);
  });
}
