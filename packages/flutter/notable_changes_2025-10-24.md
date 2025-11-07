### October 4, 2025 to October 24, 2025

A total of 278 changes were merged to the framework, engine, and packages last week.

The changes below are populated by a script that filters and selects notable changes from the past week. This is not an exhaustive list of all changes, but is instead a list of changes that are notable and interesting to the general Flutter developer community.

### Framework

- **[#176571](https://github.com/flutter/flutter/pull/176571) Add directional static members to AlignmentGeometry.**

The `AlignmentGeometry` class now includes static members for directional alignments, such as `topStart` and `bottomEnd`. This provides a more convenient way to specify directional alignments without having to directly use `AlignmentDirectional`.

Authored by [Kostia Sokolovskyi](https://github.com/ksokolovskyi) and reviewed by [Loïc Sharma](https://github.com/loic-sharma).

- **[#177019](https://github.com/flutter/flutter/pull/177019) Move child parameter to end of RefreshIndicator constructor.**

The `child` parameter in the `RefreshIndicator` constructor has been moved to the end, following the convention for widget constructors. This improves code readability and consistency.

Authored by [Tymur](https://github.com/cuteUtya) and reviewed by [Victor Sanni](https://github.com/victorsanni) and [Tong Mu](https://github.com/dkwingsmt).

- **[#171796](https://github.com/flutter/flutter/pull/171796) [Material] Change default mouse cursor of buttons to basic arrow instead of click (except on web).**

The default mouse cursor for Material buttons on desktop platforms has been changed from a pointing hand to a standard arrow, aligning with native desktop UI conventions. The cursor remains a pointing hand on the web to match web standards.

Authored by [Camille Simon](https://github.com/camsim99) and reviewed by [Tong Mu](https://github.com/dkwingsmt).

### Engine

- **[#177343](https://github.com/flutter/flutter/pull/177343) [web] Use SkPathBuilder because SkPath is becoming immutable.**

The web engine now uses `SkPathBuilder` to construct paths, in preparation for `SkPath` becoming an immutable object. This change improves performance and reduces memory usage by avoiding unnecessary path copies.

Authored by [Mouad Debbar](https://github.com/mdebbar) and reviewed by [Jackson Gardner](https://github.com/eyebrowsoffire).

- **[#176974](https://github.com/flutter/flutter/pull/176974) Implements engine-side declarative pointer event handling for semantics.**

A new `SemanticsHitTestBehavior` enum has been introduced, allowing developers to explicitly control how semantic nodes behave during hit testing. This provides finer-grained control over which widgets can be targeted by pointer events, which is particularly useful for web to manage the `pointer-events` CSS property for accessibility.

Authored by [zhongliugo](https://github.com/flutter-zl) and reviewed by [chunhtai](https://github.com/chunhtai).

- **[#176361](https://github.com/flutter/flutter/pull/176361) [macOS] Implement regular window.**

Initial support for creating regular windows on macOS has been implemented. This is a foundational step towards enabling multi-window applications on desktop platforms, allowing developers to create more complex and native-like experiences.

Authored by [Matej Knopp](https://github.com/knopp) and reviewed by [Matthew Kosarek](https://github.com/mattkae).

### Tooling

- **[#177198](https://github.com/flutter/flutter/pull/177198) Allow empty dart defines in `flutter assemble`.**

The `flutter assemble` command now correctly handles empty `--dart-define` arguments, preventing crashes and improving the reliability of build scripts that may pass empty values.

Authored by [LongCatIsLooong](https://github.com/LongCatIsLooong) and reviewed by [Victoria Ashworth](https://github.com/vashworth) and [Ben Konyi](https://github.com/bkonyi).

### First-time Contributors

Welcome to our new contributors!

- [alexskobozev](https://github.com/alexskobozev), for [#175501](https://github.com/flutter/flutter/pull/175501), which fixes a deprecated API for fullscreen experiences on Android 15+.
- [André](https://github.com/leuchte), for [#177078](https://github.com/flutter/flutter/pull/177078), which fixes a typo in the `ButtonBar` documentation.
- [emakar](https://github.com/emakar), for [#171157](https://github.com/flutter/flutter/pull/171157), which prevents the bottom sheet from breaking its snap physics.
- [John Lilly](https://github.com/jwlilly), for [#174374](https://github.com/flutter/flutter/pull/174374), which fixes an issue where TalkBack would not announce list information.
- [kazbeksultanov](https://github.com/kazbeksultanov), for [#176010](https://github.com/flutter/flutter/pull/176010), which converts the `Title` widget to a `StatefulWidget`.
- [progamax](https://github.com/progamax), for [#174497](https://github.com/flutter/flutter/pull/174497), which adds a `textfield` property to `SearchAnchor`.
- [TDuffinNTU](https://github.com/TDuffinNTU), for [#176438](https://github.com/flutter/flutter/pull/176438), which fixes a typo in `pages.dart`.
- [cuteUtya](https://github.com/cuteUtya), for [#177019](https://github.com/flutter/flutter/pull/177019), which moves the child parameter to the end of the `RefreshIndicator` constructor.
