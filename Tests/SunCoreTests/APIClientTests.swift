//
//  APIClientTests.swift
//  SunCore
//
//  Created by Jiawen Sun on 2023/3/28.
//

import Foundation
import SunCore
import Testing

struct APIClientTests {
    @Test(arguments: [200, 201, 299])
    func sendWhenHTTPStatusIsSuccessfulThenDecodesTypedResponse(status: Int) async throws {
        // Given
        let client = client(data: Data(#"{"title":"Lamp"}"#.utf8), status: status)
        let request = TestRequest<Payload>()

        // When
        let value = try await client.send(request)

        // Then
        #expect(value.title == "Lamp")
    }

    @Test(arguments: [400, 401, 404, 500, 503])
    func sendWhenHTTPStatusIsFailureThenPreservesErrorResponse(status: Int) async throws {
        // Given
        let data = Data(#"{"message":"Rejected"}"#.utf8)
        let client = client(data: data, status: status, headers: ["X-Request-ID": "request-1"])
        let request = TestRequest<Payload>()

        // When
        let result = await Task { try await client.send(request) }.result

        // Then
        guard case .failure(let error) = result else {
            Issue.record("Expected HTTP failure")
            return
        }

        let failure = try #require(error as? HTTPError)
        #expect(failure.response.statusCode == status)
        #expect(failure.response.data == data)
        #expect(failure.response.response.value(forHTTPHeaderField: "X-Request-ID") == "request-1")
    }

    @Test func sendWhenRequestIsPOSTThenEncodesAndDecodesPayload() async throws {
        // Given
        let sender = RequestSender { request in
            (
                request.httpBody ?? Data(),
                HTTPURLResponse(
                    url: request.url!,
                    statusCode: 201,
                    httpVersion: nil,
                    headerFields: nil
                )!
            )
        }
        let client = APIClient(sender: sender, requestBuilder: builder)
        let request = TestRequest<Payload>(method: .post, body: .json(Payload(title: "New Lamp")))

        // When
        let value = try await client.send(request)

        // Then
        #expect(value.title == "New Lamp")
    }

    @Test func sendWhenDELETEHasNoContentThenReturnsDeclaredEmptyResponse() async throws {
        // Given
        let client = client(data: Data(), status: 204)
        let request = TestRequest<EmptyResponse>(method: .delete, responseDecoding: .empty)

        // When
        let value = try await client.send(request)

        // Then
        #expect(value == EmptyResponse())
    }

    @Test func sendWhenJSONResponseHasNoBodyThenThrowsDecodingError() async {
        // Given
        let client = client(data: Data(), status: 204)
        let request = TestRequest<Payload>()

        // When
        let result = await Task { try await client.send(request) }.result

        // Then
        #expect(throws: DecodingError.self) { try result.get() }
    }

    @Test func sendWhenSuccessPayloadIsMalformedThenPreservesDecodingError() async {
        // Given
        let client = client(data: Data("broken".utf8), status: 200)
        let request = TestRequest<Payload>()

        // When
        let result = await Task { try await client.send(request) }.result

        // Then
        #expect(throws: DecodingError.self) { try result.get() }
    }

    @Test func sendWhenAcceptedStatusesAreOverriddenThenUsesRequestPolicy() async throws {
        // Given
        let client = client(data: Data(#"{"title":"Cached"}"#.utf8), status: 304)
        let request = TestRequest<Payload>(acceptableStatusCodes: 304..<305)

        // When
        let value = try await client.send(request)

        // Then
        #expect(value.title == "Cached")
    }

    @Test func sendWhenEncodingFailsThenDoesNotStartTransport() async {
        // Given
        let sender = RequestSender { _ in
            Issue.record("Transport started after encoding failure")
            throw URLError(.unknown)
        }
        let client = APIClient(sender: sender, requestBuilder: builder)
        let request = TestRequest<Payload>(method: .post, body: .json(Double.nan))

        // When
        let result = await Task { try await client.send(request) }.result

        // Then
        #expect(throws: EncodingError.self) { try result.get() }
    }

    @Test func sendWhenRequestIsCancelledThenDoesNotStartTransport() async {
        // Given
        let sender = RequestSender { _ in
            Issue.record("Transport started after cancellation")
            throw URLError(.unknown)
        }
        let client = APIClient(sender: sender, requestBuilder: builder)
        let request = TestRequest<Payload>()

        // When
        let result = await Task {
            withUnsafeCurrentTask { $0?.cancel() }
            return try await client.send(request)
        }.result

        // Then
        #expect(throws: CancellationError.self) { try result.get() }
    }

    private var builder: RequestBuilder {
        RequestBuilder(baseURL: URL(string: "https://example.test/v1")!)
    }

    private func client(data: Data, status: Int, headers: [String: String] = [:]) -> APIClient {
        APIClient(
            sender: RequestSender { request in
                (
                    data,
                    HTTPURLResponse(
                        url: request.url!,
                        statusCode: status,
                        httpVersion: nil,
                        headerFields: headers
                    )!
                )
            },
            requestBuilder: builder
        )
    }
}

private struct TestRequest<Value: Decodable & Sendable>: APIRequest {
    typealias Response = Value
    var path: [String] = ["products"]
    var method: HTTPMethod = .get
    var body: RequestBody?
    var acceptableStatusCodes: Range<Int> = 200..<300
    var responseDecoding: ResponseDecoding<Value> = .json
}

private struct Payload: Codable, Equatable, Sendable { let title: String }
