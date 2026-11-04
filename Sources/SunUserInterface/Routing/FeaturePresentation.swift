//
//  FeaturePresentation.swift
//  SunUserInterface
//
//  Created by Jiawen Sun on 2023/4/20.
//

import Foundation

public struct FeaturePresentation<Destination: FeatureDestination>: Identifiable {
    public let id: UUID
    public let destination: Destination
    public let style: PresentingStyle
    public let navigation: NavigationState<Destination>

    @MainActor
    public init(
        destination: Destination,
        style: PresentingStyle,
        navigation: NavigationState<Destination>? = nil
    ) {
        self.id = UUID()
        self.destination = destination
        self.style = style
        self.navigation = navigation ?? NavigationState()
    }
}
