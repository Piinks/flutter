// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'two_dimensional_utils.dart';

void main() {
  testWidgets(
    'TwoDimensionalScrollable scrolls with DiagonalDragBehavior.free and GestureDetector onPanStart in cells',
    (WidgetTester tester) async {
      final verticalController = ScrollController();
      addTearDown(verticalController.dispose);
      final horizontalController = ScrollController();
      addTearDown(horizontalController.dispose);
      var panStartCount = 0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SimpleBuilderTableView(
              diagonalDragBehavior: DiagonalDragBehavior.free,
              verticalDetails: ScrollableDetails.vertical(controller: verticalController),
              horizontalDetails: ScrollableDetails.horizontal(controller: horizontalController),
              delegate: TwoDimensionalChildBuilderDelegate(
                maxXIndex: 10,
                maxYIndex: 10,
                builder: (BuildContext context, ChildVicinity vicinity) {
                  return GestureDetector(
                    onPanStart: (_) => panStartCount++,
                    child: Container(
                      height: 200,
                      width: 200,
                      color: vicinity.xIndex.isEven == vicinity.yIndex.isEven
                          ? Colors.black12
                          : Colors.white,
                      child: Center(child: Text('${vicinity.xIndex},${vicinity.yIndex}')),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify initial state
      expect(verticalController.offset, 0.0);
      expect(horizontalController.offset, 0.0);

      // Try to drag diagonally (up-left to scroll down-right)
      final TestGesture gesture = await tester.startGesture(const Offset(150, 150));
      // Move more than the touch slop (18.0) but less than pan slop (36.0)
      await gesture.moveBy(const Offset(-20, -20));
      await tester.pump();
      // Move again to trigger onUpdate
      await gesture.moveBy(const Offset(-20, -20));
      await tester.pump();
      await gesture.up();
      await tester.pumpAndSettle();

      // In the failure case, the TableView does NOT scroll because the child GestureDetector
      // with onPanStart wins the arena.
      // If it's fixed, the TableView should scroll.
      expect(
        verticalController.offset,
        greaterThan(0.0),
        reason: 'Vertical scroll should have occurred',
      );
      expect(
        horizontalController.offset,
        greaterThan(0.0),
        reason: 'Horizontal scroll should have occurred',
      );
      expect(
        panStartCount,
        0,
        reason: 'Child GestureDetector should NOT have triggered onPanStart',
      );
    },
  );

  testWidgets(
    'TwoDimensionalScrollable scrolls with DiagonalDragBehavior.none and GestureDetector onPanStart in cells',
    (WidgetTester tester) async {
      final verticalController = ScrollController();
      addTearDown(verticalController.dispose);
      final horizontalController = ScrollController();
      addTearDown(horizontalController.dispose);
      var panStartCount = 0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SimpleBuilderTableView(
              verticalDetails: ScrollableDetails.vertical(controller: verticalController),
              horizontalDetails: ScrollableDetails.horizontal(controller: horizontalController),
              delegate: TwoDimensionalChildBuilderDelegate(
                maxXIndex: 10,
                maxYIndex: 10,
                builder: (BuildContext context, ChildVicinity vicinity) {
                  return GestureDetector(
                    onPanStart: (_) => panStartCount++,
                    child: Container(
                      height: 200,
                      width: 200,
                      color: vicinity.xIndex.isEven == vicinity.yIndex.isEven
                          ? Colors.black12
                          : Colors.white,
                      child: Center(child: Text('${vicinity.xIndex},${vicinity.yIndex}')),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Try to drag vertically
      final TestGesture gesture = await tester.startGesture(const Offset(150, 150));
      await gesture.moveBy(const Offset(0, -20));
      await tester.pump();
      await gesture.moveBy(const Offset(0, -20));
      await tester.pump();
      await gesture.up();
      await tester.pumpAndSettle();

      expect(
        verticalController.offset,
        greaterThan(0.0),
        reason: 'Vertical scroll should have occurred (none mode)',
      );
      expect(
        panStartCount,
        0,
        reason: 'Child GestureDetector should NOT have triggered onPanStart (none mode)',
      );
    },
  );

  testWidgets('TwoDimensionalScrollable allows child Tap gestures when not dragging', (
    WidgetTester tester,
  ) async {
    var tapCount = 0;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SimpleBuilderTableView(
            diagonalDragBehavior: DiagonalDragBehavior.free,
            delegate: TwoDimensionalChildBuilderDelegate(
              maxXIndex: 10,
              maxYIndex: 10,
              builder: (BuildContext context, ChildVicinity vicinity) {
                return GestureDetector(
                  onTap: () => tapCount++,
                  child: Container(
                    height: 200,
                    width: 200,
                    color: Colors.white,
                    child: Center(child: Text('${vicinity.xIndex},${vicinity.yIndex}')),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    await tester.tap(find.text('1,1'));
    await tester.pumpAndSettle();

    expect(tapCount, 1, reason: 'Child GestureDetector should have triggered onTap');
  });

  testWidgets(
    'TwoDimensionalScrollable scrolls with DiagonalDragBehavior.free and GestureDetector onPanStart in cells (Trackpad)',
    (WidgetTester tester) async {
      final verticalController = ScrollController();
      addTearDown(verticalController.dispose);
      final horizontalController = ScrollController();
      addTearDown(horizontalController.dispose);
      var panStartCount = 0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SimpleBuilderTableView(
              diagonalDragBehavior: DiagonalDragBehavior.free,
              verticalDetails: ScrollableDetails.vertical(controller: verticalController),
              horizontalDetails: ScrollableDetails.horizontal(controller: horizontalController),
              delegate: TwoDimensionalChildBuilderDelegate(
                maxXIndex: 10,
                maxYIndex: 10,
                builder: (BuildContext context, ChildVicinity vicinity) {
                  return GestureDetector(
                    onPanStart: (_) => panStartCount++,
                    child: Container(
                      height: 200,
                      width: 200,
                      color: vicinity.xIndex.isEven == vicinity.yIndex.isEven
                          ? Colors.black12
                          : Colors.white,
                      child: Center(child: Text('${vicinity.xIndex},${vicinity.yIndex}')),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      final Offset center = tester.getCenter(find.text('1,1'));

      // Simulate trackpad swipe (interpreted as drag)
      final TestGesture gesture = await tester.startGesture(
        center,
        kind: PointerDeviceKind.trackpad,
      );

      await gesture.moveBy(const Offset(-20, -20));
      await tester.pump();
      await gesture.moveBy(const Offset(-20, -20));
      await tester.pump();
      await gesture.up();
      await tester.pumpAndSettle();

      expect(
        verticalController.offset,
        greaterThan(0.0),
        reason: 'Trackpad vertical scroll should have occurred',
      );
      expect(
        horizontalController.offset,
        greaterThan(0.0),
        reason: 'Trackpad horizontal scroll should have occurred',
      );
      expect(
        panStartCount,
        0,
        reason: 'Child GestureDetector should NOT have triggered onPanStart (Trackpad)',
      );
    },
  );
}
