### November 22, 2025 to December 12, 2025

A total of 296 changes were merged to the framework, engine, and packages last week.

**Notable Changes**

**Framework**

*   [#179179](https://github.com/flutter/flutter/pull/179179) Fix draggable scrollable sheet example drag speed is off.
    <video src="https://user-images.githubusercontent.com/42761233/179179-8b010800-2b1b-4309-84d2-2831b14299b8.mp4" controls></video>
    *   Authored by [Huy](https://github.com/huycozy) and reviewed by [chunhtai](https://github.com/chunhtai).
*   [#179352](https://github.com/flutter/flutter/pull/179352) Reland: Add framework-side hitTestBehavior support to Semantics.
    *   Authored by [zhongliugo](https://github.com/flutter-zl) and reviewed by [chunhtai](https://github.com/chunhtai).
*   [#179132](https://github.com/flutter/flutter/pull/179132) Fix the issue with pinned headers in nested SliverMainAxisGroup.
    *   Authored by [yim](https://github.com/yiiim) and reviewed by [Kate Lovett](https://github.com/Piinks).
*   [#175515](https://github.com/flutter/flutter/pull/175515) added onUserInteractionIfError for form.
    *   Authored by [akashefrath](https://github.com/akashefrath) and reviewed by [Justin McCandless](https://github.com/justinmc), [Loïc Sharma](https://github.com/loic-sharma), and [Renzo Olivares](https://github.com/Renzo-Olivares).
*   [#179199](https://github.com/flutter/flutter/pull/179199) Fix Scrollbar drag behavior.
    *   Authored by [Ramon Farizel](https://github.com/RamonFarizel) and reviewed by [Victor Sanni](https://github.com/victorsanni) and [chunhtai](https://github.com/chunhtai).
*   [#176927](https://github.com/flutter/flutter/pull/176927) feat: Add `mainAxisExtent` parameter to `GridView` constructors.
    *   Authored by [Nebojša Cvetković](https://github.com/nebkat) and reviewed by [Victor Sanni](https://github.com/victorsanni) and [Kate Lovett](https://github.com/Piinks).

**Engine**

*   [#179426](https://github.com/flutter/flutter/pull/179426) Use depth buffer to implement geometry overdraw protection.
    *   Authored by [b-luk](https://github.com/b-luk) and reviewed by [Jim Graham](https://github.com/flar) and [Chinmay Garde](https://github.com/chinmaygarde).
*   [#179519](https://github.com/flutter/flutter/pull/179519) Implements decodeImageFromPixelsSync.
    *   Authored by [gaaclarke](https://github.com/gaaclarke) and reviewed by [Jim Graham](https://github.com/flar) and [Chinmay Garde](https://github.com/chinmaygarde).
*   [#178691](https://github.com/flutter/flutter/pull/178691) Adds format argument to Picture.toImageSync.
    *   Authored by [gaaclarke](https://github.com/gaaclarke) and reviewed by [Chinmay Garde](https://github.com/chinmaygarde).
*   [#175442](https://github.com/flutter/flutter/pull/175442) [wimp] Initial Impeller on Web implementation.
    *   Authored by [Jackson Gardner](https://github.com/eyebrowsoffire) and reviewed by [gaaclarke](https://github.com/gaaclarke).

**Platform**

*   [#179538](https://github.com/flutter/flutter/pull/179538) [win32] Do not flood message loop with wake up messages.
    *   Authored by [Matej Knopp](https://github.com/knopp) and reviewed by [Loïc Sharma](https://github.com/loic-sharma).
*   [#179659](https://github.com/flutter/flutter/pull/179659) [ios][pv] accept/reject gesture based on hitTest (with new widget API).
    *   Authored by [hellohuanlin](https://github.com/hellohuanlin) and reviewed by [Victoria Ashworth](https://github.com/vashworth), [chunhtai](https://github.com/chunhtai), and [Loïc Sharma](https://github.com/loic-sharma).
*   [#179528](https://github.com/flutter/flutter/pull/179528) Ensure that the engine converts std::filesystem::path objects to UTF-8 strings on Windows.
    *   Authored by [Jason Simmons](https://github.com/jason-simmons) and reviewed by [Chinmay Garde](https://github.com/chinmaygarde).
*   [#179484](https://github.com/flutter/flutter/pull/179484) Implement flutter/accessibility channel.
    *   Authored by [Robert Ancell](https://github.com/robert-ancell) and reviewed by [Matthew Kosarek](https://github.com/mattkae).
*   [#179153](https://github.com/flutter/flutter/pull/179153) [ios] Reland Dynamic Content Resizing.
    *   Authored by [LouiseHsu](https://github.com/LouiseHsu) and reviewed by [gaaclarke](https://github.com/gaaclarke).
*   [#179310](https://github.com/flutter/flutter/pull/179310) Replace use of eglCreateImage with eglCreateImageKHR to reduce EGL requirement.
    *   Authored by [Robert Ancell](https://github.com/robert-ancell) and reviewed by [Matthew Kosarek](https://github.com/mattkae).
*   [#177653](https://github.com/flutter/flutter/pull/177653) [Windows] Allow apps to prefer high power GPUs.
    *   Authored by [Jon Ihlas](https://github.com/9AZX) and reviewed by [Loïc Sharma](https://github.com/loic-sharma) and [Matthew Kosarek](https://github.com/mattkae).

**Tool**

*   [#175900](https://github.com/flutter/flutter/pull/175900) Exit with code 1 when calling `flutter build` without arguments.
    *   Authored by [Felipe Peter](https://github.com/Mr-Pepe) and reviewed by [Ben Konyi](https://github.com/bkonyi) and [Lau Ching Jun](https://github.com/chingjun).
*   [#178116](https://github.com/flutter/flutter/pull/178116) [ Widget Preview ] Add embedded Widget Inspector support.
    <video src="https://user-images.githubusercontent.com/42761233/178116-3e3a1098-0526-4c7f-8087-38fb84f28335.mp4" controls></video>
    *   Authored by [Ben Konyi](https://github.com/bkonyi) and reviewed by [Jessy Yameogo](https://github.com/jyameo).

**First-time Contributors**

Congratulations to our new first-time contributors!

- [Felipe Peter](https://github.com/Mr-Pepe), for [#175900](https://github.com/flutter/flutter/pull/175900), which exits with code 1 when calling `flutter build` without arguments.
- [akashefrath](https://github.com/akashefrath), for [#175515](https://github.com/flutter/flutter/pull/175515), which added onUserInteractionIfError for forms.
- [Nebojša Cvetković](https://github.com/nebkat), for [#176927](https://github.com/flutter/flutter/pull/176927), which added `mainAxisExtent` parameter to `GridView` constructors.
