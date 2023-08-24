//
//  ExerciseListViewController.swift
//  GymondoiOS
//
//  Created by Ali Elsokary on 24/08/2023.
//

import UIKit
import Gymondo

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
