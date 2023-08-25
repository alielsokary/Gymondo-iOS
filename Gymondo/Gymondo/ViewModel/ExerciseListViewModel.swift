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

    var exerciseList: [ExerciseItem] { get }

    func start(completion: @escaping (Result) -> Void)
}

public class ExerciseListViewModel: ExerciseListViewModelLogic {
    private let apiService: ExerciseService!

    public init(apiService: ExerciseService) {
        self.apiService = apiService
    }

    private var _exerciseList: Exercises?

    public var exerciseList: [ExerciseItem] {
        return (_exerciseList?.results).unwrapped
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
        } receiveValue: { [weak self] value in
            self?._exerciseList = value
            completion(.success(value.results!))
        }

    }

}
