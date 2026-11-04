//
//  ClosablePopupStyle.swift
//  SunUserInterface
//
//  Created by Jiawen Sun on 2023/4/19.
//

import SwiftUI

public struct ClosablePopupStyle<Icon: View>: PopupStyling {
    @Environment(\.dimensions) private var dimensions
    public let background: Color
    private let icon: Icon
    private let closeLabel: LocalizedStringKey

    public init(background: Color, closeLabel: LocalizedStringKey, @ViewBuilder icon: () -> Icon) {
        self.background = background
        self.closeLabel = closeLabel
        self.icon = icon()
    }

    public func makeBody(configuration: PopupStylingConfiguration) -> some View {
        VStack(alignment: .trailing, spacing: dimensions.spaceSmall) {
            Button(action: configuration.close) { icon }
                .accessibilityLabel(Text(closeLabel))

            ViewThatFits(in: .vertical) {
                configuration.content
                ScrollView { configuration.content }
            }
        }
        .padding(dimensions.spaceLargeSmall)
    }
}
