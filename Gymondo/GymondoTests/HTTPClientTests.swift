//
//  HTTPClientTests.swift
//  GymondoTests
//
//  Created by Ali Elsokary on 22/08/2023.
//

import XCTest
import Combine
@testable import Gymondo

class APIClientTests: XCTestCase {

    var httpClientSpy: HTTPClientSpy!

    override func setUpWithError() throws {
        httpClientSpy = HTTPClientSpy()
    }

    func test_init_doesNotRequestDataFromURLRequest() {
        XCTAssertFalse(httpClientSpy.dispatchCalled)
    }

    // MARK: - Helpers

    class HTTPClientSpy: HTTPClient {
        private(set) var dispatchCalled = false
        private(set) var capturedRequests: [URLRequest] = []

        var responseStub: AnyPublisher<Data, NetworkRequestError>?

        func dispatch<ReturnType: Codable>(request: URLRequest) -> AnyPublisher<ReturnType, NetworkRequestError> {
            dispatchCalled = true
            capturedRequests.append(request)

            if let responseStub = responseStub {
                return responseStub
                    .mapError { _ in
                        NetworkRequestError.invalidRequest
                    }
                    .flatMap { data in
                        Just(data)
                            .decode(type: ReturnType.self, decoder: JSONDecoder())
                            .mapError { error in
                                NetworkRequestError.decodingError(error.localizedDescription)
                            }
                    }
                    .eraseToAnyPublisher()
            } else {
                let errorPublisher = Fail<ReturnType, NetworkRequestError>(error: .error4xx(400))
                    .eraseToAnyPublisher()
                return errorPublisher
            }
        }
    }
}
