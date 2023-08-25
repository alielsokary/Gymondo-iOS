//
//  ExerciseListViewController.swift
//  GymondoiOS
//
//  Created by Ali Elsokary on 24/08/2023.
//

import UIKit
import Gymondo

final class ExerciseListViewController: UITableViewController {
    private var viewModel: (any ExerciseListViewModelLogic)?
    private var model = [ExerciseItem]()
    convenience init(viewModel: any ExerciseListViewModelLogic) {
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
        viewModel?.start { [weak self] result in
            self?.model = (try? result.get()) ?? []
            self?.refreshControl?.endRefreshing()
        }
    }
}

extension ExerciseListViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        model.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellModel: ExerciseItem = model[indexPath.row]
        let cell = ExerciseItemCell()
        cell.nameLabel.text = cellModel.name
        return cell
    }
}
