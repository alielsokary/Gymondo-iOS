//
//  ExerciseListViewModelTests.swift
//  GymondoTests
//
//  Created by Ali Elsokary on 28/08/2023.
//

import XCTest
import Combine
@testable import Gymondo

final class ExerciseListViewModelTests: XCTestCase {

    private var cancellables: Set<AnyCancellable> = []

    func test_exercisesSubject_returnsExerciseItemsOnSuccess() {
        let (sut, service) = makeSUT()

        let item0 = makeItem(id: 1, uuid: "uuid1", name: "item0", exerciseBase: 1, variations: nil)
        let item1 = makeItem(id: 2, uuid: "uuid2", name: "item1", exerciseBase: 1, variations: nil)

        let mockedExerciseItems = [
            item0, item1
        ]

        let mockedExercises = Exercises(results: mockedExerciseItems)

        let mockedResponse = Just(mockedExercises)
            .setFailureType(to: NetworkRequestError.self)
            .eraseToAnyPublisher()

        service.mockedResponse = mockedResponse

        let subject = sut.exercisesSubject
        let exp = expectation(description: "Received exercisesSubject value")

        subject.sink { completion in
            switch completion {
            case .finished:
                break
            case .failure:
                XCTFail("Received error from exercisesSubject")
            }

        } receiveValue: { exerciseViewModels in
            exp.fulfill()
            XCTAssertEqual(exerciseViewModels.count, 2)
            XCTAssertEqual(exerciseViewModels[0].id, item0.id)
            XCTAssertEqual(exerciseViewModels[0].name, item0.name)
            XCTAssertEqual(exerciseViewModels[1].id, item1.id)
            XCTAssertEqual(exerciseViewModels[1].name, item1.name)
        }
        .store(in: &cancellables)

        sut.start()

        wait(for: [exp], timeout: 5.0)
    }

    func test_exercisesSubject_returnsErrorOnFailure() {
        let (sut, service) = makeSUT()

        let error = NetworkRequestError.serverError

        let mockedResponse = Result<Exercises, NetworkRequestError>.failure(error)
                .publisher
                .eraseToAnyPublisher()

        service.mockedResponse = mockedResponse

        let subject = sut.exercisesSubject
        let exp = expectation(description: "Received exercisesSubject value")

        subject.sink { completion in
            switch completion {
            case .finished:
                break
            case let .failure(receivedError):
                exp.fulfill()
                XCTAssertEqual(receivedError as! NetworkRequestError, error)
            }

        } receiveValue: { _ in }
        .store(in: &cancellables)

        sut.start()

        wait(for: [exp], timeout: 5.0)
    }

    // MARK: - Helpers

    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: ExerciseListViewModel, service: MockExerciseService) {
        let apiService = MockExerciseService()
        let sut = ExerciseListViewModel(apiService: apiService)
        trackForMemoryLeaks(apiService, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, apiService)
    }
}
