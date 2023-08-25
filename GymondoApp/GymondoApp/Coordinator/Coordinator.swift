//
//  Coordinator.swift
//  GymondoApp
//
//  Created by Ali Elsokary on 25/08/2023.
//

import UIKit

protocol Coordinator: AnyObject {
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }
    func start()
}
