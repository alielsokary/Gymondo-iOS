//
//  ExerciseListViewController.swift
//  GymondoiOS
//
//  Created by Ali Elsokary on 24/08/2023.
//

import UIKit
import Gymondo

public final class ExerciseListViewController: UITableViewController {

    // MARK: Properties

    private var coordinator: MainCoordinator?
    private var viewModel: (any ExerciseListViewModelLogic)!
    private var model = [ExerciseItem]()

    public required init?(coder: NSCoder, coordinator: MainCoordinator?, viewModel: any ExerciseListViewModelLogic) {
        self.coordinator = coordinator
        self.viewModel = viewModel
        super.init(coder: coder)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View LifeCycle

    public override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableView()
        refresh()
    }
}

// MARK: - Actions

private extension ExerciseListViewController {
    @objc private func refresh() {
        refreshControl?.beginRefreshing()
        viewModel.start { [weak self] result in
            self?.model = (try? result.get()) ?? []
            self?.tableView.reloadData()
            self?.refreshControl?.endRefreshing()
        }
    }
}

// MARK: - Setup UI

private extension ExerciseListViewController {
    func setupUI() {
        self.navigationItem.title = viewModel.title
        self.navigationController?.navigationBar.prefersLargeTitles = true

        let style = UINavigationBarAppearance()
        style.configureWithDefaultBackground()

        style.titleTextAttributes = [.font: UIFont.systemFont(ofSize: 18)]

        self.navigationController?.navigationBar.standardAppearance = style
        self.navigationController?.navigationBar.compactAppearance = style

        self.navigationController?.navigationBar.scrollEdgeAppearance = style

        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
    }

    func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib.init(nibName: ExerciseItemCell.identifier,
                                      bundle: Bundle(for: ExerciseItemCell.self)),
                           forCellReuseIdentifier: ExerciseItemCell.identifier)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 50
    }
}

// MARK: - UITableViewDataSource

extension ExerciseListViewController {
    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.exerciseList.count
    }

    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ExerciseItemCell", for: indexPath) as? ExerciseItemCell else {
            fatalError("Cell do not exists")
        }
        let cellModel: ExerciseItem = viewModel.exerciseList[indexPath.row]

        cell.exerciseNameLabel.text = cellModel.name
        cell.selectionStyle = .none
        return cell
    }
}

// MARK: - UITableViewDelegate

extension ExerciseListViewController {
    public override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}
