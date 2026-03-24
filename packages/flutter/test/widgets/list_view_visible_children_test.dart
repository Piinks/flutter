// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('ListView onVisibleChildrenChanged reports correct visible children', (WidgetTester tester) async {
    final visibleChildrenLog = <VisibleChildData>[];

    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: ListView.builder(
          itemCount: 20,
          itemExtent: 100.0,
          onVisibleChildrenChanged: (Iterable<VisibleChildData> visibleChildren) {
            visibleChildrenLog.clear();
            visibleChildrenLog.addAll(visibleChildren);
          },
          itemBuilder: (BuildContext context, int index) {
            return Container(
              height: 100.0,
              color: index.isEven ? const Color(0xFF00FF00) : const Color(0xFF0000FF),
              child: Text('Item $index'),
            );
          },
        ),
      ),
    );

    // Initial layout (assuming 800x600 screen)
    // Viewport height is 600.
    // Items are 100 height.
    // 0, 1, 2, 3, 4, 5 should be fully visible.
    // 6 might be partially visible if screen height is not exact multiple?
    // Default test surface size is 800x600.

    expect(visibleChildrenLog.length, 6);
    expect(visibleChildrenLog[0].index, 0);
    expect(visibleChildrenLog[0].visibleExtent, 100.0);
    expect(visibleChildrenLog[0].viewportOffset, 0.0);

    expect(visibleChildrenLog[5].index, 5);
    expect(visibleChildrenLog[5].visibleExtent, 100.0);
    expect(visibleChildrenLog[5].viewportOffset, 500.0);

    // Scroll down by 50 pixels
    await tester.drag(find.byType(ListView), const Offset(0.0, -50.0));
    await tester.pump();

    // Now:
    // Item 0: scrolled up by 50. visibleExtent = 50. viewportOffset = -50.
    // Item 1: viewportOffset = 50.
    // ...
    // Item 5: viewportOffset = 450.
    // Item 6: visibleExtent = 50. viewportOffset = 550.

    expect(visibleChildrenLog.length, 7); // 0, 1, 2, 3, 4, 5, 6

    // Check Item 0
    expect(visibleChildrenLog[0].index, 0);
    expect(visibleChildrenLog[0].visibleExtent, 50.0);
    expect(visibleChildrenLog[0].viewportOffset, -50.0);
    expect(visibleChildrenLog[0].visibleFraction, 0.5);

    // Check Item 6
    expect(visibleChildrenLog[6].index, 6);
    expect(visibleChildrenLog[6].visibleExtent, 50.0);
    expect(visibleChildrenLog[6].viewportOffset, 550.0);
    expect(visibleChildrenLog[6].visibleFraction, 0.5);

    // Scroll down another 50 pixels (total 100)
    await tester.drag(find.byType(ListView), const Offset(0.0, -50.0));
    await tester.pump();

    // Now Item 0 should be gone (or just barely gone depending on float precision, but strict inequality usually)
    // Item 1 becomes first.

    expect(visibleChildrenLog[0].index, 1);
    expect(visibleChildrenLog[0].viewportOffset, 0.0);
  });

  testWidgets('ListView onVisibleChildrenChanged works with varying item sizes', (WidgetTester tester) async {
    final visibleChildrenLog = <VisibleChildData>[];

    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: ListView.builder(
          itemCount: 20,
          onVisibleChildrenChanged: (Iterable<VisibleChildData> visibleChildren) {
            visibleChildrenLog.clear();
            visibleChildrenLog.addAll(visibleChildren);
          },
          itemBuilder: (BuildContext context, int index) {
            // Even items are 100, odd items are 200.
            return SizedBox(
              height: index.isEven ? 100.0 : 200.0,
              child: Text('Item $index'),
            );
          },
        ),
      ),
    );

    // Item 0: 100h (0-100)
    // Item 1: 200h (100-300)
    // Item 2: 100h (300-400)
    // Item 3: 200h (400-600)
    // Item 4: 100h (600-700) -> partially visible?
    // Screen height 600.
    // Visible: 0, 1, 2, 3. Item 4 starts at 600, so it might be excluded if strictly < 600?
    // Let's check.

    expect(visibleChildrenLog.map((d) => d.index).toList(), containsAllInOrder([0, 1, 2, 3]));

    // Check sizes
    expect(visibleChildrenLog[0].totalExtent, 100.0);
    expect(visibleChildrenLog[1].totalExtent, 200.0);
    expect(visibleChildrenLog[2].totalExtent, 100.0);
    expect(visibleChildrenLog[3].totalExtent, 200.0);
  });
}
