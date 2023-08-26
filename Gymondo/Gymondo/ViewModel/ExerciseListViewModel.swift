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

    var exercicesViewModel: [ExerciseItemViewModel] { get }

    func start(completion: @escaping (Result) -> Void)
}

public class ExerciseListViewModel: ExerciseListViewModelLogic {
    private let apiService: ExerciseService!

    public init(apiService: ExerciseService) {
        self.apiService = apiService
    }

    public var exercicesViewModel: [ExerciseItemViewModel] {
        return _exercicesViewModel
    }

    var _exercicesViewModel: [ExerciseItemViewModel] = []

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
            value.results?.forEach({ exerciseItem in
                let exerciseID = (exerciseItem.id).unwrapped

                let exerciseName = (exerciseItem.name).unwrapped
                let variations = (exerciseItem.variations).unwrapped
                let exerciseBase = (exerciseItem.exerciseBase).unwrapped
                let images = (exerciseItem.images)
                let mainImageURL = (exerciseItem.images?.first)?.image

                let exerciceVM = ExerciseItemViewModel(id: exerciseID, name: exerciseName, images: images, mainImageURL: mainImageURL, variations: variations, exerciseBase: exerciseBase)
                self?._exercicesViewModel.append(exerciceVM)
            })
            completion(.success(value.results!))
        }

    }
}
