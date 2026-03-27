### March 21, 2026 to March 27, 2026

A productive week for Flutter, featuring improved desktop startup smoothness, expanded Windows ARM64 support, significant tooling enhancements for artifact downloads and web development, and important accessibility fixes for both Web and Android. This week saw a total of 106 commits from 37 contributors.

#### Framework & Widgets

*   **[#183454](https://github.com/flutter/flutter/pull/183454) Show windows only after the first frame is ready**
    Ensures Flutter windows on desktop only become visible after the first frame is fully rendered, preventing a flash of uninitialized content during app startup. 🖼️
    *   Authored by [Kishan Rathore](https://github.com/rkishan516) and reviewed by [Robert Ancell](https://github.com/robert-ancell).

*   **[#183963](https://github.com/flutter/flutter/pull/183963) Migrate Material examples to use dot shorthand syntax**
    Updates many framework examples to utilize Dart's new dot shorthand syntax for improved readability and more concise code. ✨
    *   Authored by [Loïc Sharma](https://github.com/loic-sharma) and reviewed by [Justin McCandless](https://github.com/justinmc).

*   **[#184078](https://github.com/flutter/flutter/pull/184078) Pipe ScrollCacheExtent through more scroll views**
    Exposes the `cacheExtent` property on additional scrollable widgets like `ListView.custom` and `GridView.custom`, enabling more consistent performance tuning across the framework. 🏎️
    *   Authored by [chunhtai](https://github.com/chunhtai) and reviewed by [Loïc Sharma](https://github.com/loic-sharma).

*   **[#184083](https://github.com/flutter/flutter/pull/184083) Ensure SelectableRegion passes constraints to children unmodified**
    Fixes a bug where `SelectableRegion` on the web would cause children to shrink by incorrectly loosening layout constraints, ensuring consistent layout across platforms. 🕸️
    *   Authored by [Renzo Olivares](https://github.com/Renzo-Olivares) and reviewed by [navaronbracke](https://github.com/navaronbracke).

*   **[#183109](https://github.com/flutter/flutter/pull/183109) Add scrollPadding property to DropdownMenu**
    Adds `scrollPadding` to `DropdownMenu` to match `TextField` behavior, allowing developers to control the spacing around the menu when it scrolls into view, such as when the on-screen keyboard appears. ⌨️
    *   Authored by [Ishaq Hassan](https://github.com/ishaquehassan) and reviewed by [Qun Cheng](https://github.com/QuncCccccc), [Tong Mu](https://github.com/dkwingsmt).

*   **[#182991](https://github.com/flutter/flutter/pull/182991) Correctly dismiss Slider value indicators**
    Fixes a bug where custom Slider value indicators would remain visible after an interaction was completed. 🎚️
    *   Authored by [Tong Mu](https://github.com/dkwingsmt) and reviewed by [Qun Cheng](https://github.com/QuncCccccc), [navaronbracke](https://github.com/navaronbracke).

*   **[#181345](https://github.com/flutter/flutter/pull/181345) Mark IconData as final and mustBeConst**
    Enhances type safety and enables more effective icon tree shaking by enforcing that `IconData` instances are immutable and defined as constants. 🛡️
    *   Authored by [Daco Harkes](https://github.com/dacoharkes) and reviewed by [Kate Lovett](https://github.com/Piinks).

#### Engine & Performance

*   **[#184096](https://github.com/flutter/flutter/pull/184096) Optimize simple shape path logic in Impeller**
    Improves Impeller performance by moving simple shape path optimization logic earlier into the display list builder, reducing overhead during rendering. ⚡
    *   Authored by [b-luk](https://github.com/b-luk) and reviewed by [gaaclarke](https://github.com/gaaclarke), [flar](https://github.com/flar).

*   **[#184037](https://github.com/flutter/flutter/pull/184037) Fix Gaussian blur clipping with negative scales in Impeller**
    Resolves a rendering issue where Gaussian blurs could be incorrectly clipped when applying a negative scale (such as during a mirroring transformation). 🌫️
    *   Authored by [walley892](https://github.com/walley892) and reviewed by [gaaclarke](https://github.com/gaaclarke).
    ![Gaussian Blur Before](https://github.com/user-attachments/assets/ed26b264-a1b2-481e-aa54-9be6858b35f5)
    ![Gaussian Blur After](https://github.com/user-attachments/assets/2f8edf40-e4da-4833-88ca-1ff6180c25ac)

*   **[#184131](https://github.com/flutter/flutter/pull/184131) Use atomic writes for engine stamps**
    Prevents potential race conditions during the Flutter build process by ensuring engine stamps are written atomically to the file system. 🏗️
    *   Authored by [b055man](https://github.com/b055man) and reviewed by [Ben Konyi](https://github.com/bkonyi), [John "codefu" McDole](https://github.com/codefu).

#### Tooling & Platform

*   **[#183724](https://github.com/flutter/flutter/pull/183724) Filter out extension processes during LLDB attachment on iOS 17+**
    Fixes an issue where `flutter run` on iOS 17+ could hang by attempting to attach the debugger to an embedded extension (like WidgetKit) instead of the main application process. 📱
    *   Authored by [Silfalion](https://github.com/Silfalion) and reviewed by [hellohuanlin](https://github.com/hellohuanlin), [Elijah Okoroh](https://github.com/okorohelijah).

*   **[#176385](https://github.com/flutter/flutter/pull/176385) Restore Windows ARM64 support on beta and stable**
    Re-enables Windows ARM64 engine builds for the beta and stable channels, now that full ARM64 support is available in the stable Dart SDK. 💻
    *   Authored by [August](https://github.com/Gustl22) and reviewed by [Jason Simmons](https://github.com/jason-simmons), [John "codefu" McDole](https://github.com/codefu).

*   **[#182709](https://github.com/flutter/flutter/pull/182709) Add base-href support to flutter run for web**
    Simplifies development for web applications hosted in subfolders by bringing the `--base-href` flag to the `flutter run` command, matching the existing functionality in `flutter build web`. 🌐
    *   Authored by [Samuel Abada](https://github.com/Mastersam07) and reviewed by [Ben Konyi](https://github.com/bkonyi), [Mouad Debbar](https://github.com/mdebbar).

*   **[#182836](https://github.com/flutter/flutter/pull/182836) Add visual progress bar to artifact downloads**
    Introduces a much-requested visual progress bar, including download speed and ETA, when the Flutter tool downloads engine artifacts and other dependencies. 📥
    *   Authored by [Felipe Peter](https://github.com/Mr-Pepe) and reviewed by [Ben Konyi](https://github.com/bkonyi), [John "codefu" McDole](https://github.com/codefu).
    ![Artifact Download Progress Before](https://github.com/user-attachments/assets/f479b1b4-bb2b-4c90-bec4-125fba805270)
    ![Artifact Download Progress After](https://github.com/user-attachments/assets/99e08a23-df7f-4aa3-8945-40bc1be13e4a)

#### Accessibility

*   **[#183897](https://github.com/flutter/flutter/pull/183897) Correctly report ProgressBar class on Android**
    Ensures that Flutter's progress indicators are correctly identified as progress bars by Android TalkBack, providing a more accurate experience for users of assistive technology. ♿
    *   Authored by [Hannah Jin](https://github.com/hannah-hyj) and reviewed by [chunhtai](https://github.com/chunhtai).

#### First-time Contributors

Welcome to our newest contributor!

- [Silfalion](https://github.com/Silfalion), for [#183724](https://github.com/flutter/flutter/pull/183724), which ensures the debugger correctly attaches to the main app process on iOS 17+ when app extensions are present.
