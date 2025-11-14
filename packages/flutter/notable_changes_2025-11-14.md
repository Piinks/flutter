### November 7, 2025 to November 14, 2025

_A special welcome to our 5 new contributors!_

This week’s 108 total changes will be included in Flutter version 3.39.0. From those, we have selected 16 notable changes.

### Framework

*   **[#176492](https://github.com/flutter/flutter/pull/176492) Pausable GIFs**
    A new feature that allows pausing and resuming GIF animations. This is useful for saving battery life and for giving users more control over animations. Authored by [Justin McCandless](https://github.com/justinmc) and reviewed by [chunhtai](https://github.com/chunhtai).
*   **[#173862](https://github.com/flutter/flutter/pull/173862) Granular frame forcing for animations**
    This change allows animations to be forced to a specific frame, which is useful for testing and debugging. Authored by [Thomas Guerin](https://github.com/tguerin) and reviewed by [Justin McCandless](https://github.com/justinmc) and [Loïc Sharma](https://github.com/loic-sharma).
*   **[#177966](https://github.com/flutter/flutter/pull/177966) Expansible animation properties migration**
    This refactoring migrates the animation properties of the `Expansible` widget to `AnimationStyle` for a less broad API surface. Authored by [Kishan Rathore](https://github.com/rkishan516) and reviewed by [Victor Sanni](https://github.com/victorsanni) and [Kate Lovett](https://github.com/Piinks).
*   **[#178219](https://github.com/flutter/flutter/pull/178219) Remove hack for `runtimeType` in `key.dart`**
    This change removes a hack used to get the `runtimeType` without using an additional class in `key.dart`. This simplifies the code and makes it more robust. Authored by [Mohellebi abdessalem](https://github.com/AbdeMohlbi) and reviewed by [Victor Sanni](https://github.com/victorsanni).
*   **[#167119](https://github.com/flutter/flutter/pull/167119) Add focus support for `CupertinoActionSheetAction`**
    This change adds focus support to the `CupertinoActionSheetAction` widget, making it more accessible. Authored by [Onnimanni Hannonen](https://github.com/O-Hannonen) and reviewed by [Justin McCandless](https://github.com/justinmc) and [chunhtai](https://github.com/chunhtai).
<video src="https://github.com/user-attachments/assets/ea6789f1-921d-4598-bcca-489dc063ff73" controls></video>
<video src="https://github.com/user-attachments/assets/4c6ae2a0-7205-4de2-b981-ec7f4839da6e" controls></video>

### Engine

*   **[#177959](https://github.com/flutter/flutter/pull/177959) Impeller: Allows R32G32B32A32_SFLOAT images**
    This change adds support for R32G32B32A32_SFLOAT images to the Impeller rendering engine, which is useful for HDR images. Authored by [gaaclarke](https://github.com/gaaclarke) and reviewed by [Chinmay Garde](https://github.com/chinmaygarde).
*   **[#177460](https://github.com/flutter/flutter/pull/177460) Fix zoom and subpixel shift**
    This change fixes a zooming issue and drops the subpixel shift, resulting in a smoother user experience. Authored by [Rusino](https://github.com/Rusino) and reviewed by [Mouad Debbar](https://github.com/mdebbar).

### Tooling

*   **[#178500](https://github.com/flutter/flutter/pull/178500) Better error message for widget preview**
    This change throws a `ToolExit` if Flutter Web is not enabled when using the widget preview tool, providing a better error message to the user. Authored by [Ben Konyi](https://github.com/bkonyi) and reviewed by [Jessy Yameogo](https://github.com/jyameo).
*   **[#178398](https://github.com/flutter/flutter/pull/178398) Ignore ephemeral directories in widget preview**
    This change ignores modifications to files in ephemeral directories in the widget preview tool, improving performance. Authored by [Ben Konyi](https://github.com/bkonyi) and reviewed by [Jessy Yameogo](https://github.com/jyameo).
*   **[#177852](https://github.com/flutter/flutter/pull/177852) Correct iOS signing log**
    This change corrects the iOS signing log for manual code signing, making it easier to debug signing issues. Authored by [Mohammed Tarig Nour](https://github.com/MohammedTarigg) and reviewed by [Victoria Ashworth](https://github.com/vashworth) and [LouiseHsu](https://github.com/LouiseHsu).

### Platform

*   **[#177817](https://github.com/flutter/flutter/pull/177817) Implement dialog windows for Linux**
    This change implements dialog windows for the Linux platform, bringing it closer to feature parity with other platforms. Authored by [Robert Ancell](https://github.com/robert-ancell) and reviewed by [Matthew Kosarek](https://github.com/mattkae).
*   **[#178309](https://github.com/flutter/flutter/pull/178309) API to customize semantics placeholder message on web**
    This change adds an API to customize the semantics placeholder message on the web, improving accessibility. Authored by [Mouad Debbar](https://github.com/mdebbar) and reviewed by [Yegor](https://github.com/yjbanov).
*   **[#173993](https://github.com/flutter/flutter/pull/173993) Migrate plugin templates to Kotlin DSL**
    This change migrates the plugin templates to the Kotlin DSL, which is the recommended way to write Gradle build scripts. Authored by [Byoungchan Lee](https://github.com/bc-lee) and reviewed by [Gray Mackall](https://github.com/gmackall) and [Reid Baker](https://github.com/reidbaker).
*   **[#176393](https://github.com/flutter/flutter/pull/176393) Platform-specific asset filtering**
    This change adds support for platform-specific asset filtering in `pubspec.yaml`, allowing developers to include assets only for specific platforms. Authored by [Alex Frei](https://github.com/hm21) and reviewed by [Ben Konyi](https://github.com/bkonyi) and [Lau Ching Jun](https://github.com/chingjun).
*   **[#178081](https://github.com/flutter/flutter/pull/178081) Listen to text spacing overrides on the web**
    This change makes the web engine listen to text spacing overrides, improving the text rendering on the web. Authored by [Renzo Olivares](https://github.com/Renzo-Olivares) and reviewed by [Mouad Debbar](https://github.com/mdebbar), [LongCatIsLooong](https://github.com/LongCatIsLooong), and [Loïc Sharma](https://github.com/loic-sharma).
<video src="https://github.com/user-attachments/assets/aaaa3e74-c232-4956-acd2-ae1a4487e415" controls></video>

### First-time Contributors

- [Alex Frei](https://github.com/hm21), for [#176393](https://github.com/flutter/flutter/pull/176393), which adds support for platform-specific asset filtering in `pubspec.yaml`.
- [DoLT](https://github.com/letrdo), for [#177572](https://github.com/flutter/flutter/pull/177572), which fixes a gesture blocking issue in the Android webview after zooming.
- [Mohammed Tarig Nour](https://github.com/MohammedTarigg), for [#177852](https://github.com/flutter/flutter/pull/177852), which corrects the iOS signing log for manual code signing.
- [Thomas Guerin](https://github.com/tguerin), for [#173862](https://github.com/flutter/flutter/pull/173862), which adds granular frame forcing to animations.
- [Tomoo Kikuchi](https://github.com/KikuchiTomo), for [#177437](https://github.com/flutter/flutter/pull/177437), which adds a `DeviceOrientationBuilder` widget.
