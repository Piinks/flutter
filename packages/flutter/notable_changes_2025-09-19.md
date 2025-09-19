### August 30, 2025 to September 19, 2025

_Written by Kate Lovett_

A total of 270 changes were merged to the framework in the last three weeks. The changes below were likely tagged `3.37.0`.

### Framework

- **[#174239](https://github.com/flutter/flutter/pull/174239) Allow OverlayPortal.overlayChildLayoutBuilder to choose root Overlay**
  This change allows `OverlayPortal.overlayChildLayoutBuilder` to choose the root `Overlay`, providing more flexibility for overlay management.
  *   Authored by [chunhtai](https://github.com/chunhtai) and reviewed by [LongCatIsLooong](https://github.com/LongCatIsLooong).

### Engine

- **[#173610](https://github.com/flutter/flutter/pull/173610) Engine Support for Dynamic View Resizing**
  This change enables support for dynamic view resizing in non-web embedders, allowing for more flexible and responsive layouts.
  *   Authored by [LouiseHsu](https://github.com/LouiseHsu) and reviewed by [Loïc Sharma](https://github.com/loic-sharma), [Victoria Ashworth](https://github.com/vashworth), [Chinmay Garde](https://github.com/chinmaygarde), and [Reid Baker](https://github.com/reidbaker).

### Tooling

- **[#174003](https://github.com/flutter/flutter/pull/174003) Deprecate Objective-C plugin template**
  This change deprecates the Objective-C plugin template, encouraging developers to use Swift for new plugins.
  *   Authored by [Elijah Okoroh](https://github.com/okorohelijah) and reviewed by [Jenn Magder](https://github.com/jmagman).
- **[#174849](https://github.com/flutter/flutter/pull/174849) [ Widget Preview] Add `group` property to `Preview`**
  This change adds a `group` property to the `Preview` widget, allowing for better organization of widget previews.
  *   Authored by [bkonyi](https://github.com/bkonyi) and reviewed by [ferhatb](https://github.com/ferhatb) and [InMatrix](https://github.com/InMatrix).

### Cupertino

- **[#170108](https://github.com/flutter/flutter/pull/170108) Add `CupertinoLinearActivityIndicator`**
  A new addition to the Cupertino library, this widget provides a linear progress indicator, giving developers more options for displaying progress in their iOS-styled apps.
  <img width="712" alt="Screenshot 2025-06-06 at 10 00 32 AM" src="https://github.com/user-attachments/assets/d878287f-8236-4acf-80a5-6ecb6d2a09ec" />
  *   Authored by [Valentin Vignal](https://github.com/ValentinVignal) and reviewed by [Victor Sanni](https://github.com/victorsanni).
- **[#172502](https://github.com/flutter/flutter/pull/172502) Adjust default CupertinoCheckbox size on desktop**
  This change adjusts the default size of `CupertinoCheckbox` on desktop platforms to better align with platform conventions.
  *   Authored by [victorsanni](https://github.com/victorsanni) and reviewed by [Tong Mu](https://github.com/dkwingsmt) and [Mitchell Goodwin](https://github.com/MitchellGoodwin).

### Material

- **[#171646](https://github.com/flutter/flutter/pull/171646) feat: Enable WidgetStateColor to be used in ChipThemeData.deleteIconColor**
  This change allows developers to use `WidgetStateColor` for the delete icon color in `ChipThemeData`, enabling more dynamic and state-responsive chip designs.
  *   Authored by [Erick](https://github.com/erickzanardo) and reviewed by [Victor Sanni](https://github.com/victorsanni) and [Qun Cheng](https://github.com/QuncCccccc).
- **[#174605](https://github.com/flutter/flutter/pull/174605) Allow Passing an AnimationController to CircularProgressIndicator and LinearProgressIndicator**
  This update allows developers to pass an `AnimationController` to `CircularProgressIndicator` and `LinearProgressIndicator`, providing more control over the animation of indeterminate progress indicators.
  *   Authored by [Tong Mu](https://github.com/dkwingsmt) and reviewed by [Victor Sanni](https://github.com/victorsanni).
- **[#174515](https://github.com/flutter/flutter/pull/174515) Fix IconButton.color overrided by IconButtomTheme**
  This change fixes a bug where `IconButton.color` was being overridden by `IconButtonTheme`, ensuring that the local color takes precedence.
  *   Authored by [bleroux](https://github.com/bleroux) and reviewed by [Victor Sanni](https://github.com/victorsanni) and [Qun Cheng](https://github.com/QuncCccccc).
- **[#173108](https://github.com/flutter/flutter/pull/173108) Fix LinearProgressIndicator track painting.**
  This change fixes a track painting issue in `LinearProgressIndicator`, ensuring that the track is painted correctly.
  *   Authored by [ksokolovskyi](https://github.com/ksokolovskyi) and reviewed by [Qun Cheng](https://github.com/QuncCccccc).

### Accessibility

- **[#174856](https://github.com/flutter/flutter/pull/174856) Add semanticIndexOffset argument to SliverList.builder, SliverGrid.builder, and SliverFixedExtentList.builder**
  This change adds a `semanticIndexOffset` argument to `SliverList.builder`, `SliverGrid.builder`, and `SliverFixedExtentList.builder`, allowing for more control over the semantic indexing of slivers.
  *   Authored by [Rodrigo Gomes Dias](https://github.com/rodrigogmdias) and reviewed by [Renzo-Olivares](https://github.com/Renzo-Olivares) and [Loïc Sharma](https://github.com/loic-sharma).
- **[#174473](https://github.com/flutter/flutter/pull/174473) fix(Semantics): Ensure semantics properties take priority over button's**
  This change ensures that semantics properties take priority over the button's default semantics, providing more control over accessibility.
  *   Authored by [pedromassango](https://github.com/pedromassango) and reviewed by [chunhtai](https://github.com/chunhtai).
- **[#174480](https://github.com/flutter/flutter/pull/174480) [A11y] Add semantics for CupertinoExpansionTile**
  This change adds semantics for `CupertinoExpansionTile`, improving accessibility for iOS-styled expansion tiles.
  *   Authored by [victorsanni](https://github.com/victorsanni) and reviewed by [chunhtai](https://github.com/chunhtai).

### Android

- **[#173364](https://github.com/flutter/flutter/pull/173364) Wires up Android API to set section locale**
  This change wires up the Android API to set the section locale, improving internationalization support on Android.
  *   Authored by [chunhtai](https://github.com/chunhtai) and reviewed by [reidbaker](https://github.com/reidbaker) and [gaaclarke](https://github.com/gaaclarke).

### iOS

- **[#174168](https://github.com/flutter/flutter/pull/174168) Add a `viewController` property to the ios/macOS `FlutterPluginRegistrar` protocol**
  This change adds a `viewController` property to the `FlutterPluginRegistrar` protocol for iOS and macOS, making it easier to access the view controller from plugins.
  *   Authored by [LongCatIsLooong](https://github.com/LongCatIsLooong) and reviewed by [Victoria Ashworth](https://github.com/vashworth).

### First-time Contributors

- [Daniil](https://github.com/danwirele), for [#175654](https://github.com/flutter/flutter/pull/175654), which fixes a radio group single selection check.
- [Rodrigo Gomes Dias](https://github.com/rodrigogmdias), for [#174856](https://github.com/flutter/flutter/pull/174856), which adds a `semanticIndexOffset` argument to several sliver builders.
