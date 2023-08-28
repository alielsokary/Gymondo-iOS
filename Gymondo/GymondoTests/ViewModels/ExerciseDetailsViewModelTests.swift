//
//  ExerciseDetailsViewModelTests.swift
//  GymondoTests
//
//  Created by Ali Elsokary on 28/08/2023.
//

import XCTest
import Combine
@testable import Gymondo

final class ExerciseDetailsViewModelTests: XCTestCase {

    private var cancellables: Set<AnyCancellable> = []

    func test_init_containsViewModelItemDetails() {
        let sut = makeSUT()

        XCTAssertNotNil(sut.exerciseItemViewModel)
        XCTAssertEqual(sut.exerciseItemViewModel.id, makeExerciseItemViewModel().id)
        XCTAssertEqual(sut.exerciseItemViewModel.name, makeExerciseItemViewModel().name)
        XCTAssertEqual(sut.exerciseItemViewModel.variations, makeExerciseItemViewModel().variations)
    }

    func test_init_returnsExerciseTitle() {
        let sut = makeSUT()

        XCTAssertEqual(sut.exerciseName, "item0")
    }

    func test_init_returnSectionTitles() {
        let sut = makeSUT()

        XCTAssertEqual(sut.exerciseImagesTitle, "Exercise Images")
        XCTAssertEqual(sut.variationsTitle, "Variations")
    }

    func test_init_returnSectionPlaceholders() {
        let sut = makeSUT()

        XCTAssertEqual(sut.emptyImagesTitle, "No images available")
        XCTAssertEqual(sut.emptyVariationsTitle, "No variations available")
    }

    // MARK: - Helpers

    func makeExerciseItemViewModel() -> ExerciseItemViewModel {
        let item0 = makeItem(id: 1, uuid: "uuid1", name: "item0", exerciseBase: 1, variations: [1, 2, 3])

        return ExerciseItemViewModel(id: item0.id.unwrapped, name: item0.name.unwrapped, images: nil, mainImageURL: nil, variations: item0.variations.unwrapped, exerciseBase: item0.exerciseBase.unwrapped)
    }

    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> ExerciseDetailsViewModel {
        let apiService = MockExerciseService()
        let sut = ExerciseDetailsViewModel(apiService: apiService, exerciseItemViewModel: makeExerciseItemViewModel())
        trackForMemoryLeaks(apiService, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }

}
