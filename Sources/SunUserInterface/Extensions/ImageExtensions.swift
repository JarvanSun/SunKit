//
//  ImageExtensions.swift
//  SunUserInterface
//
//  Created by Jiawen Sun on 2023/3/28.
//

import SwiftUI

extension Image {
    public init(style: some ImageStyling) {
        self = style.image
    }
}

extension Label where Title == Text, Icon == Image {
    public init(_ title: LocalizedStringKey, imageStyle: some ImageStyling) {
        self.init {
            Text(title)
        } icon: {
            Image(style: imageStyle)
        }
    }
}
