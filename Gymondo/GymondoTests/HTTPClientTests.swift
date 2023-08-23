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

    func test_init_doesNotRequestDataFromURLRequest() {
        let (sut, _) = makeSUT()
        XCTAssertFalse(sut.dispatchCalled)
    }

    func test_dispatch_requestsDataFromURLRequest() {
        // Given
        let (sut, request) = makeSUT()

        // When
        let cancellable = sut.dispatch(request: request)
            .sink(receiveCompletion: { _ in }, receiveValue: { (_: MockEndpointRouter.ReturnType) in })

        // Then
        XCTAssertTrue(sut.dispatchCalled)
        XCTAssertEqual(sut.capturedRequests.count, 1)
        XCTAssertEqual(sut.capturedRequests[0], request)
        XCTAssertNotNil(cancellable)
    }

    func test_dispatchTwice_requestsDataFromURLRequestTwice() {
        // Given
        let (sut, _) = makeSUT()
        let endpointRouter = MockEndpointRouter()
        let request1 = endpointRouter.asURLRequest(baseURL: "https://example.com")!
        let request2 = endpointRouter.asURLRequest(baseURL: "https://example.com")!

        // When
        _ = sut.dispatch(request: request1)
            .sink(receiveCompletion: { _ in }, receiveValue: { (_: MockEndpointRouter.ReturnType) in })
        _ = sut.dispatch(request: request2)
            .sink(receiveCompletion: { _ in }, receiveValue: { (_: MockEndpointRouter.ReturnType) in })

        // Then
        XCTAssertEqual(sut.capturedRequests.count, 2)
        XCTAssertEqual(sut.capturedRequests[0], request1)
        XCTAssertEqual(sut.capturedRequests[1], request2)
    }

    func test_dispatch_deliversErrorsOnClientError() {
        // Given
        let (sut, request) = makeSUT()
        sut.responseStub = Fail<Data, NetworkRequestError>(error: .invalidRequest)
            .eraseToAnyPublisher()

        var receivedError: NetworkRequestError?

        // When
        _ = sut.dispatch(request: request)
            .sink(receiveCompletion: { completion in
                if case let .failure(error) = completion {
                    receivedError = error
                }
            }, receiveValue: { (_: MockEndpointRouter.ReturnType) in })

        // Then
        XCTAssertTrue(sut.dispatchCalled)
        XCTAssertEqual(receivedError, .invalidRequest)
    }

    func test_dispatch_deliversErrorsOn200HTTPResponseWithInvalidJSON() {
        // Given
        let (sut, request) = makeSUT()
        let responseData = "invalidJSON".data(using: .utf8)!
        sut.responseStub = Just(responseData)
            .setFailureType(to: NetworkRequestError.self)
            .eraseToAnyPublisher()

        var receivedError: NetworkRequestError?

        // When
        _ = sut.dispatch(request: request)
            .sink(receiveCompletion: { completion in
                if case let .failure(error) = completion {
                    receivedError = error
                }
            }, receiveValue: { (_: MockEndpointRouter.ReturnType) in })

        let deccodingErrorMessage = "The data couldn’t be read because it isn’t in the correct format."

        // Then
        XCTAssertTrue(sut.dispatchCalled)
        XCTAssertEqual(receivedError, .decodingError(deccodingErrorMessage))
    }

    func test_dispatch_deliversNoItemsOn200HTTPResponseWithEmptyJSONList() {
        // Given
        let (sut, request) = makeSUT()
        let responseData = "{\"results\": []}".data(using: .utf8)!
        sut.responseStub = Just(responseData)
            .setFailureType(to: NetworkRequestError.self)
            .eraseToAnyPublisher()

        var receivedItems: [ExerciseItem]?

        // When
        _ = sut.dispatch(request: request)
            .sink(receiveCompletion: { _ in }, receiveValue: { items in
                receivedItems = items
            })

        // Then
        XCTAssertTrue(sut.dispatchCalled)
        XCTAssertNil(receivedItems)
    }

    // MARK: - Helpers

    private func makeSUT() -> (sut: HTTPClientSpy, request: URLRequest) {
        let sut = HTTPClientSpy()
        let endpointRouter = MockEndpointRouter()
        let request = endpointRouter.asURLRequest(baseURL: "https://example.com")!
        return (sut, request)
    }

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
