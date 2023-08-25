//
//  MainCoordinator.swift
//  GymondoApp
//
//  Created by Ali Elsokary on 25/08/2023.
//

import UIKit
import GymondoiOS

class MainCoordinator: NSObject, Coordinator {

    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        navigationController.delegate = self
        let storyboard = Storyboard.Exercises.instance
        let viewController = storyboard.instantiateViewController(identifier: ExerciseListViewController.storyboardID) { coder in
            return ExerciseListViewController(coder: coder)
        }
        navigationController.pushViewController(viewController, animated: false)
    }

    func navigateTo(with data: Data) {

    }

    func childDidFinish(_ child: Coordinator?) {
        for (index, coordinator) in childCoordinators.enumerated() where coordinator === child {
            childCoordinators.remove(at: index)
            break
        }
    }
}

extension MainCoordinator: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        guard let fromViewController = navigationController.transitionCoordinator?.viewController(forKey: .from) else { return }

        if navigationController.viewControllers.contains(fromViewController) {
            return
        }
    }
}
