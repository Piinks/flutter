## **Framework**

### **A More Inclusive and Accessible Experience**

Making applications accessible to all users is a cornerstone of the Flutter framework. This release continues our commitment with a host of improvements that give developers more control and refine the out-of-the-box experience for users of assistive technologies.

#### **Richer Semantics on the Web**

We've made significant strides in how Flutter web apps communicate with screen readers and other tools. For international users, we've added support for semantics locales ([\#171196](https://github.com/flutter/flutter/pull/171196)), ensuring that accessibility features are presented in the user's preferred language.

#### **New Tools for Building Accessible Widgets**

Developers now have more powerful tools to create sophisticated accessible experiences. The new `SemanticsLabelBuilder` widget ([\#171683](https://github.com/flutter/flutter/pull/171683)) simplifies the process of combining multiple data points into a single, coherent announcement without messy string concatenation.

For complex scrollable views, the new `SliverEnsureSemantics` widget ([\#166889](https://github.com/flutter/flutter/pull/166889)) can be used to wrap slivers, ensuring they are always represented in the semantics tree, even when scrolled out of view.

#### **Core Widget and Platform Polish**

This release is also packed with fixes that polish the accessibility of core widgets.

* On iOS, the `CupertinoSliverNavigationBar` now correctly respects accessibility text scaling ([\#168866](https://github.com/flutter/flutter/pull/168866)), and we've fixed VoiceOver tab activation behavior ([\#170076](https://github.com/flutter/flutter/pull/170076)).
* For Android, we've resolved issues with Talkback when using platform views ([\#168939](https://github.com/flutter/flutter/pull/168939)), a critical fix for apps that embed native components.
* We've also backfilled semantics properties for `CustomPainter` ([\#168113](https://github.com/flutter/flutter/pull/168113)), empowering you to make your custom-drawn UI fully accessible.
* The text selection toolbar is now correctly aligned for right-to-left (RTL) languages, improving the experience for a global audience ([\#169854](https://github.com/flutter/flutter/pull/169854)).

### **Material and Cupertino: More Power and Polish**

The Material and Cupertino libraries continue to evolve, giving you more control over your app's look and feel.

#### **New and Enhanced Components**

We've added brand new, highly requested components and shipped significant enhancements to existing ones.

* **Introducing `DropdownMenuFormField` ([\#163721](https://github.com/flutter/flutter/pull/163721)):** You can now easily integrate the M3 `DropdownMenu` directly into your forms.
* **Scrollable `NavigationRail` ([\#169421](https://github.com/flutter/flutter/pull/169421)):** The `NavigationRail` can now be configured to scroll, for cases where you have more destinations than can fit on the screen.
* **`NavigationDrawer` Header and Footer ([\#168005](https://github.com/flutter/flutter/pull/168005)):** You can now add a header and footer to the `NavigationDrawer`, providing more layout flexibility.
* **Introducing CupertinoExpansionTile ([\#165606](https://github.com/flutter/flutter/pull/165606)):** Create expandable and collapsible list items with the new `CupertinoExpansionTile` widget.

#### **Higher Fidelity and Interactivity**

A key theme for this release was polishing our widgets to be pixel-perfect and behaviorally identical to their native counterparts.

* Many Cupertino widgets have been updated to use the **`RSuperellipse` shape** ([\#167784](https://github.com/flutter/flutter/pull/167784)), giving them the signature continuous-corner look that iOS users expect.
* To make apps feel more alive and native, we've added haptic feedback to key interactive components like the `CupertinoPicker` ([\#170641](https://github.com/flutter/flutter/pull/170641)) and `CupertinoSlider` ([\#167362](https://github.com/flutter/flutter/pull/167362)).
* The `Slider`'s value indicator can now be configured to be always visible ([\#162223](https://github.com/flutter/flutter/pull/162223)).

### **More from the Framework**

This release includes a number of powerful new features and refinements for some of the framework's most essential capabilities, giving you more granular control over complex UI.

#### **More Powerful Slivers**

For developers building sophisticated scrolling experiences, you can now explicitly control the **paint order (or z-order) of slivers** ([\#164818](https://github.com/flutter/flutter/pull/164818)), making it possible to correctly implement advanced effects like "sticky" headers that overlap other slivers without visual glitches.

#### **Finer-Grained Control Over Navigation and Forms**

We've added several new features to give you more control over your app's navigation and routing.

* **Fullscreen Dialogs ([\#167794](https://github.com/flutter/flutter/pull/167794)):** The property ‘fullscreenDialog’ was added to ModalRoute and all its descendants, and showDialog. This enables customizing navigation behavior to and from dialog routes.
* `FormField` now includes an `onReset` callback, making it easier to handle form clearing logic ([\#167060](https://github.com/flutter/flutter/pull/167060)).

#### **Multi-Window Support (Engine)**

Our friends at Canonical continue to make excellent progress on adding support for multi-window applications\! In this release, they landed the foundational logic to create and update windows in Windows and macOS ([\#168728](https://github.com/flutter/flutter/pull/168728)). In subsequent releases, we will update Linux and introduce experimental APIs to expose multi-window functionality. Stay tuned\!

#### **Text Input and Selection Refinements**

Text input is a fundamental part of the user experience, and this release brings several refinements to make it more powerful and predictable.

* **A More Unified Gesture System:** We've introduced the `PositionedGestureDetails` interface ([\#160714](https://github.com/flutter/flutter/pull/160714)), which unifies the details for all pointer-based gestures and allows you to write more generic gesture handling code.
* **iOS Single-Line Scrolling ([\#162841](https://github.com/flutter/flutter/pull/162841)):** To better align with native iOS behavior, single-line text fields are no longer scrollable by the user.
* **Android Home/End Key Support ([\#168184](https://github.com/flutter/flutter/pull/168184)):** We've added support for the Home and End keyboard shortcuts on Android.

### **Looking forward: Decoupling Flutter’s Design Libraries**

As the Flutter ecosystem continues to grow and mature, so too must the core framework. A key part of this maturation is ensuring that all parts of Flutter can evolve at the pace that best serves the community.

To that end, we are beginning the process of moving the Material and Cupertino libraries out of the core Flutter framework and into their own standalone packages. We are just getting started on this work and, as always, are doing so openly and in collaboration with our contributor community.

**Why is this changing?**

This evolution will allow the Material and Cupertino libraries to innovate and release updates more frequently, independent of the quarterly Flutter release cycle. It also empowers the community to contribute more directly to the UI libraries they use every day. For the core framework, this change will lead to a more focused and stable foundation.

**What does this mean for you?**

There are no immediate changes to your workflow. This is the start of a long-term project, and we are committed to making the eventual transition as smooth as possible. We invite you to follow our progress, learn more about the plan, and share your feedback.

* To read the detailed vision and rationale, please see: **\[Link to Doc Placeholder\]**
* To provide feedback and help coordinate the work, please join the discussion on GitHub: **\[Link to GitHub Coordination Placeholder\]**

This is a natural evolution for a mature and thriving ecosystem. We believe this change will lead to stronger and more agile Material and Cupertino libraries, with an even greater opportunity for community collaboration.

### **Deprecations and Breaking Changes**

This release includes several important deprecations and breaking changes that are part of our ongoing effort to modernize and improve the Flutter framework.

* **Component Theme Normalization:** This release marks the completion of a significant, long-term project to normalize component themes. To make theming more consistent and align with Material 3, component themes like `AppBarTheme`, `BottomAppBarTheme`, and `InputDecorationTheme` have been refactored to be based on new, data-oriented `...ThemeData` classes.
* **Radio Widget Redesign:** The `Radio`, `CupertinoRadio`, and `RadioListTile` widgets have been redesigned to improve accessibility. The `groupValue` and `onChanged` properties have been deprecated in favor of a new `RadioGroup` widget that manages the state for a set of radio buttons.
* **Form Widget and Slivers:** The `Form` widget can no longer be used directly as a sliver. To include a `Form` in a `CustomScrollView`, it should be wrapped in a `SliverToBoxAdapter`.
* **Semantics `elevation` and `thickness` Removal:** The `elevation` and `thickness` properties on `SemanticsConfiguration` and `SemanticsNode` have been removed. These properties were unimplemented and their removal simplifies the API.
* **DropdownButtonFormField `value` Deprecation:** The `value` parameter on `DropdownButtonFormField` has been deprecated and renamed to `initialValue` to more accurately reflect its behavior.

For more details and migration guidance, see our [breaking changes page](https://docs.flutter.dev/release/breaking-changes).
