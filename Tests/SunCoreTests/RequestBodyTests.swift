//
//  RequestBodyTests.swift
//  SunCore
//
//  Created by Jiawen Sun on 2023/3/28.
//

import Foundation
import SunCore
import Testing

struct RequestBodyTests {
    @Test func encodeWhenBodyIsRawThenPreservesBytesAndContentType() throws {
        // Given
        let body = RequestBody.raw(Data([0, 255, 128]), contentType: "application/octet-stream")

        // When
        let data = try body.encode(using: JSONEncoder())

        // Then
        #expect(data == Data([0, 255, 128]))
        #expect(body.contentType == "application/octet-stream")
    }

    @Test func encodeWhenPayloadCannotEncodeThenPreservesEncodingError() {
        // Given
        let body = RequestBody.json(Double.nan)

        // When
        let result = Result { try body.encode(using: JSONEncoder()) }

        // Then
        #expect(throws: EncodingError.self) { try result.get() }
    }
}
