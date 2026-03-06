### February 27, 2026 to March 06, 2026

This week saw **116** commits land in the Flutter repository, bringing us closer to the upcoming **3.42.0** release. Highlights include major performance improvements for large pinned tables, native desktop windowing for dialogs, and the activation of Swift Package Manager by default on master and beta channels. We also welcomed five first-time contributors to the project!

#### Framework

*   **[#181861](https://github.com/flutter/flutter/pull/181861) Native desktop windowing for dialogs**
    A new `useWindowing` flag in `MaterialApp` enables `showDialog` to open content in a separate, native desktop window on supported platforms, providing a more platform-integrated experience. 🪟
    ![Native Windowing Dialog](https://github.com/user-attachments/assets/54315175-2091-4508-a61f-337b35ef35e8)
    *   Authored by [Matthew Kosarek](https://github.com/mattkae) and reviewed by [Justin McCandless](https://github.com/justinmc), [Loïc Sharma](https://github.com/loic-sharma).

*   **[#180563](https://github.com/flutter/flutter/pull/180563) Performance boost for large pinned tables**
    Scrolling in `TableView` with pinned rows or columns is now significantly smoother thanks to an optimized layout logic that only processes visible children. ⚡
    <video src="https://github.com/user-attachments/assets/7a6cddf2-04bf-465d-9997-3fdcab5692f7" controls></video>
    *   Authored by [SakuraMomoko](https://github.com/wangfeihang) and reviewed by [Kate Lovett](https://github.com/Piinks), [Renzo Olivares](https://github.com/Renzo-Olivares).

*   **[#181326](https://github.com/flutter/flutter/pull/181326) Display corner radii support for predictive back**
    Predictive back transitions on Android 12+ now respect the device's actual display corner radii, ensuring a seamless and modern feel during navigation. 📱
    *   Authored by [Kostia Sokolovskyi](https://github.com/ksokolovskyi) and reviewed by [Justin McCandless](https://github.com/justinmc), [Navaron Bracke](https://github.com/navaronbracke).

*   **[#180753](https://github.com/flutter/flutter/pull/180753) Improved focus highlight mode on Android**
    Flutter now correctly identifies key events from Android software keyboards, preventing them from incorrectly triggering traditional focus highlights and preserving the touch-first UX. ⌨️
    *   Authored by [romain.gyh](https://github.com/romaingyh) and reviewed by [Renzo Olivares](https://github.com/Renzo-Olivares), [Loïc Sharma](https://github.com/loic-sharma).

*   **[#181795](https://github.com/flutter/flutter/pull/181795) Fixed semantics identifier absorption**
    `Text.semanticsIdentifier` is now correctly isolated in its own semantic node, preventing it from being absorbed by ancestor nodes and improving the reliability of accessibility testing. 🔍
    *   Authored by [zhongliugo](https://github.com/zhongliugo) and reviewed by [chunhtai](https://github.com/chunhtai).

*   **[#182331](https://github.com/flutter/flutter/pull/182331) Optimized Scaffold FAB animations**
    A targeted refactor in `Scaffold` reduces unnecessary work during Floating Action Button transitions, improving performance during common layout animations. 🚀
    *   Authored by [Nate Wilson](https://github.com/nate-thegrate) and reviewed by [Tong Mu](https://github.com/dkwingsmt), [Justin McCandless](https://github.com/justinmc).

#### API & Architecture

*   **[#182934](https://github.com/flutter/flutter/pull/182934) Mixed color space support in Color.lerp**
    Interpolating between colors in different spaces (like sRGB and Display P3) now automatically converts to the wider gamut, ensuring accurate and vibrant color transitions. 🎨
    *   Authored by [Lukas Klingsbo](https://github.com/spydon) and reviewed by [gaaclarke](https://github.com/gaaclarke), [Tong Mu](https://github.com/dkwingsmt).

*   **[#182791](https://github.com/flutter/flutter/pull/182791) New VM services for accessibility evaluation**
    Added new VM service extensions that allow developers to trigger automated accessibility audits, paving the way for better integrated A11y testing tools. ♿
    *   Authored by [chunhtai](https://github.com/chunhtai) and reviewed by [Ben Konyi](https://github.com/bkonyi).

*   **[#182847](https://github.com/flutter/flutter/pull/182847) Float32 support for Image.toByteData**
    High-precision image data can now be exported in float32 format in the Impeller backend, enabling advanced rendering and compute workflows that require high dynamic range. 🖼️
    *   Authored by [gaaclarke](https://github.com/gaaclarke) and reviewed by [b-luk](https://github.com/b-luk), [Jim Graham](https://github.com/flar).

#### Platform & Tooling

*   **[#165323](https://github.com/flutter/flutter/pull/165323) Stylus support on Windows**
    Windows applications now correctly identify and handle stylus input as a distinct device kind, supporting pressure sensitivity and other stylus-specific data. 🖊️
    ![Stylus Support Demo](https://github.com/user-attachments/assets/e8b75f96-2334-45e9-be23-753f1565a246)
    *   Authored by [CodeDoctor](https://github.com/CodeDoctorDE) and reviewed by [Matthew Kosarek](https://github.com/mattkae), [Loïc Sharma](https://github.com/loic-sharma).

*   **[#182923](https://github.com/flutter/flutter/pull/182923) SwiftPM enabled by default**
    Swift Package Manager is now the default dependency manager for iOS and macOS projects on the master and beta channels, simplifying the plugin ecosystem. 📦
    *   Authored by [Victoria Ashworth](https://github.com/vashworth) and reviewed by [stuartmorgan-g](https://github.com/stuartmorgan-g).

*   **[#182506](https://github.com/flutter/flutter/pull/182506), [#182394](https://github.com/flutter/flutter/pull/182394), [#182375](https://github.com/flutter/flutter/pull/182375) Enhanced SwiftPM migration guidance**
    New warnings and detailed diagnostic messages provide clear, actionable steps for developers when plugins or projects require migration to Swift Package Manager. 🛠️
    *   Authored by [Victoria Ashworth](https://github.com/vashworth), [Nour](https://github.com/MohammedTarigg) and reviewed by [hellohuanlin](https://github.com/hellohuanlin), [Elijah Okoroh](https://github.com/okorohelijah).

*   **[#182826](https://github.com/flutter/flutter/pull/182826) UIScene migration warnings for iOS plugins**
    The engine now warns developers when iOS plugins have not yet migrated to the modern `UIScene` lifecycle, ensuring better long-term platform compatibility. 🍎
    *   Authored by [Elijah Okoroh](https://github.com/okorohelijah) and reviewed by [hellohuanlin](https://github.com/hellohuanlin).

*   **[#183187](https://github.com/flutter/flutter/pull/183187) Fixed perspective shadows in Impeller**
    Convex path shadows now render correctly under perspective transformations in the Impeller backend, fixing long-standing visual artifacts. ✨
    *   Authored by [Jim Graham](https://github.com/flar) and reviewed by [gaaclarke](https://github.com/gaaclarke).

*   **[#181402](https://github.com/flutter/flutter/pull/181402) New diagnostic for invisible ink splashes**
    A new debug-mode assertion warns developers when a `ListTile` is wrapped in a way that would hide its background or ink splash effects, preventing silent UI issues. ⚠️
    *   Authored by [Qun Cheng](https://github.com/QuncCccccc) and reviewed by [Tong Mu](https://github.com/dkwingsmt).

#### First-time Contributors

Welcome to the Flutter community! We’re thrilled to have your first contributions land this week:

- [GyuBin Hwang](https://github.com/SpiralMomentum), for [#183070](https://github.com/flutter/flutter/pull/183070), which unifies `maskValue` for `TextDecoration` and makes the class final.
- [Ishaq Hassan](https://github.com/ishaquehassan), for [#183081](https://github.com/flutter/flutter/pull/183081), which ensures double quotes are used in the `settings.gradle.kts` template for better compatibility.
- [SakuraMomoko](https://github.com/wangfeihang), for [#180563](https://github.com/flutter/flutter/pull/180563), which fixes a significant performance jank in `TableView` when using pinned rows or columns.
- [CodeDoctor](https://github.com/CodeDoctorDE), for [#165323](https://github.com/flutter/flutter/pull/165323), which introduces native stylus support for Windows applications.
- [Nick Fisher](https://github.com/nmfisher), for [#182999](https://github.com/flutter/flutter/pull/182999), which cleans up documentation headers for Linux texture management.
