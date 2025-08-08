### August 02, 2025 to August 08, 2025

A summary of 97 changes landed in the Flutter framework repository this week.

This week’s notable changes will be included in Flutter version 3.34.0.

### Framework

- **[#172914](https://github.com/flutter/flutter/pull/172914) Fix ScaffoldGeometry null scale with noAnimation FAB**
  A bug that caused a null scale with noAnimation FAB in ScaffoldGeometry has been fixed, ensuring proper scaling behavior. 🐛
  *   Authored by [Mairramer](https://github.com/Mairramer) and reviewed by [Tong Mu](https://github.com/dkwingsmt) and [Kate Lovett](https://github.com/Piinks).

- **[#172380](https://github.com/flutter/flutter/pull/172380) Fix ReorderableList proxy animation for partial drag-back**
  The proxy animation for partial drag-back in ReorderableList has been fixed, providing a smoother user experience. ✨
  *   Authored by [Luke Memet](https://github.com/lukemmtt) and reviewed by [Kate Lovett](https://github.com/Piinks) and [Victor Sanni](https://github.com/victorsanni).

- **[#173280](https://github.com/flutter/flutter/pull/173280) Fix drawerScrimColor transition.**
  The transition for drawerScrimColor has been fixed, ensuring a seamless visual effect. 🎨
  *   Authored by [Kostia Sokolovskyi](https://github.com/ksokolovskyi) and reviewed by [Victor Sanni](https://github.com/victorsanni).

- **[#172759](https://github.com/flutter/flutter/pull/172759) Fix Slider dragged mouse cursor visibility.**
  The visibility of the mouse cursor when dragging a Slider has been fixed, improving usability. 👍
  *   Authored by [Kostia Sokolovskyi](https://github.com/ksokolovskyi) and reviewed by [Tong Mu](https://github.com/dkwingsmt).

- **[#173011](https://github.com/flutter/flutter/pull/173011) Migrate to list and builder Sliver convenience constructors**
  The codebase has been migrated to use the new list and builder Sliver convenience constructors, improving code readability and maintainability. 🛠️
  *   Authored by [Loïc Sharma](https://github.com/loic-sharma) and reviewed by [Kate Lovett](https://github.com/Piinks).

### Material

- **[#173312](https://github.com/flutter/flutter/pull/173312) [A11y] TextField prefix icon and suffix icon create a sibling node'**
  Accessibility for TextField has been improved by ensuring that prefix and suffix icons create a sibling node. ♿
  *   Authored by [Hannah Jin](https://github.com/hannah-hyj) and reviewed by [chunhtai](https://github.com/chunhtai).

### Web

- **[#172175](https://github.com/flutter/flutter/pull/172175) Web dev proxy**
  A new web dev proxy has been introduced, enhancing the development workflow for web applications. 🌐
  *   Authored by [Salem Iranloye](https://github.com/salemiranloye) and reviewed by [Mouad Debbar](https://github.com/mdebbar), [David Iglesias](https://github.com/ditman), and [Ben Konyi](https://github.com/bkonyi).

- **[#171638](https://github.com/flutter/flutter/pull/171638) [web] add --static-assets-url argument to build web**
  A new `--static-assets-url` argument has been added to the `build web` command, allowing for more flexible asset management. 🚀
  *   Authored by [Micael Cid](https://github.com/micaelcid) and reviewed by [Harry Terkelsen](https://github.com/harryterkelsen).

- **[#172254](https://github.com/flutter/flutter/pull/172254) Add radius clamping to web RSuperellipse**
  Radius clamping has been added to the web RSuperellipse, preventing rendering issues with large radius values. 🖼️
  *   Authored by [Tong Mu](https://github.com/dkwingsmt) and reviewed by [Jackson Gardner](https://github.com/eyebrowsoffire).

### Tool

- **[#173443](https://github.com/flutter/flutter/pull/173443) Use LLDB as the default debugging method for iOS 17+ and Xcode 26+**
  LLDB is now the default debugging method for iOS 17+ and Xcode 26+, providing a more robust debugging experience. 🛠️
  *   Authored by [Victoria Ashworth](https://github.com/vashworth) and reviewed by [Ben Konyi](https://github.com/bkonyi).

- **[#164720](https://github.com/flutter/flutter/pull/164720) Support launching a HTTPS URL**
  The tool now supports launching HTTPS URLs, expanding its capabilities. 🔗
  *   Authored by [Wdestroier](https://github.com/Wdestroier) and reviewed by [Ben Konyi](https://github.com/bkonyi) and [John "codefu" McDole](https://github.com/jtmcdole).

- **[#171965](https://github.com/flutter/flutter/pull/171965) [android][tool] Consolidate minimum versions for android projects.**
  The minimum versions for Android projects have been consolidated, streamlining project setup and maintenance. 
  *   Authored by [Reid Baker](https://github.com/reidbaker) and reviewed by [Ben Konyi](https://github.com/bkonyi) and [Matt Boetger](https://github.com/mboetger).

### Android

- **[#173431](https://github.com/flutter/flutter/pull/173431) [Android templates] Remove jetifier usage**
  Jetifier usage has been removed from the Android templates, aligning with modern Android development practices. 🤖
  *   Authored by [Reid Baker](https://github.com/reidbaker) and reviewed by [Gray Mackall](https://github.com/gmackall).

- **[#173375](https://github.com/flutter/flutter/pull/173375) Adds deprecation for impeller opt out on android**
  A deprecation notice has been added for opting out of Impeller on Android, encouraging adoption of the new rendering engine. 🎨
  *   Authored by [gaaclarke](https://github.com/gaaclarke) and reviewed by [Chinmay Garde](https://github.com/chinmaygarde) and [John "codefu" McDole](https://github.com/jtmcdole).

### Windows

- **[#164460](https://github.com/flutter/flutter/pull/164460) Provide monitor list, display size, refresh rate, and more for Windows**
  The Windows implementation now provides a monitor list, display size, refresh rate, and other display-related information, enhancing multi-monitor support. 🖥️
  *   Authored by [Jon Ihlas](https://github.com/9AZX) and reviewed by [Matthew Kosarek](https://github.com/mattkae) and [Matej Knopp](https://github.com/knopp).

### First-time Contributors

Congratulations to our new contributors:
- [Jon Ihlas](https://github.com/jon-i), for [#164460](https://github.com/flutter/flutter/pull/164460), which provides monitor list, display size, refresh rate, and more for Windows.
- [Luke Memet](https://github.com/lukemmtt), for [#172380](https://github.com/flutter/flutter/pull/172380), which fixes the ReorderableList proxy animation for partial drag-back.
- [Wdestroier](https://github.com/Wdestroier), for [#164720](https://github.com/flutter/flutter/pull/164720), which adds support for launching HTTPS URLs.