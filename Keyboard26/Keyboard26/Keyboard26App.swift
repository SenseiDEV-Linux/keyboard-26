import SwiftUI

@main
struct Keyboard26App: App {
    @StateObject private var keyboardState = KeyboardState()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(keyboardState)
        }
    }
}
