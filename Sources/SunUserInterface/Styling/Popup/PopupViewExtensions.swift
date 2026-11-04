//
//  PopupViewExtensions.swift
//  SunUserInterface
//
//  Created by Jiawen Sun on 2023/4/19.
//

import SwiftUI

extension View {
    public func popupStyle(_ style: some PopupStyling) -> some View {
        environment(\.popupStyle, AnyPopupStyling(style))
    }
    public func setPopupRoot() -> some View { modifier(PopupRootModifier()) }
    public func setPopupRoot(manager: PopupManager) -> some View {
        modifier(PopupRootModifier(manager: manager))
    }
    public func popup<Content: View>(
        showing: Binding<Bool>,
        type: PopupType = .popup,
        dismissOnBackgroundTap: Bool = true,
        @ViewBuilder content: @escaping () -> Content
    ) -> some View {
        modifier(
            PopupModifier(
                showing: showing,
                type: type,
                dismissOnBackgroundTap: dismissOnBackgroundTap,
                popup: content
            )
        )
    }
}
