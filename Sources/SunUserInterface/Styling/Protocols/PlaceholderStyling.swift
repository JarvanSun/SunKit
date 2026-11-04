//
//  PlaceholderStyling.swift
//  SunUserInterface
//
//  Created by Jiawen Sun on 2023/3/28.
//

public protocol PlaceholderStyling: Sendable {
    var minOpacity: Double { get }
    var maxOpacity: Double { get }
    var duration: Double { get }
}
