### August 9, 2025 to August 15, 2025

A total of 105 changes were merged to the framework this week. This release is tentatively titled Flutter 3.34.0.

### Notable Changes

**Framework**

- **[#165832](https://github.com/flutter/flutter/pull/165832) Predictive back route transitions by default**
  Enables predictive back route transitions by default on supported Android devices, using a shared element transition.
  * Authored by [Justin McCandless](https://github.com/justinmc) and reviewed by [Qun Cheng](https://github.com/QuncCccccc).

- **[#173221](https://github.com/flutter/flutter/pull/173221) feat: add onLongPressUp callback to InkWell widget**
  Adds an `onLongPressUp` callback to the `InkWell` widget, allowing developers to respond to the release of a long press gesture.
  * Authored by [Houssem Eddine Fadhli](https://github.com/houssemeddinefadhli81) and reviewed by [Victor Sanni](https://github.com/victorsanni) and [Tong Mu](https://github.com/dkwingsmt).

- **[#173148](https://github.com/flutter/flutter/pull/173148) Add error handling for `Element` lifecycle user callbacks**
  Improves error handling for user-supplied lifecycle callbacks in `Element`s, preventing the framework from getting into an inconsistent state.
  * Authored by [LongCatIsLooong](https://github.com/LongCatIsLooong) and reviewed by [chunhtai](https://github.com/chunhtai).

- **[#173725](https://github.com/flutter/flutter/pull/173725) [Range slider] Tap on active range, the thumb closest to the mouse cursor should move to the cursor position.**
  Enhances the `RangeSlider` by making the thumb closest to the tap position move to the cursor when tapping on the active range.
  * Authored by [Hannah Jin](https://github.com/hannah-hyj) and reviewed by [Yegor](https://github.com/yjbanov) and [chunhtai](https://github.com/chunhtai).

- **[#169293](https://github.com/flutter/flutter/pull/169293) Implements the Android native stretch effect as a fragment shader (Impeller-only).**
  Implements the native Android stretch overscroll effect using a fragment shader for a more authentic feel on Impeller.
  * Authored by [Dev TtangKong](https://github.com/MTtankkeo) and reviewed by [chunhtai](https://github.com/chunhtai), [Justin McCandless](https://github.com/justinmc), and [Tong Mu](https://github.com/dkwingsmt).

- **[#173480](https://github.com/flutter/flutter/pull/173480) [VPAT][A11y] Announce Autocomplete search results status**
  Improves accessibility by announcing the status of autocomplete search results for screen readers.
  * Authored by [Victor Sanni](https://github.com/victorsanni) and reviewed by [Justin McCandless](https://github.com/justinmc) and [chunhtai](https://github.com/chunhtai).

- **[#173344](https://github.com/flutter/flutter/pull/173344) Fix InputDecorator label padding**
  Corrects the label padding in `InputDecorator` when `prefixIcon` and/or `suffixIcon` are used.
  * Authored by [Bruno Leroux](https://github.com/bleroux) and reviewed by [Justin McCandless](https://github.com/justinmc).

- **[#172847](https://github.com/flutter/flutter/pull/172847) Allow empty initial time when using text input mode in showTimePicker dialog**
  Adds an option to have empty initial time fields in the `showTimePicker` dialog when using text input mode.
  * Authored by [Azat Chorekliyev](https://github.com/azatech) and reviewed by [Tong Mu](https://github.com/dkwingsmt) and [Mitchell Goodwin](https://github.com/MitchellGoodwin).

- **[#171718](https://github.com/flutter/flutter/pull/171718) fix: selected date decorator renders outside PageView in `DatePickerDialog` dialog**
  Fixes a visual glitch in `DatePickerDialog` where the selected date decorator would render outside the `PageView`.
  * Authored by [Albin PK](https://github.com/albinpk) and reviewed by [Tong Mu](https://github.com/dkwingsmt) and [Huy](https://github.com/huycozy).

- **[#168547](https://github.com/flutter/flutter/pull/168547) feat: Cupertino sheet implement upward stretch on full sheet**
  Implements an upward stretch effect on `CupertinoSheet` when it's fully expanded, providing a more native feel.
  * Authored by [masal9pse](https://github.com/masal9pse) and reviewed by [Mitchell Goodwin](https://github.com/MitchellGoodwin) and [Tong Mu](https://github.com/dkwingsmt).

- **[#167032](https://github.com/flutter/flutter/pull/167032) Fix visual overlap of transparent routes barrier when using FadeForwardsPageTransitionsBuilder**
  Fixes a visual overlap issue with the transparent route's barrier when using `FadeForwardsPageTransitionsBuilder`.
  * Authored by [TheLastFlame](https://github.com/TheLastFlame) and reviewed by [Qun Cheng](https://github.com/QuncCccccc) and [Justin McCandless](https://github.com/justinmc).

- **[#172875](https://github.com/flutter/flutter/pull/172875) Fix directional focus in nested scrollables with different axis**
  Fixes an issue with directional focus navigation in nested scrollables with different scroll axes.
  * Authored by [romain.gyh](https://github.com/romaingyh) and reviewed by [Kate Lovett](https://github.com/Piinks) and [Justin McCandless](https://github.com/justinmc).

**Web**

- **[#173652](https://github.com/flutter/flutter/pull/173652) [web] Popping a nameless route should preserve the correct route name**
  Fixes a bug on the web where popping a nameless route would not preserve the correct route name in the URL.
  * Authored by [Mouad Debbar](https://github.com/mdebbar) and reviewed by [chunhtai](https://github.com/chunhtai).

- **[#173629](https://github.com/flutter/flutter/pull/173629) [web] Fallback to CanvasKit when WebGL is not available**
  Improves web compatibility by falling back to CanvasKit when WebGL is not available.
  * Authored by [Mouad Debbar](https://github.com/mdebbar) and reviewed by [Jackson Gardner](https://github.com/eyebrowsoffire) and [Harry Terkelsen](https://github.com/harryterkelsen).

**Tool**

- **[#173654](https://github.com/flutter/flutter/pull/173654) [ Widget Preview ] Add `--machine` mode**
  Adds a `--machine` mode to the widget preview tool for better integration with other tools.
  * Authored by [Ben Konyi](https://github.com/bkonyi) and reviewed by [Danny Tuppeny](https://github.com/DanTup) and [Jessy Yameogo](https://github.com/jyameo).

### First-time Contributors

Congratulations to our new contributors!

- [Azat Chorekliyev](https://github.com/azatech), for [#172847](https://github.com/flutter/flutter/pull/172847), which allows empty initial time in `showTimePicker`.
- [Dev TtangKong](https://github.com/MTtankkeo), for [#169293](https://github.com/flutter/flutter/pull/169293), which implements the Android native stretch effect.
- [EdwynZN](https://github.com/edwinzn9), for their first contribution.
- [Houssem Eddine Fadhli](https://github.com/houssemeddinefadhli81), for [#173221](https://github.com/flutter/flutter/pull/173221), which adds an `onLongPressUp` callback to `InkWell`.
- [TheLastFlame](https://github.com/TheLastFlame), for [#167032](https://github.com/flutter/flutter/pull/167032), which fixes a visual overlap issue.
