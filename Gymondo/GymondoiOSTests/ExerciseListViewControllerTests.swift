//
//  ExerciseListViewControllerTests.swift
//  GymondoiOSTests
//
//  Created by Ali Elsokary on 24/08/2023.
//

import XCTest
import UIKit
import Combine
@testable import Gymondo
@testable import GymondoiOS

final class ExerciseListViewControllerTests: XCTestCase {

    func test_exerciseView_hasTitle() {
        let (sut, _) = makeSUT()

        sut.loadViewIfNeeded()

        XCTAssertEqual(sut.navigationItem.title, "Gymondo")
    }

    // move to viewModel tests
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
        let (sut, _) = makeSUT()

        sut.loadViewIfNeeded()

        XCTAssertTrue(sut.isShowingLoadingIndicator, "Expected loading indicator when loading starts")
    }

    func test_loadingFeedIndicator_isHiddenWhileLoadingtheExerciseFeed() {
        let (sut, viewModel) = makeSUT()

        sut.loadViewIfNeeded()

        viewModel.completeExerciseLoading()

        XCTAssertFalse(sut.isShowingLoadingIndicator, "Expected loading indicator to be hidden after loading completes")
    }

    func test_startCompletion_rendersSuccessfullyLoadedExercises() {
        let item0 = makeItem(id: 1, uuid: "", name: "Item", exerciseBase: 1, variations: nil)
        let (sut, viewModel) = makeSUT()

        sut.loadViewIfNeeded()

        viewModel.completeExerciseLoadingWith(with: [item0])
        XCTAssertEqual(sut.numberOfRenderedExercisesViews(), 1)

        let view = sut.exerciseItemView(at: 0) as? ExerciseItemCell
        XCTAssertNotNil(view)
        XCTAssertEqual(view?.nameText, item0.name)
    }

    // MARK: - Helpers
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: ExerciseListViewController, viewModel: ViewModelSpy) {
        let viewModel = ViewModelSpy()
        let mockNavigation = MockNavigation()
        let mockCoordinator = MockCoordinator(navigationController: mockNavigation)

        let sut = ExerciseListViewController(coder: mockCoder(), coordinator: mockCoordinator, viewModel: viewModel)!
        trackForMemoryLeaks(viewModel, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, viewModel)
    }

    func mockCoder() -> NSKeyedUnarchiver {
        let object = UIView()
        let data = try! NSKeyedArchiver.archivedData(withRootObject: object, requiringSecureCoding: false)
        let coder = try! NSKeyedUnarchiver(forReadingFrom: data)
        return coder
    }

    class MockNavigation: UINavigationController {

    }

    class MockCoordinator: MainCoordinator {

    }

}
