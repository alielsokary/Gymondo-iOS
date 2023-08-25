//
//  ExerciseListViewController+TestHelpers.swift
//  GymondoiOSTests
//
//  Created by Ali Elsokary on 25/08/2023.
//

import UIKit
@testable import GymondoiOS

extension ExerciseListViewController {
    func simulateUserInitiatedExerciseLoad() {
        refreshControl?.simulatePullToRefresh()
    }

    var isShowingLoadingIndicator: Bool {
        return refreshControl?.isRefreshing == true
    }

    func numberOfRenderedExercisesViews() -> Int {
        return tableView.numberOfRows(inSection: exerciseItemsSection)
    }

    func exerciseItemView(at row: Int) -> UITableViewCell? {
        let dataSource = tableView.dataSource
        let index = IndexPath(row: row, section: exerciseItemsSection)
        return dataSource?.tableView(tableView, cellForRowAt: index)
    }

    private var exerciseItemsSection: Int {
        return 0
    }
}
