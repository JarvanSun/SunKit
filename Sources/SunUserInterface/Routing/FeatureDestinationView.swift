//
//  FeatureDestinationView.swift
//  SunUserInterface
//
//  Created by Jiawen Sun on 2023/4/20.
//

import SwiftUI

public protocol FeatureDestinationView: View {
    associatedtype Destination: FeatureDestination

    var style: PresentingStyle { get }
    var destination: Destination { get }
}

extension FeatureDestinationView {
    public var style: PresentingStyle { .push }
}
