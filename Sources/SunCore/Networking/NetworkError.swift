//
//  NetworkError.swift
//  SunCore
//
//  Created by Jiawen Sun on 2023/3/28.
//

public enum NetworkError: Error, Equatable, Sendable {
    case invalidURL
    case invalidResponse
    case invalidTimeout
    case unexpectedResponseBody
}
