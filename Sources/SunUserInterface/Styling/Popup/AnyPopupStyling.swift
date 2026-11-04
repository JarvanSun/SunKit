//
//  AnyPopupStyling.swift
//  SunUserInterface
//
//  Created by Jiawen Sun on 2023/4/19.
//

import SwiftUI

public struct AnyPopupStyling: PopupStyling {
    public let background: Color
    private let makeContent: (PopupStylingConfiguration) -> AnyView

    public init(_ style: some PopupStyling) {
        background = style.background
        makeContent = { AnyView(style.makeBody(configuration: $0)) }
    }
    public func makeBody(configuration: PopupStylingConfiguration) -> some View {
        makeContent(configuration)
    }
}

private struct PopupStyleKey: EnvironmentKey {
    static let defaultValue: AnyPopupStyling? = nil
}

extension EnvironmentValues {
    public var popupStyle: AnyPopupStyling? {
        get { self[PopupStyleKey.self] }
        set { self[PopupStyleKey.self] = newValue }
    }
}
