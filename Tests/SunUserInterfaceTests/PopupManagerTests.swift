//
//  PopupManagerTests.swift
//  SunUserInterface
//
//  Created by Jiawen Sun on 2023/3/28.
//

import Foundation
import Observation
import SunUserInterface
import SwiftUI
import Testing

@MainActor
struct PopupManagerTests {
    @Test func showWhenPopupAlreadyExistsThenDismissesPreviousPopup() {
        // Given
        let manager = PopupManager()
        var firstDismissals = 0
        var secondDismissals = 0
        let first = Popup(
            style: PlainPopupStyle(),
            onDismiss: { firstDismissals += 1 },
            content: { Text("first") }
        )
        let second = Popup(
            style: PlainPopupStyle(),
            onDismiss: { secondDismissals += 1 },
            content: { Text("second") }
        )
        manager.show(first)

        // When
        manager.show(second)

        // Then
        #expect(manager.popup?.id == second.id)
        #expect(firstDismissals == 1)
        #expect(secondDismissals == 0)
    }

    @Test func hideWhenIDBelongsToPreviousPopupThenKeepsCurrentPopup() {
        // Given
        let manager = PopupManager()
        var firstDismissals = 0
        var secondDismissals = 0
        let first = Popup(
            style: PlainPopupStyle(),
            onDismiss: { firstDismissals += 1 },
            content: { Text("first") }
        )
        let second = Popup(
            style: PlainPopupStyle(),
            onDismiss: { secondDismissals += 1 },
            content: { Text("second") }
        )
        manager.show(first)
        manager.show(second)

        // When
        manager.hide(id: first.id)

        // Then
        #expect(manager.popup?.id == second.id)
        #expect(firstDismissals == 1)
        #expect(secondDismissals == 0)
    }

    @Test func hideCurrentPopupWhenAlreadyDismissedThenDoesNotRepeatCallback() {
        // Given
        let manager = PopupManager()
        var firstDismissals = 0
        var secondDismissals = 0
        let first = Popup(
            style: PlainPopupStyle(),
            onDismiss: { firstDismissals += 1 },
            content: { Text("first") }
        )
        let second = Popup(
            style: PlainPopupStyle(),
            onDismiss: { secondDismissals += 1 },
            content: { Text("second") }
        )
        manager.show(first)
        manager.show(second)
        manager.hideCurrentPopup()

        // When
        manager.hideCurrentPopup()

        // Then
        #expect(manager.popup == nil)
        #expect(secondDismissals == 1)
    }
}
