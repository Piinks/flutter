### February 21, 2026 to February 27, 2026

This week saw 182 changes land in the Flutter repository, including several highly requested features and developer experience improvements that are expected to be part of the upcoming 3.34.0 release. We are especially excited to welcome 11 first-time contributors to the project!

#### Framework

*   **[#181795](https://github.com/flutter/flutter/pull/181795) Fix Text.semanticsIdentifier being absorbed by ancestor nodes**
    *   Authored by [zhongliugo](https://github.com/zhongliugo) and reviewed by [Chun-Heng Tai](https://github.com/chunhtai).
    *   Ensures `Text` widgets with a `semanticsIdentifier` create their own semantic element instead of being absorbed by ancestors like `Dialog`, improving accessibility auditing.
*   **[#182731](https://github.com/flutter/flutter/pull/182731) New `SizedBox.square()` constructor**
    *   Authored by [Nate Wilson](https://github.com/nate-thegrate) and reviewed by [Loïc Sharma](https://github.com/loic-sharma), [Victor Sanni](https://github.com/victorsanni).
    *   Adds a convenient `SizedBox.square()` constructor for creating square boxes with a single `dimension` parameter. 📐
*   **[#182499](https://github.com/flutter/flutter/pull/182499) Fix StretchingOverscrollIndicator crash**
    *   Authored by [Ahmed Mohamed Sameh](https://github.com/ahmedsameha1) and reviewed by [Kate Lovett](https://github.com/Piinks), [Victor Sanni](https://github.com/victorsanni).
    *   Prevents a crash in `StretchingOverscrollIndicator` when it is disposed or used in a zero-size environment.

#### Material

*   **[#182785](https://github.com/flutter/flutter/pull/182785) Fix RawAutocomplete crash**
    *   Authored by [Bruno Corona](https://github.com/mbcorona) and reviewed by [Victor Sanni](https://github.com/victorsanni).
    *   Fixes an assertion crash in `RawAutocomplete` that occurred when attempting to hide an options view that was already hidden.
*   **[#180975](https://github.com/flutter/flutter/pull/180975) MenuAnchor software keyboard awareness**
    *   Authored by [Patrick Billingsley](https://github.com/patrickBillingsley) and reviewed by [LongCatIsLooong](https://github.com/LongCatIsLooong), [Victor Sanni](https://github.com/victorsanni).
    *   Updates `MenuAnchor` to respect software keyboard constraints, ensuring menus are not obscured by the keyboard. ⌨️
    <video src="https://github.com/user-attachments/assets/732bb071-e368-4c6a-89ba-ba4183ea601a" controls></video>
*   **[#181238](https://github.com/flutter/flutter/pull/181238) ExpansionTile WidgetStatesController support**
    *   Authored by [Vikash Tiwari](https://github.com/iamvikashtiwari) and reviewed by [Qun Cheng](https://github.com/QuncCccccc), [Justin McCandless](https://github.com/justinmc).
    *   Adds `WidgetStatesController` support to `ExpansionTile`, allowing developers to listen to and control its interactive states.
*   **[#181403](https://github.com/flutter/flutter/pull/181403) AnimationStyle support in ModalBottomSheet**
    *   Authored by [Mairramer](https://github.com/Mairramer) and reviewed by [Chun-Heng Tai](https://github.com/chunhtai), [Tong Mu](https://github.com/dkwingsmt), [Victor Sanni](https://github.com/victorsanni).
    *   Allows customizing `ModalBottomSheet` entrance and exit animations using `AnimationStyle`.
*   **[#182475](https://github.com/flutter/flutter/pull/182475) Carousel migration to CustomScrollView**
    *   Authored by [Mairramer](https://github.com/Mairramer) and reviewed by [Kate Lovett](https://github.com/Piinks), [Qun Cheng](https://github.com/QuncCccccc).
    *   Migrates the Material `CarouselView` to use `CustomScrollView` under the hood, enabling better integration with other slivers.

#### Impeller & Graphics

*   **[#182847](https://github.com/flutter/flutter/pull/182847) Adds float32 output to Image.toByteData()**
    *   Authored by [gaaclarke](https://github.com/gaaclarke) and reviewed by [b-luk](https://github.com/b-luk), [Jim Graham](https://github.com/flar).
    *   Adds support for exporting image data as `float32` in `Image.toByteData()`, enabling higher precision image processing.
*   **[#182224](https://github.com/flutter/flutter/pull/182224) [Impeller] Bilinear filtering for non-uniformly scaled text**
    *   Authored by [Serhat Güler](https://github.com/sero583) and reviewed by [gaaclarke](https://github.com/gaaclarke), [John "codefu" McDole](https://github.com/jtmcdole).
    *   Improves text quality in Impeller by using bilinear filtering for text with non-uniform scales, eliminating jagged edges. ✨
    ![Bilinear filtering comparison](https://github.com/user-attachments/assets/3cfa5cfa-4f6e-4dd2-9b22-7e21e269ae4d)
*   **[#181206](https://github.com/flutter/flutter/pull/181206) Paint paragraphs as a single image in Impeller**
    *   Authored by [Rusino](https://github.com/Rusino) and reviewed by [Mouad Debbar](https://github.com/mdebbar).
    *   Optimizes text rendering in Impeller by painting paragraphs as a single image where appropriate, improving performance. 🚀

#### Tooling & Platforms

*   **[#182786](https://github.com/flutter/flutter/pull/182786) Improved Impeller shader compilation error reporting**
    *   Authored by [b-luk](https://github.com/b-luk) and reviewed by [Jim Graham](https://github.com/flar), [John "codefu" McDole](https://github.com/codefu).
    *   Truncates long shader compilation errors in the console and saves the full output to a file, making it easier to debug complex shader issues.
*   **[#182913](https://github.com/flutter/flutter/pull/182913) Xcode 26 compatibility improvements**
    *   Authored by [Gray Mackall](https://github.com/gmackall) and reviewed by [Matthew Kosarek](https://github.com/mattkae).
    *   Adds warnings and excludes `arm64` if dependencies require it when using Xcode 26, ensuring smoother builds on the latest Apple tools.
*   **[#182301](https://github.com/flutter/flutter/pull/182301) Fix future warnings in async try-catch blocks**
    *   Authored by [b-luk](https://github.com/b-luk) and reviewed by [Jim Graham](https://github.com/flar).
    *   Resolves a lint warning when `await`ing `Future` returns inside `async` bodies within `try` blocks.
*   **[#180692](https://github.com/flutter/flutter/pull/180692) Improved web key event synthesis**
    *   Authored by [Harry Terkelsen](https://github.com/harryterkelsen) and reviewed by [Mouad Debbar](https://github.com/mdebbar).
    *   Fixes an issue where the web embedder was synthesizing key-up events too eagerly, leading to inconsistent keyboard behavior.
*   **[#182362](https://github.com/flutter/flutter/pull/182362) Fix delegate copy on plugins initialization**
    *   Authored by [eMxPi](https://github.com/eMxPi) and reviewed by [LouiseHsu](https://github.com/LouiseHsu), [Victoria Ashworth](https://github.com/vashworth).
    *   Ensures plugin initialization correctly handles delegate copying, preventing potential crashes or misbehavior during app startup.
*   **[#182924](https://github.com/flutter/flutter/pull/182924) New Linux view sizing API**
    *   Authored by [Robert Ancell](https://github.com/robert-ancell) and reviewed by [Matthew Kosarek](https://github.com/mattkae).
    *   Introduces `fl_view_new_sized_to_content()` for Linux, allowing views to automatically size themselves based on Flutter's content.
*   **[#181808](https://github.com/flutter/flutter/pull/181808) Progress indicator for artifact downloads**
    *   Authored by [Felipe Peter](https://github.com/Mr-Pepe) and reviewed by [Ben Konyi](https://github.com/bkonyi), [John "codefu" McDole](https://github.com/jtmcdole).
    *   Adds a helpful progress indicator to `flutter precache`, showing exactly what's being downloaded and how much is left. 📦

#### First-time Contributors

A big welcome to our newest contributors!

- [Alexander Dmitriev](https://github.com/BrainLUX), for [#182093](https://github.com/flutter/flutter/pull/182093), which clarifies the `positionInlineChildren` assertion.
- [Aditya Rathore](https://github.com/itsAdityaRathore), for [#182584](https://github.com/flutter/flutter/pull/182584), which fixes typos in method names.
- [Bruno Corona](https://github.com/mbcorona), for [#182785](https://github.com/flutter/flutter/pull/182785), which fixes a `RawAutocomplete` crash.
- [Emma Twersky](https://github.com/twerske), for [#182798](https://github.com/flutter/flutter/pull/182798), which updates the 2026 roadmap.
- [eMxPi](https://github.com/eMxPi), for [#182362](https://github.com/flutter/flutter/pull/182362), which fixes delegate copy on plugins initialization.
- [Jhonathan C. Queiroz](https://github.com/jhonathanqz), for [#182684](https://github.com/flutter/flutter/pull/182684), which renames a minification flag for clarity.
- [Maik Wild](https://github.com/Valansch), for [#181716](https://github.com/flutter/flutter/pull/181716), which fixes a textscaler clamp assertion error.
- [serbandin](https://github.com/serbandin), for [#181931](https://github.com/flutter/flutter/pull/181931), which fixes a Huawei ImageReader issue.
- [Serhat Güler](https://github.com/sero583), for [#182224](https://github.com/flutter/flutter/pull/182224), which improves text rendering in Impeller.
- [Vikash Tiwari](https://github.com/iamvikashtiwari), for [#181238](https://github.com/flutter/flutter/pull/181238), which adds `WidgetStatesController` support to `ExpansionTile`.
- [xiaowei guan](https://github.com/xiaowei-guan), for [#181656](https://github.com/flutter/flutter/pull/181656), which fixes a Linux rendering issue in Impeller.
