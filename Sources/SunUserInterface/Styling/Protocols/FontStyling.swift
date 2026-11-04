//
//  FontStyling.swift
//  SunUserInterface
//
//  Created by Jiawen Sun on 2023/2/11.
//

import SwiftUI

#if canImport(UIKit)
import UIKit
#endif

public protocol FontStyling: Sendable {
    var size: CGFloat { get }
    var lineHeight: CGFloat { get }
    var nativeLineHeight: CGFloat { get }
    var relativeTo: Font.TextStyle { get }
    var font: Font { get }
    #if canImport(UIKit)
    var uiFont: UIFont { get }
    #endif
}
