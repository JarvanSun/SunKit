//
//  APIRequest.swift
//  SunCore
//
//  Created by Jiawen Sun on 2023/3/28.
//

import Foundation

public protocol APIRequest: Sendable {
    associatedtype Response: Decodable & Sendable

    var path: [String] { get }
    var method: HTTPMethod { get }
    var queryItems: [URLQueryItem] { get }
    var headers: [String: String] { get }
    var body: RequestBody? { get }
    var timeout: TimeInterval? { get }
    var acceptableStatusCodes: Range<Int> { get }
    var responseDecoding: ResponseDecoding<Response> { get }
}

extension APIRequest {
    public var method: HTTPMethod { .get }
    public var queryItems: [URLQueryItem] { [] }
    public var headers: [String: String] { [:] }
    public var body: RequestBody? { nil }
    public var timeout: TimeInterval? { nil }
    public var acceptableStatusCodes: Range<Int> { 200..<300 }
    public var responseDecoding: ResponseDecoding<Response> { .json }
}
