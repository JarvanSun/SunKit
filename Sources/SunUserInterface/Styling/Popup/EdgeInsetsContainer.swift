//
//  EdgeInsetsContainer.swift
//  SunUserInterface
//
//  Created by Jiawen Sun on 2023/4/19.
//

import SwiftUI

public struct EdgeInsetsContainer: Sendable {
    public let edgeInsets: EdgeInsets?
    public init(edgeInsets: EdgeInsets? = nil) { self.edgeInsets = edgeInsets }
}
