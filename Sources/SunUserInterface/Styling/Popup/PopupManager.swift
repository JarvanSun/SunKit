//
//  PopupManager.swift
//  SunUserInterface
//
//  Created by Jiawen Sun on 2023/4/19.
//

import Observation
import SwiftUI

@MainActor @Observable
public final class PopupManager {
    public private(set) var popup: Popup?
    public init() {}

    public func show(_ popup: Popup) {
        let previous = self.popup
        self.popup = popup
        if previous?.id != popup.id { previous?.onDismiss() }
    }

    public func hideCurrentPopup() {
        guard let popup else { return }

        self.popup = nil
        popup.onDismiss()
    }

    public func hide(id: UUID) {
        guard popup?.id == id else { return }

        hideCurrentPopup()
    }
}

private struct PopupManagerKey: EnvironmentKey {
    static let defaultValue: PopupManager? = nil
}

extension EnvironmentValues {
    public var popupManager: PopupManager? {
        get { self[PopupManagerKey.self] }
        set { self[PopupManagerKey.self] = newValue }
    }
}
