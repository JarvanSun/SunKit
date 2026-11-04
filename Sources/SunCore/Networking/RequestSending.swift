//
//  RequestSending.swift
//  SunCore
//
//  Created by Jiawen Sun on 2023/3/28.
//

import Foundation

public protocol RequestSending: Sendable {
    func send(_ request: URLRequest) async throws -> HTTPResponse
}
