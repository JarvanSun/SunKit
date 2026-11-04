//
//  APIRequestSending.swift
//  SunCore
//
//  Created by Jiawen Sun on 2023/3/28.
//

public protocol APIRequestSending: Sendable {
    func send<Request: APIRequest>(_ request: Request) async throws -> Request.Response
}
