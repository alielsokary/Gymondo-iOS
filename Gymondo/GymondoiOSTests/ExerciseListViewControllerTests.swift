//
//  ExerciseListViewControllerTests.swift
//  GymondoiOSTests
//
//  Created by Ali Elsokary on 24/08/2023.
//

import XCTest
import UIKit
@testable import Gymondo

final class ExerciseListViewController: UITableViewController {
    private var viewModel: ExerciseListViewModelLogic?

    convenience init(viewModel: ExerciseListViewModelLogic) {
        self.init()
        self.viewModel = viewModel
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
        refresh()
    }

    @objc private func refresh() {
        refreshControl?.beginRefreshing()
        viewModel?.start { [weak self] in
            self?.refreshControl?.endRefreshing()
        }
    }

}

final class ExerciseListViewControllerTests: XCTestCase {

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

    // MARK: - Helpers
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: ExerciseListViewController, viewModel: ViewModelSpy) {
        let viewModel = ViewModelSpy()
        let sut = ExerciseListViewController(viewModel: viewModel)
        trackForMemoryLeaks(viewModel, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, viewModel)
    }

    class ViewModelSpy: ExerciseListViewModelLogic {

        private var completions = [() -> Void]()

        var loadCallCount: Int {
            return completions.count
        }

        func start(completion: @escaping () -> Void) {
            completions.append(completion)
        }

        func completeFeedLoading(at index: Int) {
            completions[index]()
        }
    }
}

private extension ExerciseListViewController {
    func simulateUserInitiatedExerciseLoad() {
        refreshControl?.simulatePullToRefresh()
    }

    var isShowingLoadingIndicator: Bool {
        return refreshControl?.isRefreshing == true
    }
}

private extension UIRefreshControl {
    func simulatePullToRefresh() {
        allTargets.forEach { target in
            actions(forTarget: target, forControlEvent: .valueChanged)?.forEach {
                (target as NSObject).perform(Selector($0))
            }
        }
    }
}
