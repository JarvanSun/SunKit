//
//  Popup.swift
//  SunUserInterface
//
//  Created by Jiawen Sun on 2023/4/19.
//

import SwiftUI

@MainActor
public struct Popup: Identifiable {
    public let id: UUID
    public let type: PopupType
    public let style: AnyPopupStyling
    let dismissOnBackgroundTap: Bool
    let content: AnyView
    let onDismiss: () -> Void

    public init<Content: View>(
        id: UUID = UUID(),
        type: PopupType = .popup,
        style: some PopupStyling,
        dismissOnBackgroundTap: Bool = true,
        onDismiss: @escaping () -> Void = {},
        @ViewBuilder content: () -> Content
    ) {
        self.id = id
        self.type = type
        self.style = AnyPopupStyling(style)
        self.dismissOnBackgroundTap = dismissOnBackgroundTap
        self.onDismiss = onDismiss
        self.content = AnyView(content())
    }
}
