//
//  PlaceholderModifier.swift
//  SunUserInterface
//
//  Created by Jiawen Sun on 2023/3/28.
//

import SwiftUI

private struct PlaceholderModifier: ViewModifier {
    @Environment(\.placeholderStyle) private var style
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var animated = false
    let active: Bool

    func body(content: Content) -> some View {
        content
            .redacted(reason: active ? .placeholder : [])
            .opacity(active ? (animated ? style.maxOpacity : style.minOpacity) : 1)
            .animation(
                active && !reduceMotion
                    ? .easeInOut(duration: style.duration).repeatForever(autoreverses: true) : nil,
                value: animated
            )
            .onAppear { animated = active && !reduceMotion }
            .onChange(of: active) { _, value in animated = value && !reduceMotion }
            .onChange(of: reduceMotion) { _, value in animated = active && !value }
    }
}

extension View {
    public func placeholderStyle(_ style: some PlaceholderStyling) -> some View {
        environment(\.placeholderStyle, style)
    }
    public func placeholder(_ active: Bool) -> some View {
        modifier(PlaceholderModifier(active: active))
    }
}
