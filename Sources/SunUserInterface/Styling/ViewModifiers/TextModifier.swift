//
//  TextModifier.swift
//  SunUserInterface
//
//  Created by Jiawen Sun on 2023/4/19.
//

import SwiftUI

public protocol TextModifier {
    func body(text: Text) -> Text
}

extension Text {
    public func modifier(_ modifier: some TextModifier) -> Text { modifier.body(text: self) }
}
