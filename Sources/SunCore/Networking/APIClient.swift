//
//  APIClient.swift
//  SunCore
//
//  Created by Jiawen Sun on 2023/3/28.
//

public struct APIClient: APIRequestSending {
    private let sender: any RequestSending
    private let requestBuilder: RequestBuilder
    private let responseDecoder: ResponseDecoder

    public init(
        sender: any RequestSending,
        requestBuilder: RequestBuilder,
        responseDecoder: ResponseDecoder = .init()
    ) {
        self.sender = sender
        self.requestBuilder = requestBuilder
        self.responseDecoder = responseDecoder
    }

    public func send<Request: APIRequest>(_ request: Request) async throws -> Request.Response {
        try Task.checkCancellation()
        let urlRequest = try requestBuilder.make(request)
        let response = try await sender.send(urlRequest)
        try Task.checkCancellation()
        guard request.acceptableStatusCodes.contains(response.statusCode) else {
            throw HTTPError(response: response)
        }

        let value = try request.responseDecoding.decode(response, using: responseDecoder)
        try Task.checkCancellation()
        return value
    }
}
