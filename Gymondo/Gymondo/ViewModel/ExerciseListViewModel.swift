//
//  ExerciseListViewModel.swift
//  Gymondo
//
//  Created by Ali Elsokary on 24/08/2023.
//

import Foundation

public protocol ExerciseListViewModelLogic {
    func start(completion: @escaping () -> Void)
}

public class ExerciseListViewModel: ExerciseListViewModelLogic {

    public func start(completion: @escaping () -> Void) {

    }
}
