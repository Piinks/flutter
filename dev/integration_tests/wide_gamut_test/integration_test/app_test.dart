// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:wide_gamut_test/main.dart' as app;

// See: https://developer.apple.com/documentation/metal/mtlpixelformat/mtlpixelformatbgr10_xr.
double _decodeBGR10(int x) {
  const double max = 1.25098;
  const double min = -0.752941;
  const double intercept = min;
  const double slope = (max - min) / 1024.0;
  return (x * slope) + intercept;
}

bool _isAlmost(double x, double y, double epsilon) {
  return (x - y).abs() < epsilon;
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('end-to-end test', () {
    testWidgets('look for display p3 deepest red', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 2));

      const MethodChannel channel = MethodChannel('flutter/screenshot');
      final List<Object?> result =
          await channel.invokeMethod('test') as List<Object?>;
      expect(result, isNotNull);
      expect(result.length, 4);
      final int width = (result[0] as int?)!;
      final int height = (result[1] as int?)!;
      final String format = (result[2] as String?)!;
      expect(format, 'MTLPixelFormatBGR10_XR');
      final Uint8List bytes = (result[3] as Uint8List?)!;
      final ByteData byteData = ByteData.sublistView(bytes);
      expect(bytes.lengthInBytes, width * height * 4);
      expect(bytes.lengthInBytes, byteData.lengthInBytes);
      bool foundDeepRed = false;
      for (int i = 0; i < bytes.lengthInBytes; i += 4) {
        final int pixel = byteData.getUint32(i, Endian.host);
        final double blue = _decodeBGR10(pixel & 0x3ff);
        final double green = _decodeBGR10((pixel >> 10) & 0x3ff);
        final double red = _decodeBGR10((pixel >> 20) & 0x3ff);
        if (_isAlmost(red, 1.0931, 0.01) &&
            _isAlmost(green, -0.2268, 0.01) &&
            _isAlmost(blue, -0.1501, 0.01)) {
          foundDeepRed = true;
        }
      }
      expect(foundDeepRed, isTrue);
    });
  });
}
