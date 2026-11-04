//
//  PopupRootModifier.swift
//  SunUserInterface
//
//  Created by Jiawen Sun on 2023/4/19.
//

import SwiftUI

public struct PopupRootModifier: ViewModifier {
    @Environment(\.dimensions) private var dimensions
    @Environment(\.popupInsets) private var insets
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var manager: PopupManager

    public init(manager: PopupManager = .init()) { _manager = State(initialValue: manager) }

    public func body(content: Content) -> some View {
        content
            .environment(\.popupManager, manager)
            .accessibilityHidden(manager.popup != nil)
            .allowsHitTesting(manager.popup == nil)
            .overlay {
                GeometryReader { geometry in
                    if let popup = manager.popup {
                        popupOverlay(popup, size: geometry.size)
                            .environment(\.safeAreaInsets, geometry.safeAreaInsets)
                    }
                }
            }
            .animation(reduceMotion ? nil : .easeInOut(duration: 0.2), value: manager.popup?.id)
    }

    private func popupOverlay(_ popup: Popup, size: CGSize) -> some View {
        ZStack(alignment: popup.type == .sheet ? .bottom : .center) {
            Color.black.opacity(0.4)
                .ignoresSafeArea()
                .onTapGesture { if popup.dismissOnBackgroundTap { manager.hide(id: popup.id) } }
                .accessibilityHidden(true)

            popup.style.makeBody(
                configuration: .init(
                    close: { manager.hide(id: popup.id) },
                    content: { popup.content }
                )
            )
            .frame(maxWidth: .infinity)
            .frame(maxHeight: max(0, size.height - padding.top - padding.bottom))
            .background(
                popup.style.background,
                in: RoundedRectangle(cornerRadius: dimensions.cornerRadiusLarge)
            )
            .padding(padding)
            .accessibilityAddTraits(.isModal)
            .accessibilityAction(.escape) { manager.hide(id: popup.id) }
            .transition(reduceMotion ? .opacity : .move(edge: .bottom).combined(with: .opacity))
        }
        .frame(width: size.width, height: size.height)
    }

    private var padding: EdgeInsets {
        insets.edgeInsets
            ?? EdgeInsets(
                top: dimensions.spaceLargeExtra,
                leading: dimensions.spaceLargeExtra,
                bottom: dimensions.spaceLargeExtra,
                trailing: dimensions.spaceLargeExtra
            )
    }
}
