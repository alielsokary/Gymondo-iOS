//
//  ExerciseListViewModel.swift
//  Gymondo
//
//  Created by Ali Elsokary on 24/08/2023.
//

import Foundation

public protocol ExerciseListViewModelLogic {
    typealias Result = Swift.Result<[ExerciseItem], Error>
    var title: String { get }
    func start(completion: @escaping (Result) -> Void)
}

public class ExerciseListViewModel: ExerciseListViewModelLogic {

    private let apiService: ExerciseService!

    public init(apiService: ExerciseService) {
        self.apiService = apiService
    }

    public var title: String {
        return "Gymondo"
    }

    public func start(completion: @escaping (ExerciseListViewModelLogic.Result) -> Void) {
        _ = apiService.dispatch(ExercisesRouter.GetExercises())
            .sink { completion in
            switch completion {
            case .finished: break
            case let .failure(error):
                print(error)
            }
        } receiveValue: { value in
            print("valu", value)
        }

    }

}
