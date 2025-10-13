import Foundation
import Combine

final class KeyboardState: ObservableObject {
    @Published var isEnabled: Bool
    @Published var hasFullAccess: Bool

    private var cancellables: Set<AnyCancellable> = []

    init(isEnabled: Bool = false, hasFullAccess: Bool = false) {
        self.isEnabled = isEnabled
        self.hasFullAccess = hasFullAccess
        observeNotificationCenter()
    }

    func observeNotificationCenter(notificationCenter: NotificationCenter = .default) {
        notificationCenter.publisher(for: .keyboard26DidUpdateState)
            .compactMap { $0.userInfo?["state"] as? KeyboardStateSnapshot }
            .sink { [weak self] snapshot in
                self?.isEnabled = snapshot.isEnabled
                self?.hasFullAccess = snapshot.hasFullAccess
            }
            .store(in: &cancellables)
    }
}

struct KeyboardStateSnapshot {
    var isEnabled: Bool
    var hasFullAccess: Bool
}

extension Notification.Name {
    static let keyboard26DidUpdateState = Notification.Name("Keyboard26DidUpdateState")
}
