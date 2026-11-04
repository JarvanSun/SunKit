//
//  HTTPMethod.swift
//  SunCore
//
//  Created by Jiawen Sun on 2023/3/28.
//

public enum HTTPMethod: String, CaseIterable, Sendable {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
    case head = "HEAD"
    case options = "OPTIONS"
}
