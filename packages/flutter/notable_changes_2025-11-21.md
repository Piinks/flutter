### November 15, 2025 to November 21, 2025

_This week, we landed 130 commits to the Flutter framework, tagged for the upcoming 3.39.0 release. We are thrilled to welcome 1 new contributor to the project!_

---
### Framework

**[#174014](https://github.com/flutter/flutter/pull/174014) New `RepeatingAnimationBuilder` for simplified looping animations! 🎬**
Creating continuous, looping animations is now easier than ever with the new `RepeatingAnimationBuilder` widget. This addition simplifies the setup for common animation patterns, like spinners or pulsators, by managing the `AnimationController` internally.
*   Authored by [Bernardo Ferrari](https://github.com/bernaferrari) and reviewed by [Loïc Sharma](https://github.com/loic-sharma) and [Tong Mu](https://github.com/dkwingsmt).

**[#177705](https://github.com/flutter/flutter/pull/177705) Autocomplete options now show even after a selection. 🧠**
The `RawAutocomplete` widget has been improved to continue showing suggestions even after an option has been selected, providing a more intuitive user experience.
*   Authored by [Valentin Vignal](https://github.com/ValentinVignal) and reviewed by [Justin McCandless](https://github.com/justinmc) and [Victor Sanni](https://github.com/victorsanni).

**[#178372](https://github.com/flutter/flutter/pull/178372) `TrainHoppingAnimation` now correctly notifies status listeners. 🚂**
A fix to `TrainHoppingAnimation` ensures that status listeners are properly notified of changes, making animations that switch between controllers more reliable.
*   Authored by [Kostia Sokolovskyi](https://github.com/ksokolovskyi) and reviewed by [Victor Sanni](https://github.com/victorsanni).

**[#178640](https://github.com/flutter/flutter/pull/178640) `DropdownMenuFormField` gains a `decorationBuilder`. 🎨**
You can now dynamically customize the decoration of a `DropdownMenuFormField` using the new `decorationBuilder` property, allowing for more flexible and interactive designs.
*   Authored by [Bruno Leroux](https://github.com/bleroux) and reviewed by [Qun Cheng](https://github.com/QuncCccccc).

**[#177477](https://github.com/flutter/flutter/pull/177477) Accessibility performance gets a boost. ⚡️**
A performance optimization to `computeChildGeometry` makes accessibility calculations slightly faster, contributing to a smoother experience for users of accessibility services.
*   Authored by [LongCatIsLooong](https://github.com/LongCatIsLooong) and reviewed by [chunhtai](https://github.com/chunhtai).

**[#178799](https://github.com/flutter/flutter/pull/178799) Modernized windowing API usage. 🖼️**
The framework now uses the modern `WidgetsBinding.instance.platformDispatcher` in windowing APIs instead of the older `PlatformDispatcher.instance`, improving consistency and future-proofing the code.
*   Authored by [Matthew Kosarek](https://github.com/mattkae) and reviewed by [Robert Ancell](https://github.com/robert-ancell).

### Engine

**[#178418](https://github.com/flutter/flutter/pull/178418) Impeller now supports r32float textures. 📈**
This change adds support for `r32float` textures to Impeller, enabling new rendering possibilities and performance optimizations, especially for shaders that only need a single float channel.
*   Authored by [gaaclarke](https://github.com/gaaclarke) and reviewed by [Chinmay Garde](https://github.com/chinmaygarde).

**[#178833](https://github.com/flutter/flutter/pull/178833) Impeller on Vulkan gets smarter about device support. 📱**
To improve stability, Impeller will now deny-list Adreno 640 and 650 GPUs for Vulkan eligibility, preventing potential rendering issues on those devices.
*   Authored by [Chinmay Garde](https://github.com/chinmaygarde) and reviewed by [Jason Simmons](https://github.com/jason-simmons).

### Tool

**[#178840](https://github.com/flutter/flutter/pull/178840) Native hooks build system gets its own output directory. 🛠️**
The build system for native hooks now uses a separate output directory, preventing conflicts with the primary build and improving build reliability.
*   Authored by [Jason Simmons](https://github.com/jason-simmons) and reviewed by [Ben Konyi](https://github.com/bkonyi).

### Platforms

#### Windows

**[#178523](https://github.com/flutter/flutter/pull/178523) Windows Enter key behavior is now more reliable. ⌨️**
A bug has been fixed where the Enter key could be dropped after the app window lost and regained focus, improving the user experience on Windows.
*   Authored by [DoLT](https://github.com/letrungdo) and reviewed by [Matthew Kosarek](https://github.com/mattkae).

#### macOS

**[#178625](https://github.com/flutter/flutter/pull/178625) macOS framework layout fixed for code assets. 📦**
This change corrects the layout of macOS frameworks for code assets, ensuring that they are structured correctly and improving the reliability of native code integration.
*   Authored by [Simon Binder](https://github.com/simolus3) and reviewed by [Daco Harkes](https://github.com/dcharkes) and [Victoria Ashworth](https://github.com/vashworth).

**[#176893](https://github.com/flutter/flutter/pull/176893) Dialog windows are now implemented for macOS. 💬**
You can now create dialog windows on macOS, a long-awaited feature that brings more platform-native UI capabilities to Flutter apps on the desktop.
*   Authored by [Matej Knopp](https://github.com/knopp) and reviewed by [Matthew Kosarek](https://github.com/mattkae).

#### iOS

**[#178700](https://github.com/flutter/flutter/pull/178700) UIScene migration is now enabled. 📱**
Flutter apps on iOS will now use the modern UIScene-based lifecycle, improving compatibility with the latest iOS features and ensuring a more robust app experience.
*   Authored by [Victoria Ashworth](https://github.com/vashworth) and reviewed by [LongCatIsLooong](https://github.com/LongCatIsLooong).

### Bug Fixes

**Zero-size crash fixes for multiple widgets. 🐛**
A number of widgets have been made more robust against crashes when they are given a zero size, improving the overall stability of the framework. This includes `TextSelectionToolbarTextButton`, `CupertinoSpellCheckSuggestionsToolbar`, `TabBar`, `ToggleButtons`, `ReorderableListView`, and `TabPageSelector`.
*   Authored by [Ahmed Mohamed Sameh](https://github.com/ahmedsameha1) and reviewed by [Victor Sanni](https://github.com/victorsanni) and [Tong Mu](https://github.com/dkwingsmt).
(PRs: #178374, #177978, #178201, #178454, #177646, #178156)

---

### First-time Contributors

A huge welcome to our new contributor this week! 🎊

- [Javalia(Minsuk Jung)](https://github.com/garrettjavalia), for [#176832](https://github.com/flutter/flutter/pull/176832), which improves the detection of companion watch apps.
