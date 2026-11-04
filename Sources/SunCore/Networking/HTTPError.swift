//
//  HTTPError.swift
//  SunCore
//
//  Created by Jiawen Sun on 2023/3/28.
//

public struct HTTPError: Error, Sendable {
    public let response: HTTPResponse

    public init(response: HTTPResponse) { self.response = response }
}
