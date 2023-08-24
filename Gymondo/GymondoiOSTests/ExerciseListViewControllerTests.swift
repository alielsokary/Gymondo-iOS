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
        viewModel?.start()
    }

    @objc private func refresh() {
        viewModel?.start()
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

    func test_pullToRefresh_loadsExercisees() {
        let (sut, viewModel) = makeSUT()

        sut.loadViewIfNeeded()

        sut.refreshControl?.simulatePullToRefresh()
        XCTAssertEqual(viewModel.loadCallCount, 2)

        sut.refreshControl?.simulatePullToRefresh()
        XCTAssertEqual(viewModel.loadCallCount, 3)
    }

    func test_viewDidLoad_showsLoadingIndicator() {
        let (sut, _) = makeSUT()

        sut.loadViewIfNeeded()

        XCTAssertEqual(sut.refreshControl?.isRefreshing, true)
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

        private(set) var loadCallCount: Int = 0

        func start() {
            loadCallCount += 1
        }
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