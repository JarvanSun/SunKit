//
//  ImageStylingTests.swift
//  SunUserInterface
//
//  Created by Jiawen Sun on 2023/3/28.
//

import CoreGraphics
import Foundation
import SunUserInterface
import SwiftUI
import Testing

struct ImageStylingTests {
    @Test func imageWhenCalledOutsideMainActorThenResolvesStyle() async {
        // Given
        let style = SystemSymbol()

        // When
        let symbolExists = await Task.detached {
            _ = style.image
            _ = style.image(directory: "nested/icons")
            _ = Image(style: style)
            _ = Label("Symbol", imageStyle: style)
            let tokens = ImageTokens(tokens: ["icon": "missing.asset"])
            #expect(tokens.image(for: "icon", main: .main) == nil)
            #expect(!ImageTokens.assetExists("missing.asset", in: .main))
            return ImageTokens.systemImageExists(style.name)
        }.value

        // Then
        #expect(symbolExists)
    }

    @Test func tokensWhenConsumerDefinesImageThenExposesItsAssetName() {
        // Given
        let image = ConsumerImage()

        // When
        let token = image.tokens.tokens["icon"]

        // Then
        #expect(token == "custom.asset")
    }
}

private struct ConsumerImage: ImageStyling {
    let name = "icon"
    let tokens = ImageTokens(tokens: ["icon": "custom.asset"])
}

private struct SystemSymbol: ImageStyling {
    let name = "checkmark.circle"
}
