// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';

class ContextAwareBottomWidget extends StatelessWidget implements PreferredSizeWidget {
  const ContextAwareBottomWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(height: preferredSize.resolve(context).height, color: CupertinoColors.activeBlue);
  }

  @override
  Size get preferredSize => ContextAwareSize((BuildContext context) {
    // Return a height based on MediaQuery.
    final double height = MediaQuery.of(context).size.height > 500 ? 100.0 : 50.0;
    return Size.fromHeight(height);
  }, double.infinity, 50.0); // Default to 50 if resolved without context (which shouldn't happen in scaffold)
}

void main() {
  testWidgets('CupertinoNavigationBar respects ContextAwareSize from bottom widget', (WidgetTester tester) async {
    late BuildContext childContext;

    // Test with height > 500
    await tester.pumpWidget(
      CupertinoApp(
        home: MediaQuery(
          data: const MediaQueryData(size: Size(800, 600)),
          child: CupertinoPageScaffold(
            navigationBar: ContextAwareNavigationBar(
              middle: const Text('Title'),
              bottom: const ContextAwareBottomWidget(),
            ),
            child: Builder(builder: (context) {
              childContext = context;
              return const Center(child: Text('Content'));
            }),
          ),
        ),
      ),
    );

    // Nav bar height should be: 44 (persistent) + 100 (resolved bottom) = 144.
    // Default MediaQuery has 0 padding.
    expect(MediaQuery.of(childContext).padding.top, 144.0);

    // Now update MediaQuery to be small
    await tester.pumpWidget(
      CupertinoApp(
        home: MediaQuery(
          data: const MediaQueryData(size: Size(800, 400)),
          child: CupertinoPageScaffold(
            navigationBar: ContextAwareNavigationBar(
              middle: const Text('Title'),
              bottom: const ContextAwareBottomWidget(),
            ),
             child: Builder(builder: (context) {
              childContext = context;
              return const Center(child: Text('Content'));
            }),
          ),
        ),
      ),
    );

    // Nav bar height should be: 44 (persistent) + 50 (resolved bottom) = 94.
    expect(MediaQuery.of(childContext).padding.top, 94.0);
  });
}

class ContextAwareNavigationBar extends CupertinoNavigationBar {
  const ContextAwareNavigationBar({
    super.key,
    super.middle,
    super.bottom,
  });
}
