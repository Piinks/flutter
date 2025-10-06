### September 20, 2025 to October 03, 2025

This week, 188 changes landed in the Flutter framework, including significant improvements to windowing on desktop, more powerful widget previews, and key enhancements for iOS integration.

**Framework**

- [#176305](https://github.com/flutter/flutter/pull/176305) iOS developers can now rejoice! 🎉 State restoration is now supported for apps using UIScenes, ensuring a more seamless user experience when multitasking.
  - Authored by [Victoria Ashworth](https://github.com/vashworth) and reviewed by [LongCatIsLooong](https://github.com/LongCatIsLooong).
- [#175810](https://github.com/flutter/flutter/pull/175810) This change improves accessibility by fixing VoiceOver focus traversal on `OutlinedButton.icon`, preventing focus from being lost when an icon is dynamically added. ♿️
  - Authored by [LouiseHsu](https://github.com/LouiseHsu) and reviewed by [chunhtai](https://github.com/chunhtai).
  <video src="https://github.com/user-attachments/assets/e012bac9-823e-46f1-8eba-ec70e6b260a1" controls></video>
- [#176303](https://github.com/flutter/flutter/pull/176303) Another win for modern iOS apps! Deeplinking now works correctly for applications that have migrated to the UIScene lifecycle. 🔗
  - Authored by [Victoria Ashworth](https://github.com/vashworth) and reviewed by [LongCatIsLooong](https://github.com/LongCatIsLooong).
- [#176373](https://github.com/flutter/flutter/pull/176373) This fix improves the accessibility of the time picker by aligning its semantic properties (`selected` vs. `checked`) with platform-specific conventions on iOS and Android. 📱
  - Authored by [Kate Lovett](https://github.com/Piinks) and reviewed by [chunhtai](https://github.com/chunhtai).
- [#173754](https://github.com/flutter/flutter/pull/173754) A frustrating crash in `DateRangePickerDialog` when rendered in a zero-sized environment has been squashed, making the widget more robust. 🐞
  - Authored by [Ahmed Mohamed Sameh](https://github.com/ahmedsameha1) and reviewed by [Tong Mu](https://github.com/dkwingsmt) and [Mitchell Goodwin](https://github.com/MitchellGoodwin).
- [#176023](https://github.com/flutter/flutter/pull/176023) Windows developers will see smoother UIs and fewer deadlocks thanks to a new high-resolution timer implementation in the Win32 runloop. 🚀
  - Authored by [Matej Knopp](https://github.com/knopp) and reviewed by [Matthew Kosarek](https://github.com/mattkae) and [Loïc Sharma](https://github.com/loic-sharma).
- [#176230](https://github.com/flutter/flutter/pull/176230) Integrating Flutter into SwiftUI apps just got easier! This change adds support for the UIScene migration, improving compatibility with modern SwiftUI lifecycles. 🤝
  - Authored by [Victoria Ashworth](https://github.com/vashworth) and reviewed by [LongCatIsLooong](https://github.com/LongCatIsLooong).
- [#175100](https://github.com/flutter/flutter/pull/175100) A new `dart:ui` API, `setApplicationLocale`, has been added, giving developers more explicit control over the application's locale as seen by the engine. 🌍
  - Authored by [chunhtai](https://github.com/chunhtai) and reviewed by [Reid Baker](https://github.com/reidbaker), [Mouad Debbar](https://github.com/mdebbar), [Victoria Ashworth](https://github.com/vashworth) and [Loïc Sharma](https://github.com/loic-sharma).
- [#176202](https://github.com/flutter/flutter/pull/176202) The foundations for dialog windows have landed! This change implements the framework interface for the dialog window archetype, paving the way for richer windowing capabilities. 🖼️
  - Authored by [Matthew Kosarek](https://github.com/mattkae) and reviewed by [Justin McCandless](https://github.com/justinmc).
- [#173715](https://github.com/flutter/flutter/pull/173715) Big news for Windows! The framework now has an implementation for regular, non-dialog windows, including a great example app to show it off. 🪟
  - Authored by [Matthew Kosarek](https://github.com/mattkae) and reviewed by [Loïc Sharma](https://github.com/loic-sharma) and [Justin McCandless](https://github.com/justinmc).
- [#175324](https://github.com/flutter/flutter/pull/175324) Developers now have more control over the look of their carousels with the new `itemClipBehavior` property on `CarouselView`. ✂️
  - Authored by [ShantanuBorkar](https://github.com/AlsoShantanuBorkar) and reviewed by [Qun Cheng](https://github.com/QuncCccccc) and [Renzo Olivares](https://github.com/Renzo-Olivares).
- [#171334](https://github.com/flutter/flutter/pull/171334) Customizing date pickers on iOS is now more powerful with the new `selectableDayPredicate` parameter, allowing developers to easily enable or disable specific days. 🗓️
  - Authored by [Kouki Badr](https://github.com/koukibadr) and reviewed by [Victor Sanni](https://github.com/victorsanni), [Tong Mu](https://github.com/dkwingsmt) and [Mitchell Goodwin](https://github.com/MitchellGoodwin).
  <video src="https://github.com/user-attachments/assets/8b1290c9-0d01-4199-921a-f86cd9d281a5" controls></video>
- [#175773](https://github.com/flutter/flutter/pull/175773) Creating beautiful tables just got easier! `TableBorder` now supports non-uniform border radii, allowing for more flexible and creative table designs. 🎨
  - Authored by [ParkJuneWoo](https://github.com/korca0220) and reviewed by [Kate Lovett](https://github.com/Piinks) and [Justin McCandless](https://github.com/justinmc).
- [#174300](https://github.com/flutter/flutter/pull/174300) This fix corrects mouse cursor behavior for platform views on the web, ensuring the cursor updates appropriately when moving between different regions. 🖱️
  - Authored by [Tong Mu](https://github.com/dkwingsmt) and reviewed by [Mouad Debbar](https://github.com/mdebbar).
  **Before:**
  <video src="https://github.com/user-attachments/assets/33d2a476-d9c4-46e1-a5c5-ea8e602060d6" controls></video>
  **After:**
  <video src="https://github.com/user-attachments/assets/383e4a01-4b8e-4c0e-a5a4-fa0d1fc28b67" controls></video>

**Tooling**

- [#176289](https://github.com/flutter/flutter/pull/176289) The Widget Preview tool gets a quality-of-life improvement: the 'Filter by Selected File' toggle state is now persisted across sessions. ✅
  - Authored by [Ben Konyi](https://github.com/bkonyi) and reviewed by [Danny Tuppeny](https://github.com/DanTup).
- [#175881](https://github.com/flutter/flutter/pull/175881) A bug in the localization generator has been fixed, ensuring that untranslated messages files are correctly generated in Pub workspaces. 🛠️
  - Authored by [Ben Konyi](https://github.com/bkonyi) and reviewed by [Lau Ching Jun](https://github.com/chingjun).
- [#175535](https://github.com/flutter/flutter/pull/175535) Widget Previews are now more flexible! Developers can now create their own custom `Preview` annotations and apply runtime transformations for more powerful and reusable previews. ✨
  - Authored by [Ben Konyi](https://github.com/bkonyi) and reviewed by [Elliott Brooks](https://github.com/elliette).

**Ecosystem**

- [#176285](https://github.com/flutter/flutter/pull/176285) Native assets are now enabled on the stable channel! This is a huge step forward for integrating native code in Flutter apps. 📦
  - Authored by [Daco Harkes](https://github.com/dcharkes) and reviewed by [Michael Goderbauer](https://github.com/goderbauer).
- [#176226](https://github.com/flutter/flutter/pull/176226) The minimum supported Java version for Android has been bumped to 17, aligning with modern Android development standards. ☕
  - Authored by [Reid Baker](https://github.com/reidbaker) and reviewed by [Gray Mackall](https://github.com/gmackall).