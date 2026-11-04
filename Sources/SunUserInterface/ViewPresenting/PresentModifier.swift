//
//  PresentModifier.swift
//  SunUserInterface
//
//  Created by Jiawen Sun on 2023/4/20.
//

import SwiftUI

private struct PresentModifier<Item: Identifiable, Destination: View>: ViewModifier {
    @Binding var item: Item?
    let style: (Item) -> PresentingStyle
    let destination: (Item) -> Destination
    let onDismiss: () -> Void

    func body(content: Content) -> some View {
        content
            .navigationDestination(isPresented: presented(.push)) {
                if let item { destination(item) }
            }
            .sheet(item: filtered(.sheet), onDismiss: onDismiss, content: destination)
            .modifier(
                FullScreenPresentation(
                    item: filtered(.fullScreenCover),
                    destination: destination,
                    onDismiss: onDismiss
                )
            )
            .background {
                Color.clear
                    .popup(showing: presented(.popup)) { if let item { destination(item) } }
                    .id(item?.id)
            }
    }

    private func filtered(_ expected: PresentingStyle) -> Binding<Item?> {
        let presentedID = item?.id
        return Binding(
            get: { item.flatMap { style($0) == expected ? $0 : nil } },
            set: { value in
                if let value {
                    item = value
                } else if let current = item, current.id == presentedID, style(current) == expected
                {
                    item = nil
                }
            }
        )
    }

    private func presented(_ expected: PresentingStyle) -> Binding<Bool> {
        let presentedID = item?.id
        return Binding(
            get: { item.map { style($0) == expected } ?? false },
            set: { value in
                if !value, let current = item, current.id == presentedID, style(current) == expected
                {
                    item = nil
                    onDismiss()
                }
            }
        )
    }
}

private struct FullScreenPresentation<Item: Identifiable, Destination: View>: ViewModifier {
    @Binding var item: Item?
    let destination: (Item) -> Destination
    let onDismiss: () -> Void

    func body(content: Content) -> some View {
        #if os(macOS)
        content.sheet(item: $item, onDismiss: onDismiss, content: destination)
        #else
        content.fullScreenCover(item: $item, onDismiss: onDismiss, content: destination)
        #endif
    }
}

extension View {
    public func present<Item: Identifiable, Destination: View>(
        item: Binding<Item?>,
        style: @escaping (Item) -> PresentingStyle,
        onDismiss: @escaping () -> Void = {},
        @ViewBuilder destination: @escaping (Item) -> Destination
    ) -> some View {
        modifier(
            PresentModifier(
                item: item,
                style: style,
                destination: destination,
                onDismiss: onDismiss
            )
        )
    }
}
