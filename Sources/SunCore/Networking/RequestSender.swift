//
//  RequestSender.swift
//  SunCore
//
//  Created by Jiawen Sun on 2023/3/28.
//

import Foundation

public struct RequestSender: RequestSending {
    public typealias Transport = @Sendable (URLRequest) async throws -> (Data, URLResponse)
    private let transport: Transport

    public init(session: URLSession = .shared) {
        transport = { request in try await session.data(for: request) }
    }

    public init(transport: @escaping Transport) { self.transport = transport }

    public func send(_ request: URLRequest) async throws -> HTTPResponse {
        try Task.checkCancellation()
        let (data, response) = try await load(request)
        try Task.checkCancellation()
        guard let response = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }

        return HTTPResponse(data: data, response: response)
    }

    private func load(_ request: URLRequest) async throws -> (Data, URLResponse) {
        do {
            return try await transport(request)
        } catch let error as URLError where error.code == .cancelled {
            throw CancellationError()
        }
    }
}
