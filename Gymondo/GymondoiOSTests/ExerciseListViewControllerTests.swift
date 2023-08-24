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
        refreshControl?.beginRefreshing()
        refresh()
    }

    @objc private func refresh() {
        viewModel?.start { [weak self] in
            self?.refreshControl?.endRefreshing()
        }
    }

}

final class ExerciseListViewControllerTests: XCTestCase {

    func test_init_doesNotLoadExerciseList() {
        let (_, viewModel) = makeSUT()

        XCTAssertEqual(viewModel.loadCallCount, 0)
    }

    func test_viewDidLoad_loadsExerciseList() {
        let (sut, viewModel) = makeSUT()

        sut.loadViewIfNeeded()

        XCTAssertEqual(viewModel.loadCallCount, 1)
    }

    func test_userInitiatedExerciseLoad_loadsExercisees() {
        let (sut, viewModel) = makeSUT()

        sut.loadViewIfNeeded()

        sut.simulateUserInitiatedExerciseLoad()
        XCTAssertEqual(viewModel.loadCallCount, 2)

        sut.simulateUserInitiatedExerciseLoad()
        XCTAssertEqual(viewModel.loadCallCount, 3)
    }

    func test_viewDidLoad_showsLoadingIndicator() {
        let (sut, _) = makeSUT()

        sut.loadViewIfNeeded()

        XCTAssertTrue(sut.isShowingLoadingIndicator)
    }

    func test_viewDidLoad_hidesLoadingIndicatorOnLoaderCompletion() {
        let (sut, viewModel) = makeSUT()

        sut.loadViewIfNeeded()
        viewModel.completeFeedLoading()

        XCTAssertFalse(sut.isShowingLoadingIndicator)
    }

    func test_userInitiatedExerciseLoad_showsLoadingIndicator() {
        let (sut, _) = makeSUT()

        sut.simulateUserInitiatedExerciseLoad()

        XCTAssertTrue(sut.isShowingLoadingIndicator)
    }

    func test_userInitiatedExerciseLoad_hidesLoadingIndicatorOnLoaderCompletion() {
        let (sut, viewModel) = makeSUT()

        sut.simulateUserInitiatedExerciseLoad()
        viewModel.completeFeedLoading()

        XCTAssertFalse(sut.isShowingLoadingIndicator)
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

        func completeFeedLoading() {
            completions[0]()
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
