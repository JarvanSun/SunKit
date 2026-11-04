//
//  PlainPopupStyle.swift
//  SunUserInterface
//
//  Created by Jiawen Sun on 2023/4/19.
//

import SwiftUI

public struct PlainPopupStyle: PopupStyling {
    public let background: Color
    public init(background: Color = defaultBackground) { self.background = background }
    public static var defaultBackground: Color {
        #if canImport(UIKit)
        Color(uiColor: .systemBackground)
        #elseif canImport(AppKit)
        Color(nsColor: .windowBackgroundColor)
        #else
        .white
        #endif
    }

    public func makeBody(configuration: PopupStylingConfiguration) -> some View {
        ViewThatFits(in: .vertical) {
            configuration.content
            ScrollView { configuration.content }
        }
    }
}

extension PopupStyling where Self == PlainPopupStyle {
    public static var plain: Self { .init() }
}
