//
//  PopupStyling.swift
//  SunUserInterface
//
//  Created by Jiawen Sun on 2023/4/19.
//

import SwiftUI

@MainActor
public protocol PopupStyling {
    associatedtype Result: View
    var background: Color { get }
    @ViewBuilder func makeBody(configuration: PopupStylingConfiguration) -> Result
}
