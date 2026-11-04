//
//  RequestSenderTests.swift
//  SunCore
//
//  Created by Jiawen Sun on 2023/3/28.
//

import Foundation
import SunCore
import Testing

struct RequestSenderTests {
    @Test(arguments: [200, 201, 299, 400, 401, 404, 500, 503])
    func sendWhenTransportReturnsHTTPThenPreservesResponse(status: Int) async throws {
        // Given
        let url = URL(string: "https://example.test/resource")!
        let response = HTTPURLResponse(
            url: url,
            statusCode: status,
            httpVersion: nil,
            headerFields: ["X-Request-ID": "request-1"]
        )!
        let sender = RequestSender { _ in (Data([1, 2, 3]), response) }

        // When
        let result = try await sender.send(URLRequest(url: url))

        // Then
        #expect(result.data == Data([1, 2, 3]))
        #expect(result.statusCode == status)
        #expect(result.response.value(forHTTPHeaderField: "X-Request-ID") == "request-1")
    }

    @Test func sendWhenResponseIsNotHTTPThenThrowsInvalidResponse() async {
        // Given
        let url = URL(string: "https://example.test/resource")!
        let sender = RequestSender { _ in
            (
                Data(),
                URLResponse(
                    url: url,
                    mimeType: nil,
                    expectedContentLength: 0,
                    textEncodingName: nil
                )
            )
        }

        // When
        let task = Task { try await sender.send(URLRequest(url: url)) }

        // Then
        await #expect(throws: NetworkError.invalidResponse) { try await task.value }
    }

    @Test func sendWhenTransportFailsThenPreservesOriginalError() async {
        // Given
        let url = URL(string: "https://example.test/resource")!
        let sender = RequestSender { _ in throw URLError(.timedOut) }

        // When
        let result = await Task { try await sender.send(URLRequest(url: url)) }.result

        // Then
        #expect(throws: URLError(.timedOut)) { try result.get() }
    }

    @Test func sendWhenURLLoadIsCancelledThenThrowsCancellationError() async {
        // Given
        let sender = RequestSender { _ in throw URLError(.cancelled) }
        let request = URLRequest(url: URL(string: "https://example.test")!)

        // When
        let task = Task { try await sender.send(request) }

        // Then
        await #expect(throws: CancellationError.self) { try await task.value }
    }

    @Test func sendWhenTaskIsCancelledThenDoesNotStartTransport() async {
        // Given
        let url = URL(string: "https://example.test/resource")!
        let sender = RequestSender { _ in
            Issue.record("Transport started after cancellation")
            throw URLError(.unknown)
        }

        // When
        let task = Task {
            withUnsafeCurrentTask { $0?.cancel() }
            return try await sender.send(URLRequest(url: url))
        }

        // Then
        await #expect(throws: CancellationError.self) { try await task.value }
    }

    @Test func sendWhenCancelledDuringTransportThenDiscardsResponse() async {
        // Given
        let url = URL(string: "https://example.test/resource")!
        let sender = RequestSender { _ in
            withUnsafeCurrentTask { $0?.cancel() }
            return (
                Data(),
                HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!
            )
        }

        // When
        let result = await Task { try await sender.send(URLRequest(url: url)) }.result

        // Then
        #expect(throws: CancellationError.self) { try result.get() }
    }
}
