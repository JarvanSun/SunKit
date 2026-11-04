//
//  RequestBuilderTests.swift
//  SunCore
//
//  Created by Jiawen Sun on 2023/3/28.
//

import Foundation
import SunCore
import Testing

struct RequestBuilderTests {
    @Test(arguments: HTTPMethod.allCases)
    func makeWhenMethodIsSpecifiedThenSetsHTTPMethod(method: HTTPMethod) throws {
        // Given
        let builder = RequestBuilder(baseURL: URL(string: "https://example.test/v1")!)
        let request = TestRequest(method: method)

        // When
        let result = try builder.make(request)

        // Then
        #expect(result.httpMethod == method.rawValue)
    }

    @Test(arguments: ["https://example.test/v1", "https://example.test/v1/"])
    func makeWhenBaseURLHasVersionPathThenPreservesPrefix(baseURL: String) throws {
        // Given
        let builder = RequestBuilder(baseURL: URL(string: baseURL)!)
        let request = TestRequest(path: ["products", "42"])

        // When
        let result = try builder.make(request)

        // Then
        #expect(result.url?.path == "/v1/products/42")
    }

    @Test func makeWhenPathContainsReservedCharactersThenEncodesSingleSegment() throws {
        // Given
        let builder = RequestBuilder(baseURL: URL(string: "https://example.test/v1")!)
        let request = TestRequest(path: ["items", "a/b %?#☕"])

        // When
        let result = try builder.make(request)
        let url = try #require(result.url)
        let components = try #require(URLComponents(url: url, resolvingAgainstBaseURL: false))

        // Then
        #expect(components.percentEncodedPath == "/v1/items/a%2Fb%20%25%3F%23%E2%98%95")
    }

    @Test func makeWhenQueryHasRepeatedKeysThenPreservesValuesAndOrder() throws {
        // Given
        let builder = RequestBuilder(baseURL: URL(string: "https://example.test/v1?version=1")!)
        let request = TestRequest(queryItems: [
            .init(name: "tag", value: "a+b & c"),
            .init(name: "tag", value: "中文"),
            .init(name: "flag", value: nil),
        ])

        // When
        let result = try builder.make(request)
        let url = try #require(result.url)
        let components = try #require(URLComponents(url: url, resolvingAgainstBaseURL: false))

        // Then
        #expect(components.queryItems == [.init(name: "version", value: "1")] + request.queryItems)
        #expect(components.percentEncodedQuery?.contains("a%2Bb%20%26%20c") == true)
    }

    @Test func makeWhenRequestOverridesHeaderThenMatchesNamesIgnoringCase() throws {
        // Given
        let builder = RequestBuilder(
            baseURL: URL(string: "https://example.test")!,
            defaultHeaders: ["Accept": "application/json", "Authorization": "original"]
        )
        let request = TestRequest(headers: ["authorization": "replacement"])

        // When
        let result = try builder.make(request)

        // Then
        #expect(result.value(forHTTPHeaderField: "Authorization") == "replacement")
        #expect(result.value(forHTTPHeaderField: "Accept") == "application/json")
    }

    @Test func makeWhenBodyIsJSONThenEncodesPayloadAndSetsContentType() throws {
        // Given
        let builder = RequestBuilder(baseURL: URL(string: "https://example.test")!)
        let request = TestRequest(method: .post, body: .json(Payload(displayName: "Sun")))

        // When
        let result = try builder.make(request)
        let object =
            try JSONSerialization.jsonObject(with: #require(result.httpBody)) as? [String: String]

        // Then
        #expect(object == ["displayName": "Sun"])
        #expect(result.value(forHTTPHeaderField: "Content-Type") == "application/json")
    }

    @Test func makeWhenEncoderIsConfiguredThenUsesAppEncodingPolicy() throws {
        // Given
        let builder = RequestBuilder(
            baseURL: URL(string: "https://example.test")!,
            makeJSONEncoder: {
                let encoder = JSONEncoder()
                encoder.keyEncodingStrategy = .convertToSnakeCase
                return encoder
            }
        )
        let request = TestRequest(method: .post, body: .json(Payload(displayName: "Sun")))

        // When
        let result = try builder.make(request)
        let object =
            try JSONSerialization.jsonObject(with: #require(result.httpBody)) as? [String: String]

        // Then
        #expect(object == ["display_name": "Sun"])
    }

    @Test func makeWhenBodyIsAbsentThenDoesNotAddJSONContentType() throws {
        // Given
        let builder = RequestBuilder(baseURL: URL(string: "https://example.test")!)
        let request = TestRequest()

        // When
        let result = try builder.make(request)

        // Then
        #expect(result.httpBody == nil)
        #expect(result.value(forHTTPHeaderField: "Content-Type") == nil)
    }

    @Test func makeWhenTimeoutIsOverriddenThenUsesRequestValue() throws {
        // Given
        let builder = RequestBuilder(baseURL: URL(string: "https://example.test")!, timeout: 20)
        let request = TestRequest(timeout: 5)

        // When
        let result = try builder.make(request)

        // Then
        #expect(result.timeoutInterval == 5)
    }

    @Test(arguments: [0.0, -1.0, Double.infinity, Double.nan])
    func makeWhenTimeoutIsInvalidThenThrows(timeout: Double) {
        // Given
        let builder = RequestBuilder(baseURL: URL(string: "https://example.test")!)
        let request = TestRequest(timeout: timeout)

        // When
        let result = Result { try builder.make(request) }

        // Then
        #expect(throws: NetworkError.invalidTimeout) { try result.get() }
    }

    @Test(arguments: ["file:///tmp/api", "https://example.test/v1#fragment"])
    func makeWhenBaseURLIsInvalidThenThrows(baseURL: String) {
        // Given
        let builder = RequestBuilder(baseURL: URL(string: baseURL)!)
        let request = TestRequest()

        // When
        let result = Result { try builder.make(request) }

        // Then
        #expect(throws: NetworkError.invalidURL) { try result.get() }
    }

    @Test(arguments: ["", ".", ".."])
    func makeWhenPathSegmentIsInvalidThenThrows(segment: String) {
        // Given
        let builder = RequestBuilder(baseURL: URL(string: "https://example.test/v1")!)
        let request = TestRequest(path: [segment])

        // When
        let result = Result { try builder.make(request) }

        // Then
        #expect(throws: NetworkError.invalidURL) { try result.get() }
    }
}

private struct TestRequest: APIRequest {
    typealias Response = EmptyResponse
    var path: [String] = ["items"]
    var method: HTTPMethod = .get
    var queryItems: [URLQueryItem] = []
    var headers: [String: String] = [:]
    var body: RequestBody?
    var timeout: TimeInterval?
}

private struct Payload: Encodable, Sendable { let displayName: String }
