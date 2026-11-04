//
//  PopupInsetsKey.swift
//  SunUserInterface
//
//  Created by Jiawen Sun on 2023/4/19.
//

import SwiftUI

private struct PopupInsetsKey: EnvironmentKey {
    static let defaultValue = EdgeInsetsContainer()
}

extension EnvironmentValues {
    public var popupInsets: EdgeInsetsContainer {
        get { self[PopupInsetsKey.self] }
        set { self[PopupInsetsKey.self] = newValue }
    }
}
