//
//  ExerciseListViewController.swift
//  GymondoiOS
//
//  Created by Ali Elsokary on 24/08/2023.
//

import UIKit
import Gymondo

public final class ExerciseListViewController: UITableViewController {

    private var coordinator: MainCoordinator?
    private var viewModel: (any ExerciseListViewModelLogic)?
    private var model = [ExerciseItem]()

    public required init?(coder: NSCoder, coordinator: MainCoordinator?, viewModel: any ExerciseListViewModelLogic) {
        self.coordinator = coordinator
        self.viewModel = viewModel
        super.init(coder: coder)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = viewModel?.title
        navigationController?.navigationBar.prefersLargeTitles = true
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
    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        model.count
    }

    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellModel: ExerciseItem = model[indexPath.row]
        let cell = ExerciseItemCell()
        cell.nameLabel.text = cellModel.name
        return cell
    }
}
