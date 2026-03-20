### March 14, 2026 to March 20, 2026

This week, the Flutter community landed 129 changes, moving us toward the upcoming 3.44.0 release. We are thrilled to welcome 7 first-time contributors! This week's highlights include significant accessibility improvements, more flexible desktop windowing, and a smoother developer experience across all platforms.

### Framework & Widgets
- **[#183302](https://github.com/flutter/flutter/pull/183302) Improved web scrolling reliability**
  Web scrolling is now more reliable and less likely to "swallow" events, ensuring that pointer signals are only handled when necessary and allowing the browser to perform default actions. 🖱️
  *   Authored by [Onnimanni Hannonen](https://github.com/O-Hannonen) and reviewed by [Kate Lovett](https://github.com/Piinks), [Mohellebi Abdessalem](https://github.com/AbdeMohlbi).
- **[#183074](https://github.com/flutter/flutter/pull/183074) Enhanced code consistency with const BorderRadius**
  App performance and code consistency get a boost by favoring `const BorderRadius.all` over `BorderRadius.circular`, enabling more widespread use of constant constructors. 📐
  *   Authored by [Alexander Dmitriev](https://github.com/BrainLUX) and reviewed by [Tong Mu](https://github.com/dkwingsmt), [Kate Lovett](https://github.com/Piinks).
- **[#183303](https://github.com/flutter/flutter/pull/183303) Smoother bottom sheet animations**
  Bottom sheets now animate more smoothly even when interrupted by user interaction, fixing a visual glitch during transitions. 📉
  *   Authored by [Mairramer](https://github.com/Mairramer) and reviewed by [Victor Sanni](https://github.com/victorsanni), [Tong Mu](https://github.com/dkwingsmt).
- **[#183514](https://github.com/flutter/flutter/pull/183514) Flexible NavigationRail alignment**
  `NavigationRail` is now more flexible on large screens, allowing developers to customize how destinations are distributed vertically using standard `MainAxisAlignment`. 📏
  *   Authored by [Bruno Corona](https://github.com/mbcorona) and reviewed by [Kate Lovett](https://github.com/Piinks).
  ![NavigationRail_Default](https://github.com/user-attachments/assets/184d0574-a6a6-4f28-add0-a1b9f07de7b0)
  ![NavigationRail_SpaceEvenly](https://github.com/user-attachments/assets/744ddf9f-8ada-4539-b45f-ac0e02a2eb61)

### Accessibility
- **[#183569](https://github.com/flutter/flutter/pull/183569) Non-text color contrast evaluation**
  Developers can now automatically verify that non-text controls, like icons and buttons, meet accessibility color contrast standards with a new evaluation tool. 🎨
  *   Authored by [Qun Cheng](https://github.com/QuncCccccc) and reviewed by [chunhtai](https://github.com/chunhtai).
- **[#183475](https://github.com/flutter/flutter/pull/183475) Accurate semantics for popup and dropdown menus**
  Accessibility for screen reader users is improved by ensuring that the "expanded" state of popup and dropdown menus is correctly updated and announced. 🔊
  *   Authored by [Ahmed Elsayed](https://github.com/AhmedLSayed9) and reviewed by [Qun Cheng](https://github.com/QuncCccccc), [Hannah Jin](https://github.com/hannah-hyj).

### Tooling & Platform
- **[#179859](https://github.com/flutter/flutter/pull/179859) Undecorated desktop windows**
  Desktop developers can now create undecorated windows, enabling more flexible and custom UI designs where Flutter renders all window decorations. 🖼️
  *   Authored by [Robert Ancell](https://github.com/robert-ancell) and reviewed by [Matthew Kosarek](https://github.com/mattkae).
- **[#180789](https://github.com/flutter/flutter/pull/180789) Widget Inspector safe area respect**
  The Widget Inspector now correctly respects system safe area insets, ensuring that control buttons remain accessible and visible on devices with notches or gesture navigation. 🛡️
  *   Authored by [Gautam Tirkha](https://github.com/gktirkha) and reviewed by [Kate Lovett](https://github.com/Piinks).
  ![Inspector Before](https://github.com/user-attachments/assets/d4f6c193-75a2-4c55-9a80-9a60e5e58f0c)
  ![Inspector After](https://github.com/user-attachments/assets/8fe9f5e3-8c2a-4eec-9a14-6e2dbb19a5c4)
- **[#183856](https://github.com/flutter/flutter/pull/183856) & [#183849](https://github.com/flutter/flutter/pull/183849) Modern Android Gradle Plugin DSL migration**
  Android builds are more future-proof as the Flutter tool has migrated profile build type creation and ProGuard configuration to the modern Android Gradle Plugin DSL. 🤖
  *   Authored by [Gray Mackall](https://github.com/gmackall) and reviewed by [Reid Baker](https://github.com/reidbaker).
- **[#182246](https://github.com/flutter/flutter/pull/182246) Swift Package Manager compatibility prompts**
  Plugin authors will now receive helpful prompts to ensure their plugins are compatible with Swift Package Manager, streamlining dependency management for iOS and macOS. 📦
  *   Authored by [Elijah Okoroh](https://github.com/okorohelijah) and reviewed by [Victoria Ashworth](https://github.com/vashworth).
- **[#182753](https://github.com/flutter/flutter/pull/182753) Inter-plugin communication on Android and iOS**
  Native plugin development is now more powerful as plugins can now easily communicate and access registered instances of other plugins on both Android and iOS. 🔗
  *   Authored by [Jeff Ward](https://github.com/fuzzybinary) and reviewed by [Gray Mackall](https://github.com/gmackall), [Reid Baker](https://github.com/reidbaker).
- **[#183399](https://github.com/flutter/flutter/pull/183399) Automatic codesign for iOS XCFrameworks**
  Integrating Flutter into existing iOS apps is now easier and more secure with automatic code-signing for XCFrameworks, meeting modern Apple privacy requirements. 🔐
  *   Authored by [Victoria Ashworth](https://github.com/vashworth) and reviewed by [stuartmorgan-g](https://github.com/stuartmorgan-g).
- **[#183274](https://github.com/flutter/flutter/pull/183274) Improved AdMob stability on iOS 18.2**
  iOS developers using AdMob will see improved scrolling performance and stability in lists on iOS 18.2 thanks to refined WebView detection. 📱
  *   Authored by [hellohuanlin](https://github.com/hellohuanlin) and reviewed by [Victoria Ashworth](https://github.com/vashworth).
- **[#183715](https://github.com/flutter/flutter/pull/183715) Dedicated platform OpenGL context for Linux**
  Multi-window support on Linux is now more robust with the addition of a dedicated platform OpenGL context, preventing shader compilation failures. 🐧
  *   Authored by [Robert Ancell](https://github.com/robert-ancell) and reviewed by [Matthew Kosarek](https://github.com/mattkae).

### Engine & Graphics
- **[#183807](https://github.com/flutter/flutter/pull/183807) Web MSAA support in Impeller**
  Graphics on the web take a leap forward with new MSAA (Multi-Sample Anti-Aliasing) support in Impeller, resulting in smoother edges and reduced aliasing. ✨
  *   Authored by [Jackson Gardner](https://github.com/jacksongardner) and reviewed by [gaaclarke](https://github.com/gaaclarke).
- **[#182326](https://github.com/flutter/flutter/pull/182326) Android content sizing stability**
  Android users will experience fewer visual glitches and better stability thanks to a fix for a race condition during surface resizing and viewport metric updates. 🏎️
  *   Authored by [Matt Boetger](https://github.com/mboetger) and reviewed by [Gray Mackall](https://github.com/gmackall).

### First-time Contributors
Welcome to our newest contributors! We're excited to have you as part of the Flutter community.
- [algor](https://github.com/algor), for [#183680](https://github.com/flutter/flutter/pull/183680), which fixed the URL for the Flutter System Overview diagram.
- [Gautam Tirkha](https://github.com/gktirkha), for [#180789](https://github.com/flutter/flutter/pull/180789), which improved the Widget Inspector control layout to respect system safe area insets.
- [Mayank Sharma](https://github.com/mayanksharma9), for [#183351](https://github.com/flutter/flutter/pull/183351), which reduced cross-library coupling in the test suite.
- [Naman Goyal](https://github.com/NamanGoyalK), for [#183375](https://github.com/flutter/flutter/pull/183375), which improved the developer experience for `flutter downgrade`.
- [Sanket Patil](https://github.com/sanketudaypatil), for [#183061](https://github.com/flutter/flutter/pull/183061), which enhanced the clarity and formatting of issue templates.
- [Eyas](https://github.com/Eyas), for [#176881](https://github.com/flutter/flutter/pull/176881), which improved integration test reliability on Windows hosts.
- [Kevin Lamenzo](https://github.com/lamek), for [#182778](https://github.com/flutter/flutter/pull/182778), which added valuable guidance for community code reviewers.
