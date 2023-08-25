//
//  ExerciseListViewModel.swift
//  Gymondo
//
//  Created by Ali Elsokary on 24/08/2023.
//

import Foundation

public protocol ExerciseListViewModelLogic {
    typealias Result = Swift.Result<[ExerciseItem], Error>
    func start(completion: @escaping (Result) -> Void)
}

public class ExerciseListViewModel: ExerciseListViewModelLogic {

    public func start(completion: @escaping (ExerciseListViewModelLogic.Result) -> Void) {

    }

}
