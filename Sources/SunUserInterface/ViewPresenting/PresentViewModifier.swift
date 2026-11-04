//
//  PresentViewModifier.swift
//  SunUserInterface
//
//  Created by Jiawen Sun on 2023/4/20.
//

import SwiftUI

private struct PresentedView<Content: View>: Identifiable {
    let id: UUID
    let content: Content
}

private struct PresentViewModifier<Destination: View>: ViewModifier {
    @State private var id = UUID()
    @Binding var destination: Destination?
    let style: PresentingStyle
    let onDismiss: () -> Void

    func body(content: Content) -> some View {
        content.present(
            item: item,
            style: { _ in style },
            onDismiss: onDismiss,
            destination: { $0.content }
        )
    }

    private var item: Binding<PresentedView<Destination>?> {
        Binding(
            get: { destination.map { PresentedView(id: id, content: $0) } },
            set: { value in
                destination = value?.content
                if value == nil { id = UUID() }
            }
        )
    }
}

extension View {
    public func present<Destination: View>(
        destination: Binding<Destination?>,
        _ style: PresentingStyle,
        onDismiss: @escaping () -> Void = {}
    ) -> some View {
        modifier(PresentViewModifier(destination: destination, style: style, onDismiss: onDismiss))
    }

    public func present<Destination: View>(
        isPresented: Binding<Bool>,
        destination: Destination,
        _ style: PresentingStyle,
        onDismiss: @escaping () -> Void = {}
    ) -> some View {
        present(
            destination: Binding(
                get: { isPresented.wrappedValue ? destination : nil },
                set: { isPresented.wrappedValue = $0 != nil }
            ),
            style,
            onDismiss: onDismiss
        )
    }
}
