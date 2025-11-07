### October 25, 2025 to November 7, 2025

A total of 228 commits landed in flutter/flutter since the last update!

This week’s notable changes will be included in Flutter version 3.35.0. A special welcome to our 5 new contributors!

The changes below are populated by a script that filters and selects notable changes from the past week. This is not an exhaustive list of all changes, but is instead a list of changes that are notable and might be interesting to the Flutter developer community.

Compiled with care with Gemini-CLI. 🤖 😉

### Framework

- **[#177721](https://github.com/flutter/flutter/pull/177721) Add haptic notifications support**
  A new feature that allows developers to trigger haptic feedback for notifications, improving user experience.
  * Authored by [Kostia Sokolovskyi](https://github.com/ksokolovskyi) and reviewed by [Matt Boetger](https://github.com/mboetger), [hellohuanlin](https://github.com/hellohuanlin), [Mouad Debbar](https://github.com/mdebbar), and [Tong Mu](https://github.com/dkwingsmt).

- **[#177313](https://github.com/flutter/flutter/pull/177313) Fix text input actions in DropdownMenu.**
  This change fixes a bug where text input actions were not working correctly in `DropdownMenu`, a common UI widget.

  | BEFORE | AFTER |
  | - | - |
  | <video alt="before" src="https://github.com/user-attachments/assets/a50d41de-7e54-409b-bf81-80dfb1db132f" /> | <video alt="after" src="https://github.com/user-attachments/assets/152e47e6-d774-481c-8478-af526b5f6749" /> |

  * Authored by [Kostia Sokolovskyi](https://github.com/ksokolovskyi) and reviewed by [Justin McCandless](https://github.com/justinmc) and [Bruno Leroux](https://github.com/bleroux).

- **[#174491](https://github.com/flutter/flutter/pull/174491) fix: findChildIndexCallback to take seperators into account for seperated named constructor in ListView and SliverList**
  This fixes a bug in `ListView` and `SliverList` where `findChildIndexCallback` was not correctly accounting for separators.
  * Authored by [Kishan Rathore](https://github.com/rkishan516) and reviewed by [chunhtai](https://github.com/chunhtai) and [Victor Sanni](https://github.com/victorsanni).

- **[#169341](https://github.com/flutter/flutter/pull/169341) Add `Navigator.popUntilWithResult`**
  This new feature for `Navigator` allows popping multiple routes until a predicate is satisfied and returns a result.
  * Authored by [Alex Medinsh](https://github.com/alex-medinsh) and reviewed by [chunhtai](https://github.com/chunhtai) and [Justin McCandless](https://github.com/justinmc).

### Accessibility

- **[#177969](https://github.com/flutter/flutter/pull/177969) Use aria-hidden attribute for platform view accessibility on web**
  This improves web accessibility by using the `aria-hidden` attribute for platform views.
  * Authored by [zhongliugo](https://github.com/flutter-zl) and reviewed by [Mouad Debbar](https://github.com/mdebbar) and [chunhtai](https://github.com/chunhtai).

- **[#175551](https://github.com/flutter/flutter/pull/175551) Add blockAccessibilityFocus flag**
  A new flag to block accessibility focus, giving developers more control over the accessibility experience.
  * Authored by [Hannah Jin](https://github.com/hannah-hyj) and reviewed by [ash2moon](https://github.com/ash2moon) and [chunhtai](https://github.com/chunhtai).

### Android

- **[#177753](https://github.com/flutter/flutter/pull/177753) Respect product flavor abiFilters by adding a `disable-abi-filtering` Android project flag.**
  This change provides more control over Android builds by allowing developers to disable ABI filtering for product flavors.
  * Authored by [Matt Boetger](https://github.com/mboetger) and reviewed by [Gray Mackall](https://github.com/gmackall).

### iOS

- **[#177065](https://github.com/flutter/flutter/pull/177065) Fix(ios): Remove arm64 exclusion to support Xcode 26 simulators**
  This change ensures compatibility with future versions of Xcode by removing the arm64 exclusion for simulators.
  * Authored by [Elijah Okoroh](https://github.com/okorohelijah) and reviewed by [Victoria Ashworth](https://github.com/vashworth).

### Tool

- **[#178170](https://github.com/flutter/flutter/pull/178170) [ Tool ] Ignore invalid UTF-8 from ADB's stdout**
  This fixes a tool crash that could occur when `adb` outputs invalid UTF-8.
  * Authored by [Ben Konyi](https://github.com/bkonyi) and reviewed by [Reid Baker](https://github.com/reidbaker).

- **[#177470](https://github.com/flutter/flutter/pull/177470) [ Tool ] Add `Stream.transformWithCallSite` to provide more useful stack traces**
  This developer experience improvement provides more useful stack traces for streams.
  * Authored by [Ben Konyi](https://github.com/bkonyi) and reviewed by [Jessy Yameogo](https://github.com/jyameo).

### First-time Contributors

- [Adam Spivak](https://github.com/Spivak-adam), for [#173600](https://github.com/flutter/flutter/pull/173600), which updates the pubspec.yaml.tmpl build version tracker.
- [Bui Dai Duong](https://github.com/definev), for [#176073](https://github.com/flutter/flutter/pull/176073), which optimizes colored box rendering.
- [Jaineel Mamtora](https://github.com/Jaineel-Mamtora), for [#173706](https://github.com/flutter/flutter/pull/173706), which fixes inconsistent horizontal spacing in the time picker for non-english languages.
- [Lewin Pauli](https://github.com/lewinpauli), for [#171250](https://github.com/flutter/flutter/pull/171250), which adds computeDryBaseline implementation in RenderAligningShiftedBox.
- [walley892](https://github.com/walley892), for [#177482](https://github.com/flutter/flutter/pull/177482), which replaces rendering for solid color circles to use SDFs.
