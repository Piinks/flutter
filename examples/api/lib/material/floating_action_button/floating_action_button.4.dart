// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// Flutter code sample for [FloatingActionButton].

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: FabExample(),
    );
  }
}

class FabExample extends StatefulWidget {
  const FabExample({super.key});

  @override
  State<FabExample> createState() => _FabExampleState();
}

class _FabExampleState extends State<FabExample> {
  bool isExtended = true;

  bool handleScrollNotification(ScrollNotification notification) {
    print(notification);
    // The FAB should collapse when scrolling is occurring.
    final bool shouldExtend = notification is UserScrollNotification
        && notification.direction == ScrollDirection.idle;
    print('shouldExtend: $shouldExtend');
    if (isExtended != shouldExtend) {
      setState(() {
        print('set state');
        // React to a change in isExtended
        isExtended = shouldExtend;
      });
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    print('build $isExtended');
    final Widget floatingActionButton = isExtended
        ? FloatingActionButton.extended(
      onPressed: () {
        // Add your onPressed code here!
      },
      backgroundColor: Colors.green,
      icon: const Icon(Icons.add),
      label: const Text('Create'),
    )
        : FloatingActionButton(
      onPressed: () {
        // Add your onPressed code here!
      },
      backgroundColor: Colors.green,
      child: const Icon(Icons.add),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('FloatingActionButton Sample'),
      ),
      body: NotificationListener<ScrollNotification>(
        onNotification: handleScrollNotification,
        child: ListView.builder(
          itemCount: 10,
          itemBuilder: (BuildContext context, int index) {
            return Card(child: ListTile(title: Text('ListTile $index')));
          },
        ),
      ),
      floatingActionButton: floatingActionButton,
    );
  }
}
