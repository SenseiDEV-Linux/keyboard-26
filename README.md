# iOS26 Keyboard

This repository contains the source for **iOS26 Keyboard**, a custom iOS keyboard extension that recreates the stock iOS layout while providing room for ergonomic improvements.

## Project structure

```
Keyboard26/
├─ Keyboard26/              # Host iOS app (SwiftUI)
│  ├─ ContentView.swift     # Host onboarding/preferences UI
│  ├─ Keyboard26App.swift   # Application entry point
│  ├─ KeyboardState.swift   # Shared state model updated by the extension
│  └─ Info.plist            # Host app configuration
└─ Keyboard26Keyboard/      # Keyboard extension target
   ├─ KeyboardViewController.swift
   └─ Info.plist
```

The host app gives users a place to complete setup tasks and will eventually expose configuration for themes, layouts, and enhancement toggles. The `Keyboard26Keyboard` target implements the system keyboard interface with SwiftUI-powered keys hosted inside `UIInputViewController`.

## Getting started

Follow the steps below to compile the host app and try the keyboard extension in the iOS Simulator or on a device.

1. **Install prerequisites.** Make sure you have Xcode 15 (or newer) installed from the Mac App Store and that the **Command Line Tools** are selected in `Xcode → Settings → Locations`.
2. **Clone the repository.** In Terminal run `git clone <repo-url>` and `cd` into the cloned `keyboard-26` directory.
3. **Open the project.** Launch Xcode and choose `File → Open…`, then select `Keyboard26/Keyboard26.xcodeproj`.
4. **Configure signing.**
   - In the project navigator select the **Keyboard26** project, then the **Keyboard26** app target.
   - Under the **Signing & Capabilities** tab choose your development team or add one if needed.
   - Repeat for the **Keyboard26Keyboard** extension target, ensuring the bundle identifiers for the app and extension are unique within your account.
5. **Build and run the host app.** With the **Keyboard26** scheme selected, press `Cmd+R` to run on the desired simulator or a connected device. The app will install and show onboarding guidance.
6. **Enable the keyboard extension.** In the simulator (or device) open **Settings → General → Keyboard → Keyboards → Add New Keyboard…**, pick **Keyboard26**, then tap it again and toggle **Allow Full Access**.
7. **Test the keyboard.** Switch to any text field, tap the globe key until **Keyboard26** appears, and verify the custom layout renders.

If you make code changes in either target, rebuild the project (`Cmd+R`) to install the updated app and extension.

## Next steps

The code currently renders an alphabetical layout with basic system keys. Upcoming milestones include:

- Implementing alphabet/number/symbol keyboard groups and shift state management.
- Syncing setup progress and preferences between the extension and host app via app group storage.
- Adding theming support and ergonomic enhancements discussed in the planning document (`docs/ios26-keyboard-plan.md`).
