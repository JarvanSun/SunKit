//
//  HTTPResponse.swift
//  SunCore
//
//  Created by Jiawen Sun on 2023/3/28.
//

import Foundation

public struct HTTPResponse: Sendable {
    public let data: Data
    public let response: HTTPURLResponse

    public init(data: Data, response: HTTPURLResponse) {
        self.data = data
        self.response = response
    }

    public var statusCode: Int { response.statusCode }
}
