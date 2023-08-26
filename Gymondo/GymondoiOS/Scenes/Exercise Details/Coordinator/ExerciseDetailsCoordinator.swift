//
//  ExerciseDetailsCoordinator.swift
//  GymondoiOS
//
//  Created by Ali Elsokary on 25/08/2023.
//

import UIKit
import SwiftUI
import Gymondo

class ExerciseDetailsCoordinator: Coordinator {

    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController

    var exerciseItemViewModel: ExerciseItemViewModel!

    init(navigationController: UINavigationController, exerciseItemViewModel: ExerciseItemViewModel) {
        self.navigationController = navigationController
        self.exerciseItemViewModel = exerciseItemViewModel
    }

    @MainActor func start() {
        let viewmodel = ExerciseDetailsViewModel()
        viewmodel.exerciseItemViewModel = exerciseItemViewModel
        let newView = UIHostingController(rootView: ExerciseDetailsView(viewModel: viewmodel))
        navigationController.pushViewController(newView, animated: true)
    }
}
