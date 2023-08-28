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
        let apiService: ExerciseService = ExerciseServiceImpl()
        let viewmodel = ExerciseDetailsViewModel(apiService: apiService, exerciseItemViewModel: exerciseItemViewModel)

        let exerciseDetailsView = ExerciseDetailsView(coordinator: self, viewModel: viewmodel)
        let newView = UIHostingController(rootView: exerciseDetailsView)
        navigationController.pushViewController(newView, animated: true)
    }

    @MainActor func navigateToExerciseVariationDetails(with data: ExerciseItemViewModel) {
        let cordinator = ExerciseDetailsCoordinator(navigationController: navigationController, exerciseItemViewModel: data)
        childCoordinators.append(cordinator)
        cordinator.start()
    }
}
