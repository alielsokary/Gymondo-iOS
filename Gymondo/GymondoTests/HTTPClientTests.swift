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

    func test_dispatch_deliversItemsOn200HTTPResponseWithJSONItems() {
        // Given
        let (sut, request) = makeSUT()

        let item1 = makeItem(id: 1,
                             uuid: "uuid",
                             name: "name",
                             exerciseBase: 3,
                             description: "desc",
                             created: "date",
                             category: 2,
                             language: 2,
                             variations: [1, 2, 3])

        let item2 = makeItem(id: 2,
                             uuid: "uuid",
                             name: "name",
                             exerciseBase: 3,
                             description: "desc",
                             created: "date",
                             category: 2,
                             language: 2,
                             variations: [1, 2, 3])

        let jsonData = makeItemsJSON([item1.json, item2.json])

        sut.responseStub = Just(jsonData)
            .setFailureType(to: NetworkRequestError.self)
            .eraseToAnyPublisher()

        var receivedItems: Exercises?

        // When
        _ = sut.dispatch(request: request)
            .sink(receiveCompletion: { _ in }, receiveValue: { items in
                receivedItems = items
            })

        // Then
        XCTAssertNotNil(receivedItems)
        XCTAssertEqual(receivedItems?.results?.count, 2)
        XCTAssertEqual(receivedItems!.results?.first?.id, item1.model.id)
        XCTAssertEqual(receivedItems!.results?.first?.name, item1.model.name)
        XCTAssertEqual(receivedItems!.results?.last?.id, item2.model.id)
        XCTAssertEqual(receivedItems!.results?.last?.name, item2.model.name)
    }

    // MARK: - Helpers

    private func makeSUT() -> (sut: HTTPClientSpy, request: URLRequest) {
        let sut = HTTPClientSpy()
        let endpointRouter = MockEndpointRouter()
        let request = endpointRouter.asURLRequest(baseURL: "https://example.com")!
        return (sut, request)
    }

    private func makeItem(id: Int?, uuid: String?, name: String?, exerciseBase: Int?, description: String?, created: String?, category: Int?, language: Int?, variations: [Int]?) -> (model: ExerciseItem, json: [String: Any]) {
        let item = ExerciseItem(id: id, uuid: uuid, name: name, exerciseBase: exerciseBase, description: description, created: created, category: category, language: language, variations: variations)
        let json: [String: Any] = [
                    "id": id!,
                    "uuid": uuid!,
                    "name": name!,
                    "exerciseBase": exerciseBase!,
                    "description": description!,
                    "created": created!,
                    "category": category!,
                    "language": language!,
                    "variations": variations!
        ] as [String: Any]
        let mappedJSONValues = json.compactMapValues { $0 }
        return (item, mappedJSONValues)
    }

    private func makeItemsJSON(_ items: [[String: Any]]) -> Data {
        let json = ["results": items]
        return try! JSONSerialization.data(withJSONObject: json)
    }
}

struct MockEndpointRouter: EndpointRouter {
    typealias ReturnType = Exercises

    var path: String { return "/mockPath" }
}
