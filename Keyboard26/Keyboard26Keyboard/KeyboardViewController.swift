import UIKit
import SwiftUI

final class KeyboardViewController: UIInputViewController {
    private lazy var hostingController = UIHostingController(rootView: KeyboardView(actionHandler: self))
    private let feedbackGenerator = UIImpactFeedbackGenerator(style: .light)

    override func viewDidLoad() {
        super.viewDidLoad()
        feedbackGenerator.prepare()
        addChild(hostingController)
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(hostingController.view)
        NSLayoutConstraint.activate([
            hostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            hostingController.view.topAnchor.constraint(equalTo: view.topAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        hostingController.didMove(toParent: self)
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        view.backgroundColor = .systemBackground
    }
}

private protocol KeyboardActionHandling: AnyObject {
    func handleKeyPress(_ key: KeyboardKey)
    func handleBackspace()
    func handleReturn()
    func handleNextKeyboard()
}

extension KeyboardViewController: KeyboardActionHandling {
    fileprivate func handleKeyPress(_ key: KeyboardKey) {
        textDocumentProxy.insertText(key.display)
        feedbackGenerator.impactOccurred()
    }

    func handleBackspace() {
        textDocumentProxy.deleteBackward()
        feedbackGenerator.impactOccurred()
    }

    func handleReturn() {
        textDocumentProxy.insertText("\n")
        feedbackGenerator.impactOccurred()
    }

    func handleNextKeyboard() {
        advanceToNextInputMode()
    }
}

private struct KeyboardView: View {
    weak var actionHandler: KeyboardActionHandling?

    private let rows: [[KeyboardKey]] = KeyboardLayout.default.rows

    var body: some View {
        VStack(spacing: 8) {
            ForEach(rows.indices, id: \.self) { rowIndex in
                HStack(spacing: 6) {
                    ForEach(rows[rowIndex]) { key in
                        KeyButton(key: key) {
                            actionHandler?.handleKeyPress(key)
                        }
                    }
                }
            }

            HStack(spacing: 6) {
                SystemKeyButton(title: "123") {
                    actionHandler?.handleNextKeyboard()
                }
                SystemKeyButton(imageName: "globe") {
                    actionHandler?.handleNextKeyboard()
                }
                SpacebarButton {
                    actionHandler?.handleKeyPress(.space)
                }
                SystemKeyButton(imageName: "delete.left") {
                    actionHandler?.handleBackspace()
                }
                SystemKeyButton(title: "return") {
                    actionHandler?.handleReturn()
                }
            }
        }
        .padding(8)
        .background(Color(uiColor: .systemGray5))
    }
}

private struct KeyButton: View {
    let key: KeyboardKey
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(key.display)
                .font(.system(size: 20, weight: .medium))
                .frame(maxWidth: .infinity, minHeight: 44)
        }
        .buttonStyle(KeyboardButtonStyle())
    }
}

private struct SystemKeyButton: View {
    var title: String?
    var imageName: String?
    var action: () -> Void

    init(title: String? = nil, imageName: String? = nil, action: @escaping () -> Void) {
        self.title = title
        self.imageName = imageName
        self.action = action
    }

    var body: some View {
        Button(action: action) {
            if let imageName {
                Image(systemName: imageName)
                    .font(.system(size: 18, weight: .medium))
                    .frame(maxWidth: .infinity, minHeight: 44)
            } else if let title {
                Text(title.uppercased())
                    .font(.system(size: 16, weight: .semibold))
                    .frame(maxWidth: .infinity, minHeight: 44)
            }
        }
        .buttonStyle(KeyboardButtonStyle(background: Color(uiColor: .systemGray4)))
    }
}

private struct SpacebarButton: View {
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            Text("space")
                .font(.system(size: 16))
                .frame(maxWidth: .infinity, minHeight: 44)
        }
        .buttonStyle(KeyboardButtonStyle())
    }
}

private struct KeyboardButtonStyle: ButtonStyle {
    var background: Color = Color(uiColor: .systemBackground)

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.vertical, 6)
            .padding(.horizontal, 4)
            .background(background)
            .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .stroke(Color(uiColor: .systemGray3))
            )
            .scaleEffect(configuration.isPressed ? 0.97 : 1.0)
    }
}

private struct KeyboardLayout {
    let rows: [[KeyboardKey]]

    static let `default` = KeyboardLayout(rows: [
        "qwertyuiop".map { KeyboardKey(letter: $0) },
        "asdfghjkl".map { KeyboardKey(letter: $0) },
        "zxcvbnm".map { KeyboardKey(letter: $0) }
    ])
}

private struct KeyboardKey: Identifiable, Hashable {
    enum KeyType: Hashable {
        case letter(Character)
        case space
        case backspace
        case shift
    }

    var type: KeyType

    var id: KeyType { type }

    var display: String {
        switch type {
        case .letter(let letter):
            return String(letter)
        case .space:
            return " "
        case .backspace:
            return "" // handled by system key row
        case .shift:
            return "" // placeholder
        }
    }

    static func == (lhs: KeyboardKey, rhs: KeyboardKey) -> Bool {
        lhs.type == rhs.type
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(display)
    }

    init(letter: Character) {
        self.type = .letter(letter)
    }

    static let space = KeyboardKey(type: .space)
    static let backspace = KeyboardKey(type: .backspace)
    static let shift = KeyboardKey(type: .shift)

    private init(type: KeyType) {
        self.type = type
    }
}
