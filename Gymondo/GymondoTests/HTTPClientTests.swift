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

    func test_dispatch_requestsDataFromURLRequest() {
        // Given
        let endpointRouter = MockEndpointRouter()
        let request = endpointRouter.asURLRequest(baseURL: "https://example.com")!

        // When
        let cancellable = httpClientSpy.dispatch(request: request)
            .sink(receiveCompletion: { _ in }, receiveValue: { (_: MockEndpointRouter.ReturnType) in })

        // Then
        XCTAssertTrue(httpClientSpy.dispatchCalled)
        XCTAssertEqual(httpClientSpy.capturedRequests.count, 1)
        XCTAssertEqual(httpClientSpy.capturedRequests[0], request)
    }

    func test_dispatchTwice_requestsDataFromURLRequestTwice() {
        // Given
        let endpointRouter = MockEndpointRouter()
        let request1 = endpointRouter.asURLRequest(baseURL: "https://example.com")!
        let request2 = endpointRouter.asURLRequest(baseURL: "https://example.com")!

        // When
        let cancellable1 = httpClientSpy.dispatch(request: request1)
            .sink(receiveCompletion: { _ in }, receiveValue: { (_: MockEndpointRouter.ReturnType) in })
        let cancellable2 = httpClientSpy.dispatch(request: request2)
            .sink(receiveCompletion: { _ in }, receiveValue: { (_: MockEndpointRouter.ReturnType) in })

        // Then
        XCTAssertEqual(httpClientSpy.capturedRequests.count, 2)
        XCTAssertEqual(httpClientSpy.capturedRequests[0], request1)
        XCTAssertEqual(httpClientSpy.capturedRequests[1], request2)
    }

    func test_dispatch_deliversErrorsOnClientError() {
        // Given
        let endpointRouter = MockEndpointRouter()
        let request = endpointRouter.asURLRequest(baseURL: "https://example.com")!
        httpClientSpy.responseStub = Fail<Data, NetworkRequestError>(error: .invalidRequest)
            .eraseToAnyPublisher()

        var receivedError: NetworkRequestError?

        // When
        _ = httpClientSpy.dispatch(request: request)
            .sink(receiveCompletion: { completion in
                if case let .failure(error) = completion {
                    receivedError = error
                }
            }, receiveValue: { (_: MockEndpointRouter.ReturnType) in })

        // Then
        XCTAssertTrue(httpClientSpy.dispatchCalled)
        XCTAssertEqual(receivedError, .invalidRequest)
    }

    func test_dispatch_deliversErrorsOn200HTTPResponseWithInvalidJSON() {
        // Given
        let endpointRouter = MockEndpointRouter()
        let request = endpointRouter.asURLRequest(baseURL: "https://example.com")!
        let responseData = "invalidJSON".data(using: .utf8)!
        httpClientSpy.responseStub = Just(responseData)
            .setFailureType(to: NetworkRequestError.self)
            .eraseToAnyPublisher()

        var receivedError: NetworkRequestError?

        // When
        _ = httpClientSpy.dispatch(request: request)
            .sink(receiveCompletion: { completion in
                if case let .failure(error) = completion {
                    receivedError = error
                }
            }, receiveValue: { (_: MockEndpointRouter.ReturnType) in })

        let deccodingErrorMessage = "The data couldn’t be read because it isn’t in the correct format."

        // Then
        XCTAssertTrue(httpClientSpy.dispatchCalled)
        XCTAssertEqual(receivedError, .decodingError(deccodingErrorMessage))
    }

    func test_dispatch_deliversNoItemsOn200HTTPResponseWithEmptyJSONList() {
        // Given
        let endpointRouter = MockEndpointRouter()
        let request = endpointRouter.asURLRequest(baseURL: "https://example.com")!
        let responseData = "{\"results\": []}".data(using: .utf8)!
        httpClientSpy.responseStub = Just(responseData)
            .setFailureType(to: NetworkRequestError.self)
            .eraseToAnyPublisher()

        var receivedItems: [ExerciseItem]?

        // When
        _ = httpClientSpy.dispatch(request: request)
            .sink(receiveCompletion: { _ in }, receiveValue: { items in
                receivedItems = items
            })

        // Then
        XCTAssertTrue(httpClientSpy.dispatchCalled)
        XCTAssertNil(receivedItems)
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

struct MockEndpointRouter: EndpointRouter {
    typealias ReturnType = Exercises

    var path: String { return "/mockPath" }
}
