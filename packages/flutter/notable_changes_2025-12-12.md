### November 22, 2025 to December 12, 2025

A total of 296 changes were merged to the framework, engine, and packages last week.

**Framework**

*   [#179179](https://github.com/flutter/flutter/pull/179179) Fix draggable scrollable sheet example drag speed is off. This change fixes an issue in the `DraggableScrollableSheet` example where the sheet would not correctly follow the pointer when dragged off-screen and back, improving the examples's usability and demonstrating correct implementation.
    <video src="https://user-images.githubusercontent.com/42761233/179179-8b010800-2b1b-4309-84d2-2831b14299b8.mp4" controls></video>
    *   Authored by [Huy](https://github.com/huycozy) and reviewed by [chunhtai](https://github.com/chunhtai).
*   [#179352](https://github.com/flutter/flutter/pull/179352) Reland: Add framework-side hitTestBehavior support to Semantics. This change re-introduces `hitTestBehavior` to the semantics framework, allowing platform views to correctly receive pointer events inside modal routes, which fixes a regression and improves accessibility.
    *   Authored by [zhongliugo](https://github.com/flutter-zl) and reviewed by [chunhtai](https://github.com/chunhtai).
*   [#179132](https://github.com/flutter/flutter/pull/179132) Fix the issue with pinned headers in nested SliverMainAxisGroup. This change fixes a visual bug in nested `SliverMainAxisGroup`s where pinned headers would overlap during scrolling, ensuring they now correctly push each other off-screen as expected.
    *   Authored by [yim](https://github.com/yiiim) and reviewed by [Kate Lovett](https://github.com/Piinks).
*   [#175515](https://github.com/flutter/flutter/pull/175515) added onUserInteractionIfError for form. This change introduces a new `AutovalidateMode`, `onUserInteractionIfError`, for forms, which improves user experience by deferring validation until a user interacts with a field that already contains an error.
    *   Authored by [akashefrath](https://github.com/akashefrath) and reviewed by [Justin McCandless](https://github.com/justinmc), [Loïc Sharma](https://github.com/loic-sharma), and [Renzo Olivares](https://github.com/Renzo-Olivares).
*   [#179199](https://github.com/flutter/flutter/pull/179199) Fix Scrollbar drag behavior. This change fixes an issue where a scrollbar could not be dragged when the `CustomScrollView` had a `center` sliver with no children, improving the robustness of scroll behavior.
    *   Authored by [Ramon Farizel](https://github.com/RamonFarizel) and reviewed by [Victor Sanni](https://github.com/victorsanni) and [chunhtai](https://github.com/chunhtai).
*   [#176927](https://github.com/flutter/flutter/pull/176927) feat: Add `mainAxisExtent` parameter to `GridView` constructors. This change adds a `mainAxisExtent` parameter to `GridView` constructors, allowing developers to set a fixed height for grid items, which provides more control over the layout, especially across different screen sizes and orientations.
    *   Authored by [Nebojša Cvetković](https://github.com/nebkat) and reviewed by [Victor Sanni](https://github.com/victorsanni) and [Kate Lovett](https://github.com/Piinks).

**Engine**

*   [#179426](https://github.com/flutter/flutter/pull/179426) Use depth buffer to implement geometry overdraw protection. This change improves rendering performance by using the depth buffer for geometry overdraw protection, replacing the previous, less efficient stencil-based approach.
    *   Authored by [b-luk](https://github.com/b-luk) and reviewed by [Jim Graham](https://github.com/flar) and [Chinmay Garde](https://github.com/chinmaygarde).
*   [#179519](https://github.com/flutter/flutter/pull/179519) Implements decodeImageFromPixelsSync. A new synchronous `decodeImageFromPixelsSync` method provides a more performant way to create images from raw pixel data, which is especially useful for graphics-intensive applications like chaining fragment shaders.
    *   Authored by [gaaclarke](https://github.com/gaaclarke) and reviewed by [Jim Graham](https://github.com/flar) and [Chinmay Garde](https://github.com/chinmaygarde).
*   [#178691](https://github.com/flutter/flutter/pull/178691) Adds format argument to Picture.toImageSync. The `Picture.toImageSync` method now accepts a `format` argument, giving developers more control over the pixel format of the resulting image and enabling more advanced graphics techniques.
    *   Authored by [gaaclarke](https://github.com/gaaclarke) and reviewed by [Chinmay Garde](https://github.com/chinmaygarde).
*   [#175442](https://github.com/flutter/flutter/pull/175442) [wimp] Initial Impeller on Web implementation. This change introduces the initial implementation of the Impeller rendering engine for the web, a major step towards improving rendering performance and fidelity on the web platform.
    *   Authored by [Jackson Gardner](https://github.com/eyebrowsoffire) and reviewed by [gaaclarke](https://github.com/gaaclarke).

**Platform**

*   [#179538](https://github.com/flutter/flutter/pull/179538) [win32] Do not flood message loop with wake up messages. This change improves the responsiveness of Flutter applications on Windows by preventing the message loop from being flooded with wake-up messages, especially when the Dart event loop is busy.
    *   Authored by [Matej Knopp](https://github.com/knopp) and reviewed by [Loïc Sharma](https://github.com/loic-sharma).
*   [#179659](https://github.com/flutter/flutter/pull/179659) [ios][pv] accept/reject gesture based on hitTest (with new widget API). Developers now have more control over gesture handling in `UiKitView` with the new `gestureBlockingPolicy`, which allows specifying how gestures are blocked or passed to the underlying `UIView`.
    *   Authored by [hellohuanlin](https://github.com/hellohuanlin) and reviewed by [Victoria Ashworth](https://github.com/vashworth), [chunhtai](https://github.com/chunhtai), and [Loïc Sharma](https://github.com/loic-sharma).
*   [#179528](https://github.com/flutter/flutter/pull/179528) Ensure that the engine converts std::filesystem::path objects to UTF-8 strings on Windows. This change fixes a bug on Windows where applications would fail to launch if their build path contained non-UTF-8 characters.
    *   Authored by [Jason Simmons](https://github.com/jason-simmons) and reviewed by [Chinmay Garde](https://github.com/chinmaygarde).
*   [#179484](https://github.com/flutter/flutter/pull/179484) Implement flutter/accessibility channel. This change implements the accessibility channel on Linux, enabling screen reader support for semantic announcements and live regions.
    *   Authored by [Robert Ancell](https://github.com/robert-ancell) and reviewed by [Matthew Kosarek](https://github.com/mattkae).
*   [#179153](https://github.com/flutter/flutter/pull/179153) [ios] Reland Dynamic Content Resizing. The `FlutterView` on iOS can now automatically resize based on its content by setting the `isAutoResizable` flag, which is a significant improvement for add-to-app scenarios.
    *   Authored by [LouiseHsu](https://github.com/LouiseHsu) and reviewed by [gaaclarke](https://github.com/gaaclarke).
*   [#179310](https://github.com/flutter/flutter/pull/179310) Replace use of eglCreateImage with eglCreateImageKHR to reduce EGL requirement. This change lowers the EGL version requirement on Linux by replacing `eglCreateImage` with `eglCreateImageKHR`, which fixes application startup failures on some systems.
    *   Authored by [Robert Ancell](https://github.com/robert-ancell) and reviewed by [Matthew Kosarek](https://github.com/mattkae).
*   [#177653](https://github.com/flutter/flutter/pull/177653) [Windows] Allow apps to prefer high power GPUs. Windows developers can now request a high-performance GPU for their applications, which is beneficial for games and other graphics-intensive applications.
    *   Authored by [Jon Ihlas](https://github.com/9AZX) and reviewed by [Loïc Sharma](https://github.com/loic-sharma) and [Matthew Kosarek](https://github.com/mattkae).

**Tool**

*   [#175900](https://github.com/flutter/flutter/pull/175900) Exit with code 1 when calling `flutter build` without arguments. The `flutter build` command will now exit with a non-zero error code when no subcommand is provided, preventing unexpected behavior in CI/CD pipelines and other scripts.
    *   Authored by [Felipe Peter](https://github.com/Mr-Pepe) and reviewed by [Ben Konyi](https://github.com/bkonyi) and [Lau Ching Jun](https://github.com/chingjun).
*   [#178116](https://github.com/flutter/flutter/pull/178116) [ Widget Preview ] Add embedded Widget Inspector support. Widget previews now feature an embedded Widget Inspector, allowing developers to inspect their previews directly in the browser without needing a special IDE debug session.
    <video src="https://user-images.githubusercontent.com/42761233/178116-3e3a1098-0526-4c7f-8087-38fb84f28335.mp4" controls></video>
    *   Authored by [Ben Konyi](https://github.com/bkonyi) and reviewed by [Jessy Yameogo](https://github.com/jyameo).

**First-time Contributors**

Congratulations to our new first-time contributors!

- [Felipe Peter](https://github.com/Mr-Pepe), for [#175900](https://github.com/flutter/flutter/pull/175900), which exits with code 1 when calling `flutter build` without arguments.
- [akashefrath](https://github.com/akashefrath), for [#175515](https://github.com/flutter/flutter/pull/175515), which added onUserInteractionIfError for forms.
- [Nebojša Cvetković](https://github.com/nebkat), for [#176927](https://github.com/flutter/flutter/pull/176927), which added `mainAxisExtent` parameter to `GridView` constructors.
