//
//  LocalizedText.swift
//  SunUserInterface
//
//  Created by Jiawen Sun on 2023/4/19.
//

import SwiftUI

public struct LocalizedText: View {
    @Environment(\.locale) private var locale
    private let string: LocalizedString
    public init(_ string: LocalizedString) { self.string = string }
    public var body: some View { Text(verbatim: string.resolved(locale: locale)) }
}

#if DEBUG
#Preview("Localized text") {
    LocalizedText(.init(verbatim: "Preview"))
}
#endif
