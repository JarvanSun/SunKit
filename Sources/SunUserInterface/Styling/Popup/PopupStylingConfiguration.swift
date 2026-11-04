//
//  PopupStylingConfiguration.swift
//  SunUserInterface
//
//  Created by Jiawen Sun on 2023/4/19.
//

import SwiftUI

@MainActor
public struct PopupStylingConfiguration {
    public let content: AnyView
    private let closeAction: () -> Void

    public init<Content: View>(close: @escaping () -> Void, @ViewBuilder content: () -> Content) {
        self.closeAction = close
        self.content = AnyView(content())
    }
    public func close() { closeAction() }
}
