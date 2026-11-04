//
//  ColorExtensions.swift
//  SunUserInterface
//
//  Created by Jiawen Sun on 2023/2/11.
//

import SwiftUI

#if canImport(UIKit)
import UIKit

extension ColorStyling {
    public var uiColor: UIColor { UIColor(color) }
}
#elseif canImport(AppKit)
import AppKit

extension ColorStyling {
    public var nsColor: NSColor { NSColor(color) }
}
#endif
