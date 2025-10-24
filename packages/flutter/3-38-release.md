### **Framework**

This release of Flutter focuses on refinement and laying the groundwork for the future. The framework continues to mature with significant API modernization, foundational improvements to web rendering, and a host of updates that make building sophisticated, accessible, and high-performance applications easier than ever. From the new `WidgetState` API to more predictable scrolling and deeper platform integration, these changes are designed to improve the developer experience and polish the final product for end-users.

### **Material and Cupertino updates**

The Material and Cupertino libraries continue to evolve with a focus on API consistency, new features, and polished user experiences. This release brings a major API migration, new widget capabilities, and numerous refinements that make building beautiful, functional UIs more straightforward.

A significant effort in this release is the migration from the deprecated `MaterialState` to the more unified `WidgetState`. This provides a consistent, expressive way to define a widget’s appearance across different interaction states, such as pressed, hovered, or disabled. This migration has been applied to a wide range of widgets and their themes, including `IconButton`, `ElevatedButton`, `Checkbox`, and `Switch` ([#173893](https://github.com/flutter/flutter/pull/173893)). The new API also adds power and flexibility; for instance, `IconButton` now includes a `statesController` property ([#169821](https://github.com/flutter/flutter/pull/169821)) that allows for programmatic control over its visual states, opening the door to more custom and interactive designs.

This release also introduces several new features and convenience APIs. For developers building custom scroll views, the new `SliverGrid.list` constructor ([#173925](https://github.com/flutter/flutter/pull/173925)) offers a cleaner way to create a grid from a simple list of children. The `Badge.count` constructor now includes a `maxCount` parameter ([#171054](https://github.com/flutter/flutter/pull/171054)) to easily cap the displayed count (e.g., showing "99+" instead of "100"). For finer-grained gesture control, the `InkWell` widget now features an `onLongPressUp` callback ([#173221](https://github.com/flutter/flutter/pull/173221)), useful for triggering actions that should only complete when the user lifts their finger.

The Cupertino library also continues its journey toward pixel-perfect iOS fidelity. The `CupertinoSlidingSegmentedControl` adds an `isMomentary` property ([#164262](https://github.com/flutter/flutter/pull/164262)) to allow the control to trigger actions without persisting a selection. To better match native iOS behavior, the `CupertinoSheet` now features a subtle "stretch" effect when dragged upward while fully expanded ([#168547](https://github.com/flutter/flutter/pull/168547)).

Finally, this release is packed with refinements that polish the behavior of core components. Highlights include a fix for `DropdownMenuFormField` to correctly clear its text field when a form is reset ([#174937](https://github.com/flutter/flutter/pull/174937)) and updates to `SegmentedButton` to improve focus handling ([#173953](https://github.com/flutter/flutter/pull/173953)) and ensure its border correctly reflects the widget's state ([#172754](https://github.com/flutter/flutter/pull/172754)).

### **Web: enhanced internationalization and rendering**

Flutter’s web support continues to mature with foundational improvements to internationalization, rendering, and reliability. This release brings Flutter web apps more in line with modern web standards and prepares them for future performance enhancements.

For international users, detecting the browser’s preferred locale is now more robust. The engine now uses the standard `Intl.Locale` web API to parse browser languages, replacing the previous manual and more fragile implementation ([#172964](https://github.com/flutter/flutter/pull/172964)). This change leads to more reliable locale detection and a better experience for a global audience.

This release also includes significant investments in the web rendering stack. A new text rendering implementation, `WebParagraph` ([#167559](https://github.com/flutter/flutter/pull/167559)), lays the groundwork for higher-fidelity and more performant text. In another major architectural change, the Skwasm backend has been refactored to use `DisplayList` objects ([#172314](https://github.com/flutter/flutter/pull/172314)). This is a key preparatory step on the path to bringing the Impeller rendering engine to Flutter for web, promising significant performance improvements in the future.

Flutter web apps are also more resilient. For apps using the CanvasKit renderer, Flutter now automatically falls back to a CPU-based renderer when WebGL is not available ([#173629](https://github.com/flutter/flutter/pull/173629)). This ensures that applications can still run on a wider range of hardware. UI polish continues with a fix to `RSuperellipse` that prevents rendering errors when corner radii are larger than the widget itself ([#172254](https://github.com/flutter/flutter/pull/172254)), making these continuous-corner shapes more robust.

### **Scrolling: more robust and predictable slivers**

Flutter’s sliver-based scrolling model is a powerful tool for creating a wide variety of custom scrolling effects. This release brings a number of fixes that make building complex scrolling layouts, especially those using `SliverMainAxisGroup` and `SliverCrossAxisGroup`, more robust and predictable.

Developers using these widgets to group multiple slivers will find that gesture handling is now more reliable. Hit-testing for taps and other pointer events on slivers within these groups is now correctly calculated, ensuring that user interactions behave as expected ([#174265](https://github.com/flutter/flutter/pull/174265)).

Several other fixes contribute to more accurate scrolling behavior within a `SliverMainAxisGroup`. Over-scrolling issues when using a pinned header are resolved ([#173349](https://github.com/flutter/flutter/pull/173349)), calling `showOnScreen` to reveal a sliver now works correctly ([#171339](https://github.com/flutter/flutter/pull/171339)), and the internal scroll offset calculation is more precise ([#174369](https://github.com/flutter/flutter/pull/174369)).

This release also improves focus navigation for keyboard and D-pad users in complex layouts. In nested scroll views with different scroll axes (such as a vertical list of horizontal carousels), directional focus navigation is now more predictable, preventing the focus from jumping unexpectedly between sections ([#172875](https://github.com/flutter/flutter/pull/172875)).

Together, these changes allow for the confident creation of sophisticated, multi-part scrolling experiences.

### **Accessibility: a more inclusive experience for all users**

Making applications accessible to all users is a cornerstone of the Flutter framework. This release continues that commitment by giving developers more programmatic control, improving the experience for international users, and polishing the accessibility of core widgets.

For developers building complex applications, this release introduces the ability to programmatically enable and disable semantics on iOS via `PlatformDispatcher.setSemanticsEnabled` ([#174163](https://github.com/flutter/flutter/pull/174163)). This provides more fine-grained control over how an app interacts with assistive technologies. Debugging accessibility issues is also now easier, as `debugDumpSemanticsTree` includes validation results to help diagnose problems more quickly ([#174677](https://github.com/flutter/flutter/pull/174677)).

The experience for international users of assistive technologies has also been improved. For apps that display content in multiple languages on a single screen, developers can now specify a locale for a section of the UI on Android ([#173364](https://github.com/flutter/flutter/pull/173364)). On the web, the locale of a `Text` widget is now more reliably included in the semantics tree, ensuring screen readers pronounce words with the correct accent and character set ([#172034](https://github.com/flutter/flutter/pull/172034)).

Finally, the accessibility of core widgets continues to be refined. The `CupertinoExpansionTile` is now accessible by default ([#174480](https://github.com/flutter/flutter/pull/174480)), and the `AutoComplete` widget now announces the status of search results to the user ([#173480](https://github.com/flutter/flutter/pull/173480)). Other improvements, such as larger touch targets in the `TimePicker` ([#170060](https://github.com/flutter/flutter/pull/170060)), contribute to a more accessible out-of-the-box experience.

### **Framework: more control and new features**

This release includes a number of powerful new capabilities and refinements across the framework, giving developers more granular control over advanced UI, navigation, and platform interactions.

Developers now have more power when creating pop-ups, dialogs, and other floating UI elements with `OverlayPortal`. It is now possible to render a child in any `Overlay` up the widget tree, including the root `Overlay` ([#174239](https://github.com/flutter/flutter/pull/174239)), making it easier to show app-wide notifications or other UI that needs to escape the layout constraints of its parent widget. The underlying `Overlay.of` method was also made more robust and efficient ([#174315](https://github.com/flutter/flutter/pull/174315)).

For a more modern Android navigation experience, predictive back route transitions are now enabled by default in `MaterialApp` ([#173860](https://github.com/flutter/flutter/pull/173860)). When a user performs the back gesture, they now see a preview of the home screen as the current route animates away.

This release also deepens desktop integration. On Windows, developers can now access a list of connected displays and query detailed properties for each, such as resolution, refresh rate, and physical size ([#164460](https://github.com/flutter/flutter/pull/164460)). This enables the creation of applications with sophisticated window management features.

Finally, the framework itself is now more resilient. Errors that occur in widget lifecycle callbacks (such as `didUpdateWidget`) are now handled more gracefully, preventing them from causing cascading failures in the element tree ([#173148](https://github.com/flutter/flutter/pull/173148)). and `ResizeImage` now correctly implements equality, which makes image caching and comparison more predictable by ensuring identical `ResizeImage` providers are treated as the same ([#172643](https://github.com/flutter/flutter/pull/172643)).

### **Deprecations and breaking changes**

This release includes several important deprecations and breaking changes as part of the ongoing effort to modernize and improve the Flutter framework.

Key build and tooling changes have been made that may affect custom build scripts. The `version` file at the root of the Flutter SDK has been removed in favor of a new `flutter.version.json` file located in `bin/cache` ([#172793](https://github.com/flutter/flutter/pull/172793)). Additionally, the `AssetManifest.json` file is no longer generated by default ([#172594](https://github.com/flutter/flutter/pull/172594)).

Other notable changes include:

*   For more predictable behavior, a `SnackBar` that includes an action will no longer automatically dismiss ([#173084](https://github.com/flutter/flutter/pull/173084)).
*   The `OverlayPortal.targetsRootOverlay` constructor is deprecated in favor of the more flexible `OverlayPortal(overlayLocation: OverlayChildLocation.rootOverlay)`.
*   Several properties on `CupertinoDynamicColor`, such as `withAlpha` and `withOpacity`, are now deprecated in favor of standard `Color` methods to simplify its usage ([#171160](https://github.com/flutter/flutter/pull/171160)).

For more details and migration guidance on these and other changes, see the [breaking changes page](https://docs.flutter.dev/release/breaking-changes) on flutter.dev.

### **Summary**

The changes in this release continue to strengthen the core of the Flutter framework. The modernization of APIs like `WidgetState`, foundational investments in web rendering, and a strong focus on improving the reliability of complex widgets and accessibility features all contribute to a more powerful and stable platform. These updates, from quality-of-life improvements to major architectural shifts, empower developers to build beautiful, high-quality, multi-platform applications with more confidence and control.