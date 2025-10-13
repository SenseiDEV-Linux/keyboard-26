# iOS26 Keyboard Development Plan

This document outlines the step-by-step approach for building the iOS26 custom keyboard extension. The initial focus is to match the default iOS keyboard experience. Enhancements will be layered in once the base typing flow is reliable.

## Phase 0 – Preparation

1. **Review Apple documentation**
   - Read the latest "Creating a Custom Keyboard" guide on [developer.apple.com](https://developer.apple.com/documentation/uikit/keyboards_and_input).
   - Confirm deployment targets (iOS 16+ recommended) and supported device orientations.
2. **Gather assets and references**
   - Download SF Symbols for iconography (globe, delete, shift, microphone placeholder).
   - Capture screenshots of the stock keyboard for reference on spacing and proportions.
3. **Decide on enhancement roadmap**
   - Start with parity features (letters, numbers, punctuation, autocapitalization, predictive text placeholder, haptic feedback hooks).
   - Plan optional enhancements (theme toggle, swipe gestures, custom suggestions row).

## Phase 1 – Project Setup

1. **Create the Xcode workspace**
   - Open Xcode ➝ File ➝ New ➝ Project ➝ App template.
   - Name the project `iOS26Keyboard`, select Swift + SwiftUI or UIKit for the host app, and ensure "Include Tests" is enabled.
   - Set the bundle identifier and team to enable code signing on physical devices.
2. **Add a Custom Keyboard target**
   - In Xcode, go to File ➝ New ➝ Target ➝ Custom Keyboard Extension.
   - Name it `KeyboardExtension` and ensure "Include a template for a view controller" is checked.
   - Confirm the extension uses an independent storyboard (no shared code yet).
3. **Configure the extension target**
   - In the extension's Info.plist, set `RequestsOpenAccess` to `YES` (needed for haptics and audio later).
   - Limit supported interface orientations to portrait for iPhone; optional landscape for iPad.
   - Add `NSExtensionAttributes` ➝ `PrimaryLanguage` = `en` (will expand later).

## Phase 2 – Baseline Keyboard UI

1. **Replace storyboard with programmatic layout (optional but recommended)**
   - Delete `KeyboardViewController.xib` and set the controller to instantiate a custom view hierarchy.
   - Use Auto Layout to build three rows of alphabet keys plus the bottom row (shift, globe, space, etc.).
2. **Create reusable key views**
   - Implement a `KeyButton` subclass using `UIButton` with configurable title/icon, background, and press feedback.
   - Add states for normal, highlighted, selected (for shift lock).
3. **Lay out alphabet rows**
   - Hardcode key order for QWERTY: `QWERTYUIOP`, `ASDFGHJKL`, `ZXCVBNM`.
   - Add constraints to manage horizontal/vertical spacing and handle compact/regular size classes.
4. **Implement basic input handling**
   - Connect each key to an action that inserts characters via `textDocumentProxy.insertText(_:)`.
   - Provide delete functionality with `textDocumentProxy.deleteBackward()` and long-press repeat.
   - Hook up the globe button to `advanceToNextInputMode()`.
5. **Test on simulator and a physical device**
   - Add the keyboard under Settings ➝ General ➝ Keyboard ➝ Keyboards ➝ Add New Keyboard…
   - Validate typing in Notes, Messages, and Safari.

## Phase 3 – Core Feature Parity

1. **Shift and caps logic**
   - Implement single-tap shift (capitalizes next letter) and double-tap caps lock.
   - Respect `UITextInput.currentAutocapitalizationType` for automatic casing.
2. **Spacebar, return, and number switch**
   - Ensure spacebar inserts a space and triggers `textWillChange`/`textDidChange` updates.
   - Implement return key label changes (`return`, `search`, `go`, etc.) using `textDocumentProxy.returnKeyType`.
   - Add a `123` key to switch to the symbols layout; create a second layout array for numbers/punctuation and a toggle button.
3. **Auto-capitalization and period shortcut**
   - Observe `textDocumentProxy.documentContextBeforeInput` to detect sentence boundaries.
   - Implement double-space shortcut to insert `. `.
4. **Haptic and audio feedback**
   - Use `UIImpactFeedbackGenerator` and `UIDevice.current.playInputClick()` (requires full access).
5. **Basic suggestions row placeholder**
   - Add a static horizontal stack above keys showing placeholder suggestions; wire to future predictive logic.

## Phase 4 – Infrastructure for Enhancements

1. **Define a layout engine**
   - Create data structures for rows and key definitions, enabling quick swaps between layouts.
   - Add JSON or plist-driven key definitions for localization.
2. **Implement theme management**
   - Build a theming layer (light/dark/high-contrast) that updates key colors, fonts, and background.
   - Persist theme preference using `UserDefaults` shared via App Group.
3. **Set up analytics/logging (optional)**
   - Integrate lightweight logging (e.g., OSLog) to record key presses and feature usage (anonymized).

## Phase 5 – Planned Enhancements

1. **Swipe typing foundation**
   - Track touch paths across keys, map to probable word, and call predictive engine.
   - Use `UIPanGestureRecognizer` with custom gesture handling to avoid conflicts.
2. **Custom suggestion engine**
   - Build a simple n-gram-based predictor or integrate on-device ML model.
   - Update suggestions row with candidate buttons that insert replacements when tapped.
3. **Emoji and GIF access**
   - Add a dedicated button to present a custom emoji/GIF picker using the host app container.
4. **Settings host app UI**
   - Provide toggles for enhancements (themes, haptics strength, swipe typing) using the container app.

## Next Steps

1. Follow Phases 0–3 to achieve functional parity with the system keyboard.
2. After parity is stable, iterate through Phase 4 and 5 items based on priority.
3. Document implementation details and decisions in additional markdown files or inline code comments.

Keep this plan updated as progress is made, capturing challenges, resolved issues, and enhancement ideas.
