### August 15, 2025 to August 29, 2025

A total of 231 changes were merged over the last 2 weeks!

### Framework

**Add SliverGrid.list convenience constructor**
A new convenience constructor, `SliverGrid.list`, has been added to simplify the creation of a `SliverGrid` with a list of children.
Contributed by [Ahmed Hussein](https://github.com/ahmeddhus)
Reviewed by [Loïc Sharma](https://github.com/loic-sharma), [Victor Sanni](https://github.com/victorsanni)
[#173925](https://github.com/flutter/flutter/pull/173925)

**Implement Overlay.of with inherited widget**
`Overlay.of` has been refactored to use an inherited widget, which is more efficient than walking the element tree. This improves performance by reducing the number of lookups.
Contributed by [chunhtai](https://github.com/chunhtai)
Reviewed by [LongCatIsLooong](https://github.com/LongCatIsLooong)
[#174315](https://github.com/flutter/flutter/pull/174315)

**Drawer barrier non dismissible with the escape key**
The drawer can no longer be dismissed with the escape key when `drawerBarrierDismissible` is false.
Contributed by [Roman Jaquez](https://github.com/romanejaquez)
Reviewed by [Justin McCandless](https://github.com/justinmc), [Tong Mu](https://github.com/dkwingsmt)
[#173263](https://github.com/flutter/flutter/pull/173263)

**SnackBar with action no longer auto-dismiss**
A `SnackBar` with an action will no longer auto-dismiss, even when `accessibleNavigation` is true. A new `persist` property has been added to `SnackBar` to control this behavior explicitly.
Contributed by [Qun Cheng](https://github.com/QuncCccccc)
Reviewed by [Victor Sanni](https://github.com/victorsanni), [chunhtai](https://github.com/chunhtai)
[#173084](https://github.com/flutter/flutter/pull/173084)

**Fix: Active step fully colored in vertical mode**
This change fixes a bug where the active step in a vertical stepper was not fully colored.
Contributed by [Victor Sanni](https://github.com/victorsanni)
Reviewed by [chunhtai](https://github.com/chunhtai)
[#173152](https://github.com/flutter/flutter/pull/173152)

**Fix `onSelect` called twice in `DropdownMenuFormField`**
This change fixes a bug where `onSelect` was called twice in `DropdownMenuFormField`.
Contributed by [Qun Cheng](https://github.com/QuncCccccc)
Reviewed by [chunhtai](https://github.com/chunhtai)
[#174053](https://github.com/flutter/flutter/pull/174053)

**Fix Menu anchor reduce padding on web and desktop**
This change fixes a bug where the menu anchor had reduced padding on web and desktop.
Contributed by [Qun Cheng](https://github.com/QuncCccccc)
Reviewed by [chunhtai](https://github.com/chunhtai)
[#172691](https://github.com/flutter/flutter/pull/172691)

**Fix SegmentedButton focus issue**
This change fixes a focus issue with the `SegmentedButton`.
Contributed by [Qun Cheng](https://github.com/QuncCccccc)
Reviewed by [chunhtai](https://github.com/chunhtai)
[#173953](https://github.com/flutter/flutter/pull/173953)

**Add Shift+Enter shortcut example for TextField**
An example has been added to demonstrate how to use the Shift+Enter shortcut in a `TextField`.
Contributed by [Roman Jaquez](https://github.com/romanejaquez)
Reviewed by [Justin McCandless](https://github.com/justinmc)
[#167952](https://github.com/flutter/flutter/pull/167952)

**Improve Stack widget error message for bounded constraints**
The error message for the `Stack` widget has been improved to be more helpful when dealing with bounded constraints.
Contributed by [Qun Cheng](https://github.com/QuncCccccc)
Reviewed by [chunhtai](https://github.com/chunhtai)
[#173352](https://github.com/flutter/flutter/pull/173352)

**Reland predictive back route transitions by default**
Predictive back route transitions are now enabled by default.
Contributed by [Justin McCandless](https://github.com/justinmc)
Reviewed by [chunhtai](https://github.com/chunhtai)
[#173860](https://github.com/flutter/flutter/pull/173860)

### Engine

**Remove the option to disable the merged platform/UI thread on Android and iOS**
The option to disable the merged platform/UI thread has been removed on Android and iOS. This simplifies the threading model and improves performance.
Contributed by [Jason Simmons](https://github.com/jason-simmons)
Reviewed by [Reid Baker](https://github.com/reidbaker), [John "codefu" McDole](https://github.com/jtmcdole), [Zachary Anderson](https://github.com/zanderso)
[#174408](https://github.com/flutter/flutter/pull/174408)

**Implements the Android native stretch effect as a fragment shader (Impeller-only)**
The Android native stretch effect is now implemented as a fragment shader, providing a more realistic and performant overscroll effect on Android.
Contributed by [Dev TtangKong](https://github.com/MTtankkeo)
Reviewed by [Justin McCandless](https://github.com/justinmc), [chunhtai](https://github.com/chunhtai), [Tong Mu](https://github.com/dkwingsmt)
[#173885](https://github.com/flutter/flutter/pull/173885)

### Accessibility

**Add set semantics enabled API and wire iOS a11y bridge**
A new API, `setSemanticsEnabled`, has been added to the `PlatformDispatcher` to allow the framework to inform the engine about whether a semantics tree is being generated. This is used to enable the accessibility bridge on iOS.
Contributed by [chunhtai](https://github.com/chunhtai)
Reviewed by [Mouad Debbar](https://github.com/mdebbar)
[#174163](https://github.com/flutter/flutter/pull/174163)

**Fix empty adaptive text selection toolbars building**
This change fixes a bug where an empty adaptive text selection toolbar would still be built even if there were no buttons to display.
Contributed by [Kostia Sokolovskyi](https://github.com/ksokolovskyi)
Reviewed by [Renzo Olivares](https://github.com/Renzo-Olivares), [Justin McCandless](https://github.com/justinmc)
[#174656](https://github.com/flutter/flutter/pull/174656)

**Adds semantics for disabled buttons in date picker**
The accessibility of the date picker has been improved by adding semantics for disabled buttons. This ensures that screen readers can correctly announce the state of the buttons to users.
Contributed by [chunhtai](https://github.com/chunhtai)
Reviewed by [Hannah Jin](https://github.com/hannah-hyj)
[#174064](https://github.com/flutter/flutter/pull/174064)

**[iOS][Secure Paste] Custom edit menu actions**
This change adds support for custom edit menu actions on iOS. This allows developers to add their own custom buttons to the text selection toolbar.
Contributed by [Jing Shao](https://github.com/jingshao-code)
Reviewed by [Justin McCandless](https://github.com/justinmc), [hellohuanlin](https://github.com/hellohuanlin)
[#171825](https://github.com/flutter/flutter/pull/171825)

**Fix time picker period selector a11y touch targets**
This change fixes the accessibility of the time picker period selector by increasing the touch target size.
Contributed by [Qun Cheng](https://github.com/QuncCccccc)
Reviewed by [chunhtai](https://github.com/chunhtai)
[#170060](https://github.com/flutter/flutter/pull/170060)

**[VPAT][A11y] AutoComplete dropdown option is missing button role**
This change fixes an accessibility issue where the `AutoComplete` dropdown option was missing the button role.
Contributed by [Qun Cheng](https://github.com/QuncCccccc)
Reviewed by [chunhtai](https://github.com/chunhtai)
[#173297](https://github.com/flutter/flutter/pull/173297)

### Migration to `WidgetState`

These changes are part of a larger migration from `MaterialState` to `WidgetState`. This migration simplifies the state management for widgets and makes it more consistent across the framework. The changes in these PRs update various widgets and themes to use the new `WidgetStateProperty` and `WidgetState` classes.
Contributed by [Valentin Vignal](https://github.com/ValentinVignal)
Reviewed by [chunhtai](https://github.com/chunhtai), [Justin McCandless](https://github.com/justinmc), [Qun Cheng](https://github.com/QuncCccccc), [Mitchell Goodwin](https://github.com/MitchellGoodwin)
[#174421](https://github.com/flutter/flutter/pull/174421)
[#174323](https://github.com/flutter/flutter/pull/174323)
[#173893](https://github.com/flutter/flutter/pull/173893)

### First-time Contributors

We'd like to extend a warm welcome to our new contributors! Thank you for your valuable contributions to Flutter.

- [Ahmed Hussein](https://github.com/ahmeddhus), for [#173925](https://github.com/flutter/flutter/pull/173925), which added a new convenience constructor, `SliverGrid.list`.
- [DelcoigneYves](https://github.com/yvesdelcoigne), for [#174120](https://github.com/flutter/flutter/pull/174120), which fixed logic statements in year2023 documentation.
- [Rushikeshbhavsar20](https://github.com/Rushikeshbhavsar20), for [#173695](https://github.com/flutter/flutter/pull/173695), which enhanced FilledButton and Theme Data's documentation to clarify platform-specific visual density behavior.
- [ShantanuBorkar](https://github.com/AlsoShantanuBorkar), for [#174297](https://github.com/flutter/flutter/pull/174297), which fixed a typo in test documentation function name.
- [Simon Pham](https://github.com/simonpham), for [#174291](https://github.com/flutter/flutter/pull/174291), which updated NavigatorPopScope examples to no longer use the deprecated onPop.
- [Sven Gasterstädt](https://github.com/SvenGasterstaedt), for [#174294](https://github.com/flutter/flutter/pull/174294), which clarified how Gemini should handle conflicting guidelines.