//
//  ExerciseListViewControllerTests.swift
//  GymondoiOSTests
//
//  Created by Ali Elsokary on 24/08/2023.
//

import XCTest
import UIKit
@testable import Gymondo
@testable import GymondoiOS

final class ExerciseListViewControllerTests: XCTestCase {

    func test_exerciseView_hasTitle() {
        let (sut, _) = makeSUT()

        sut.loadViewIfNeeded()

        XCTAssertEqual(sut.navigationItem.title, "Gymondo")
    }

    func test_loadExerciseAction_requestsFeedFromViewModel() {
        let (sut, viewModel) = makeSUT()
        XCTAssertEqual(viewModel.loadCallCount, 0, "Expected no loading requests before view is loaded")

        sut.loadViewIfNeeded()
        XCTAssertEqual(viewModel.loadCallCount, 1, "Expected a loading request once view is loaded")

        sut.simulateUserInitiatedExerciseLoad()
        XCTAssertEqual(viewModel.loadCallCount, 2, "Expected another loading request once user initiates a reload")

        sut.simulateUserInitiatedExerciseLoad()
        XCTAssertEqual(viewModel.loadCallCount, 3, "Expected another loading request once user initiates another reload")
    }

    func test_loadingFeedIndicator_isVisibleWhileLoadingtheExerciseFeed() {
        let (sut, viewModel) = makeSUT()

        sut.loadViewIfNeeded()
        XCTAssertTrue(sut.isShowingLoadingIndicator, "Expected loading indicator once view is loaded")

        viewModel.completeFeedLoading(at: 0)
        XCTAssertFalse(sut.isShowingLoadingIndicator, "Expected no loading indicator once loading is completed")

        sut.simulateUserInitiatedExerciseLoad()
        XCTAssertTrue(sut.isShowingLoadingIndicator, "Expected loading indicator once user initiates a reload")

        viewModel.completeFeedLoading(at: 1)
        XCTAssertFalse(sut.isShowingLoadingIndicator, "Expected no loading indicator once user initiated loading is completed")
    }

    func test_startCompletion_rendersSuccessfullyLoadedExercises() {
        let item0 = makeItem(id: 1, uuid: "", name: "Item", exerciseBase: 1)
        let item1 = makeItem(id: 2, uuid: "", name: "Item1", exerciseBase: 2)
        let item2 = makeItem(id: 3, uuid: "", name: "Item2", exerciseBase: 3)
        let item3 = makeItem(id: 4, uuid: "", name: "Item3", exerciseBase: 4)
        let (sut, viewModel) = makeSUT()

        sut.loadViewIfNeeded()

        viewModel.completeFeedLoading(with: [item0], at: 0)
        XCTAssertEqual(sut.numberOfRenderedExercisesViews(), 1)

        let view = sut.exerciseItemView(at: 0) as? ExerciseItemCell
        XCTAssertNotNil(view)
        XCTAssertEqual(view?.nameText, item0.name)

        sut.simulateUserInitiatedExerciseLoad()
        viewModel.completeFeedLoading(with: [item0, item1, item2, item3], at: 1)
    }

    private func makeItem(id: Int?, uuid: String?, name: String?, exerciseBase: Int?) -> ExerciseItem {
        return ExerciseItem(id: id, uuid: uuid, name: name, exerciseBase: exerciseBase, description: nil, created: nil, category: nil, language: nil, variations: nil)
    }

    // MARK: - Helpers
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: ExerciseListViewController, viewModel: ViewModelSpy) {
        let viewModel = ViewModelSpy()
        let sut = ExerciseListViewController(viewModel: viewModel)
        trackForMemoryLeaks(viewModel, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, viewModel)
    }

    class ViewModelSpy: ExerciseListViewModelLogic {
        var title: String {
            return "Gymondo"
        }

        private var completions = [(ExerciseListViewModelLogic.Result) -> Void]()

        var loadCallCount: Int {
            return completions.count
        }

        func start(completion: @escaping (ExerciseListViewModelLogic.Result) -> Void) {
            completions.append(completion)
        }

        func completeFeedLoading(with exercises: [ExerciseItem] = [], at index: Int) {
            completions[index](.success(exercises))
        }
    }
}
