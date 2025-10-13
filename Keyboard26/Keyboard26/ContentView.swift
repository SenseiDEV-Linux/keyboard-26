import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var keyboardState: KeyboardState

    var body: some View {
        NavigationStack {
            List {
                Section("Keyboard Status") {
                    HStack {
                        Label("Enabled", systemImage: keyboardState.isEnabled ? "checkmark.circle.fill" : "xmark.circle")
                            .foregroundStyle(keyboardState.isEnabled ? .green : .secondary)
                        Spacer()
                        Toggle("", isOn: .constant(keyboardState.isEnabled))
                            .labelsHidden()
                            .disabled(true)
                    }

                    HStack {
                        Label("Full Access", systemImage: keyboardState.hasFullAccess ? "lock.open" : "lock")
                            .foregroundStyle(keyboardState.hasFullAccess ? .blue : .secondary)
                        Spacer()
                        Toggle("", isOn: .constant(keyboardState.hasFullAccess))
                            .labelsHidden()
                            .disabled(true)
                    }
                }

                Section("Setup Checklist") {
                    Label("Open Settings → General → Keyboard", systemImage: "1.circle")
                    Label("Add \"iOS26 Keyboard\"", systemImage: "2.circle")
                    Label("Allow Full Access", systemImage: "3.circle")
                }

                Section("About") {
                    Text("This host app provides preferences and onboarding for the iOS26 keyboard extension. Future updates will let you customise layouts and themes.")
                }
            }
            .navigationTitle("iOS26 Keyboard")
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(KeyboardState())
}
