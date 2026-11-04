//
//  PopupModifier.swift
//  SunUserInterface
//
//  Created by Jiawen Sun on 2023/4/19.
//

import SwiftUI

struct PopupModifier<PopupContent: View>: ViewModifier {
    @Environment(\.popupManager) private var manager
    @Environment(\.popupStyle) private var style
    @State private var fallbackManager = PopupManager()
    @State private var id = UUID()
    @Binding var showing: Bool
    let type: PopupType
    let dismissOnBackgroundTap: Bool
    let popup: () -> PopupContent

    func body(content: Content) -> some View {
        Group {
            if manager == nil {
                observedContent(content).modifier(PopupRootModifier(manager: fallbackManager))
            } else {
                observedContent(content)
            }
        }
    }

    private func observedContent(_ content: Content) -> some View {
        content
            .onChange(of: showing, initial: true) { _, value in
                let manager = manager ?? fallbackManager
                if value {
                    manager.show(
                        Popup(
                            id: id,
                            type: type,
                            style: style ?? AnyPopupStyling(PlainPopupStyle()),
                            dismissOnBackgroundTap: dismissOnBackgroundTap,
                            onDismiss: { showing = false },
                            content: popup
                        )
                    )
                } else {
                    manager.hide(id: id)
                }
            }
            .onDisappear { (manager ?? fallbackManager).hide(id: id) }
    }
}
