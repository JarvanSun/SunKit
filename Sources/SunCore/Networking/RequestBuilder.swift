//
//  RequestBuilder.swift
//  SunCore
//
//  Created by Jiawen Sun on 2023/3/28.
//

import Foundation

public struct RequestBuilder: Sendable {
    private let baseURL: URL
    private let defaultHeaders: [String: String]
    private let timeout: TimeInterval
    private let makeJSONEncoder: @Sendable () -> JSONEncoder

    public init(
        baseURL: URL,
        defaultHeaders: [String: String] = [:],
        timeout: TimeInterval = 20,
        makeJSONEncoder: @escaping @Sendable () -> JSONEncoder = { JSONEncoder() }
    ) {
        self.baseURL = baseURL
        self.defaultHeaders = defaultHeaders
        self.timeout = timeout
        self.makeJSONEncoder = makeJSONEncoder
    }

    public func make<Request: APIRequest>(_ request: Request) throws -> URLRequest {
        let timeout = request.timeout ?? timeout
        guard timeout.isFinite, timeout > 0 else { throw NetworkError.invalidTimeout }

        var result = URLRequest(url: try url(for: request), timeoutInterval: timeout)
        result.httpMethod = request.method.rawValue
        for (name, value) in defaultHeaders { result.setValue(value, forHTTPHeaderField: name) }
        if let body = request.body {
            result.httpBody = try body.encode(using: makeJSONEncoder())
            if let contentType = body.contentType {
                result.setValue(contentType, forHTTPHeaderField: "Content-Type")
            }
        }
        for (name, value) in request.headers { result.setValue(value, forHTTPHeaderField: name) }
        return result
    }

    private func url<Request: APIRequest>(for request: Request) throws -> URL {
        guard var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: false),
            let scheme = components.scheme?.lowercased(),
            ["http", "https"].contains(scheme),
            let host = components.host, !host.isEmpty,
            components.fragment == nil
        else { throw NetworkError.invalidURL }

        let path = try request.path.map { segment in
            guard !segment.isEmpty, segment != ".", segment != "..",
                let encoded = segment.addingPercentEncoding(withAllowedCharacters: Self.unreserved)
            else { throw NetworkError.invalidURL }

            return encoded
        }
        if !path.isEmpty {
            if !components.percentEncodedPath.hasSuffix("/") {
                components.percentEncodedPath += "/"
            }
            components.percentEncodedPath += path.joined(separator: "/")
        }
        let queryItems = (components.queryItems ?? []) + request.queryItems
        if !queryItems.isEmpty {
            components.percentEncodedQuery = try queryItems.map { item in
                let name = try encoded(item.name)
                guard let value = item.value else { return name }

                return try name + "=" + encoded(value)
            }.joined(separator: "&")
        }
        guard let url = components.url else { throw NetworkError.invalidURL }

        return url
    }

    private func encoded(_ value: String) throws -> String {
        guard let encoded = value.addingPercentEncoding(withAllowedCharacters: Self.unreserved)
        else { throw NetworkError.invalidURL }

        return encoded
    }

    private static let unreserved = CharacterSet(
        charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-._~"
    )

}
