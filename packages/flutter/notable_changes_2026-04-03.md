### March 28, 2026 to April 03, 2026

The Flutter repository has been busy this week with 141 changes from 37 contributors. This work is likely to be included in the upcoming Flutter 3.43.0 release. We are excited to welcome 5 new contributors this week!

#### Framework and Widgets

*   **[#182009](https://github.com/flutter/flutter/pull/182009) Add alwaysSizeToContent argument to Overlay.**
    *   Authored by [Matej Knopp](https://github.com/knopp) and reviewed by [Matthew Kosarek](https://github.com/mattkae).
    *   Added a new `alwaysSizeToContent` option to `Overlay`, providing more flexibility for sizing overlays based on their content even within finite constraints. 🖼️

*   **[#175710](https://github.com/flutter/flutter/pull/175710) feat: add infinite carousel support**
    *   Authored by [Kishan Rathore](https://github.com/rkishan516) and reviewed by [Qun Cheng](https://github.com/QuncCccccc), [Hannah Jin](https://github.com/hannah-hyj).
    *   A new feature that adds support for infinite carousels, allowing for seamless looping of content in lists and galleries. 🎠

*   **[#184421](https://github.com/flutter/flutter/pull/184421) Fix line breaks being lost when copying after selection gesture in SelectableRegion**
    *   Authored by [Renzo Olivares](https://github.com/Renzo-Olivares) and reviewed by [chunhtai](https://github.com/chunhtai), [Loïc Sharma](https://github.com/loic-sharma).
    *   Improved text selection accuracy in `SelectableRegion` by ensuring line height calculations include newline character regions, fixing issues where copying text lost line breaks. 📋

#### Desktop and Platforms

*   **[#182348](https://github.com/flutter/flutter/pull/182348) Implement tooltip windows on Linux**
    *   Authored by [Robert Ancell](https://github.com/robert-ancell) and reviewed by [Matthew Kosarek](https://github.com/mattkae).
    *   Linux desktop applications now support native-style tooltip windows using popup windows. 🐧

*   **[#182371](https://github.com/flutter/flutter/pull/182371) Implement popup windows for macOS**
    *   Authored by [Matej Knopp](https://github.com/knopp) and reviewed by [Loïc Sharma](https://github.com/loic-sharma), [Matthew Kosarek](https://github.com/mattkae).
    *   Enhanced macOS desktop support with the implementation of popup windows, enabling richer UI components like tooltips and menus. 💻

*   **[#175406](https://github.com/flutter/flutter/pull/175406) [Windows] Restore and enable IAccessibleEx implementation**
    *   Authored by [Loïc PÉRON](https://github.com/loic-peron-inetum-public) and reviewed by [Loïc Sharma](https://github.com/loic-sharma), [Matthew Kosarek](https://github.com/mattkae).
    *   Restored advanced accessibility features on Windows by enabling `IAccessibleEx`, allowing UI automation tools to better identify and interact with Flutter widgets. ♿️

*   **[#183072](https://github.com/flutter/flutter/pull/183072) [Android] Use EdgeToEdge.enable/WindowCompat for edge-to-edge mode instead of deprecated View flags**
    *   Authored by [David Bebawy](https://github.com/dbebawy) and reviewed by [Matt Boetger](https://github.com/mboetger), [Reid Baker](https://github.com/reidbaker).
    *   Modernizes Android edge-to-edge support by migrating to AndroidX APIs, fixing deprecation warnings and improving compatibility with Android 15. 📱

*   **[#183650](https://github.com/flutter/flutter/pull/183650) [ios] Add opt-in inline prediction text input support**
    *   Authored by [Nikhil Bansal](https://github.com/nikb7) and reviewed by [LongCatIsLooong](https://github.com/LongCatIsLooong), [Loïc Sharma](https://github.com/loic-sharma).
    *   Adds opt-in support for iOS 17's inline predictive text, giving developers explicit control over how predictive text behaves in their apps. ✍️

#### Web

*   **[#182024](https://github.com/flutter/flutter/pull/182024) [web] Fix autofill in iOS 26 Safari**
    *   Authored by [Mouad Debbar](https://github.com/mdebbar) and reviewed by [Loïc Sharma](https://github.com/loic-sharma).
    *   Resolved autofill issues in iOS Safari by reusing forms and correctly re-establishing connections after focus changes. 🌐

#### Tooling and DX

*   **[#184518](https://github.com/flutter/flutter/pull/184518) [ Widget Preview ] Handle collections and records in custom preview annotations**
    *   Authored by [Ben Konyi](https://github.com/bkonyi) and reviewed by [Jessy Yameogo](https://github.com/jyameo).
    *   Widget Preview now correctly handles collections and records as annotation arguments, preventing crashes when these types are used in `@Preview` annotations. 🚀

*   **[#184473](https://github.com/flutter/flutter/pull/184473) [ Widget Preview ] Use analysis server for widget preview detection**
    *   Authored by [Ben Konyi](https://github.com/bkonyi) and reviewed by [Jessy Yameogo](https://github.com/jyameo).
    *   The widget previewer now utilizes the Dart Analysis Server for detecting previews, significantly reducing memory consumption and improving performance when used in IDEs. ⚡️

*   **[#183785](https://github.com/flutter/flutter/pull/183785) [ Tool ] Migrate `flutter analyze` to use LSP**
    *   Authored by [Ben Konyi](https://github.com/bkonyi) and reviewed by [Brian Wilkerson](https://github.com/bwilkerson).
    *   The `flutter analyze` command has been migrated to use the Language Server Protocol (LSP), ensuring more consistent and efficient analysis. 🔍

*   **[#183668](https://github.com/flutter/flutter/pull/183668) Add plugin version to SwiftPM package symlink directory**
    *   Authored by [Victoria Ashworth](https://github.com/vashworth) and reviewed by [stuartmorgan-g](https://github.com/stuartmorgan-g).
    *   Ensures Xcode correctly re-caches SwiftPM manifests when plugin versions change by including the version in the symlink directory name. 🍎

*   **[#184495](https://github.com/flutter/flutter/pull/184495) Enable SPM by default on Stable**
    *   Authored by [Elijah Okoroh](https://github.com/okorohelijah) and reviewed by [Victoria Ashworth](https://github.com/vashworth).
    *   Swift Package Manager (SPM) is now enabled by default for all users on the stable channel, simplifying dependency management for iOS and macOS. 📦

*   **[#183747](https://github.com/flutter/flutter/pull/183747) Warn about slow SwiftPM downloads and centralize SwiftPM cache**
    *   Authored by [Victoria Ashworth](https://github.com/vashworth) and reviewed by [Ben Konyi](https://github.com/bkonyi).
    *   Improved developer experience for SwiftPM users with progress indicators during slow downloads and a centralized cache to speed up builds. 🏎️

*   **[#184219](https://github.com/flutter/flutter/pull/184219) Improve error message when `dart-define` content are not `base64 encoded` and add more test cases**
    *   Authored by [Mohellebi Abdessalem](https://github.com/mohellebi-abdessalem) and reviewed by [Ben Konyi](https://github.com/bkonyi).
    *   Developers will now receive much clearer and more helpful error messages when `dart-define` values are incorrectly formatted. 🛠️

#### Engine and Rendering

*   **[#184090](https://github.com/flutter/flutter/pull/184090) Adds uber sdf shader gradients with blend**
    *   Authored by [gaaclarke](https://github.com/gaaclarke) and reviewed by [Jim Graham](https://github.com/flar), [walley892](https://github.com/walley892).
    *   Advanced gradient rendering support in the new Impeller SDF renderer, enabling multi-pass gradient blending for complex shapes. 🎨

#### First-time Contributors

Welcome to our newest contributors!
- [Andrei Kabylin](https://github.com/sysint64), for [#182425](https://github.com/flutter/flutter/pull/182425), which adds bottom safe area padding to the licenses page.
- [Sana Ullah](https://github.com/Sanaullah49), for [#184193](https://github.com/flutter/flutter/pull/184193), which cleans up cross-imports in sliver tests.
- [saurabh-mirajkar](https://github.com/saurabh-mirajkar), for [#184104](https://github.com/flutter/flutter/pull/184104), which clarifies TabBar documentation.
- [xfce0](https://github.com/xfce0), for [#184517](https://github.com/flutter/flutter/pull/184517), which removes cross-imports from text input tests.
- [Nikhil Bansal](https://github.com/nikb7), for [#183650](https://github.com/flutter/flutter/pull/183650), which adds opt-in inline prediction text input support on iOS.
