// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('AnimatedList onVisibleChildrenChanged reports visible children', (WidgetTester tester) async {
    final visibleChildren = <VisibleChildData>[];

    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: AnimatedList(
          initialItemCount: 20,
          itemBuilder: (BuildContext context, int index, Animation<double> animation) {
            return SizedBox(
              key: ValueKey<int>(index),
              height: 100.0,
              child: Text('Item $index'),
            );
          },
          onVisibleChildrenChanged: (Iterable<VisibleChildData> children) {
            visibleChildren.clear();
            visibleChildren.addAll(children);
          },
        ),
      ),
    );

    // Initial state: 600px viewport, 100px items. 6 items visible.
    expect(visibleChildren.length, 6);
    expect(visibleChildren[0].index, 0);
    expect(visibleChildren[0].visibleFraction, 1.0);
    expect(visibleChildren[5].index, 5);
    expect(visibleChildren[5].visibleFraction, 1.0);

    // Scroll down by 50px.
    final ScrollableState scrollable = tester.state(find.byType(Scrollable));
    scrollable.position.jumpTo(50.0);
    await tester.pump();

    // Now 7 items are partially visible.
    // Item 0: 50/100 visible
    // Items 1-5: 100/100 visible
    // Item 6: 50/100 visible
    expect(visibleChildren.length, 7);
    expect(visibleChildren[0].index, 0);
    expect(visibleChildren[0].visibleFraction, 0.5);
    expect(visibleChildren[6].index, 6);
    expect(visibleChildren[6].visibleFraction, 0.5);
  });

  testWidgets('AnimatedGrid onVisibleChildrenChanged reports visible children', (WidgetTester tester) async {
    final visibleChildren = <VisibleChildData>[];

    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: AnimatedGrid(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisExtent: 100.0,
          ),
          initialItemCount: 20,
          itemBuilder: (BuildContext context, int index, Animation<double> animation) {
            return SizedBox(
              key: ValueKey<int>(index),
              child: Text('Item $index'),
            );
          },
          onVisibleChildrenChanged: (Iterable<VisibleChildData> children) {
            visibleChildren.clear();
            visibleChildren.addAll(children);
          },
        ),
      ),
    );

    // Initial state: 600px viewport, 100px rows. 6 rows visible (12 items).
    expect(visibleChildren.length, 12);
    expect(visibleChildren[0].index, 0);
    expect(visibleChildren[11].index, 11);

    // Scroll down by 50px.
    final ScrollableState scrollable = tester.state(find.byType(Scrollable));
    scrollable.position.jumpTo(50.0);
    await tester.pump();

    // Now 7 rows visible (14 items).
    expect(visibleChildren.length, 14);
    expect(visibleChildren[0].index, 0);
    expect(visibleChildren[0].visibleFraction, 0.5);
    expect(visibleChildren[13].index, 13);
    expect(visibleChildren[13].visibleFraction, 0.5);
  });

  testWidgets('SliverFillViewport onVisibleChildrenChanged reports visible children', (WidgetTester tester) async {
    final visibleChildren = <VisibleChildData>[];

    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: CustomScrollView(
          slivers: <Widget>[
            SliverFillViewport(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  return Center(child: Text('Page $index'));
                },
                childCount: 10,
              ),
              viewportFraction: 0.5,
              onVisibleChildrenChanged: (Iterable<VisibleChildData> children) {
                visibleChildren.clear();
                visibleChildren.addAll(children);
              },
            ),
          ],
        ),
      ),
    );

    // Viewport is 600px. Items are 300px each (0.5 fraction).
    // SliverFillViewport adds padding if padEnds is true (default).
    // With viewportFraction 0.5, padding is (1 - 0.5) / 2 = 0.25 on each side.
    // 600 * 0.25 = 150px padding.
    // Item 0 starts at 150px, ends at 450px.
    // Item 1 starts at 450px, ends at 750px (partially visible).
    
    // Actually SliverFillViewport centers the first item.
    expect(visibleChildren.length, 2);
    expect(visibleChildren[0].index, 0);
    expect(visibleChildren[1].index, 1);
  });
}
