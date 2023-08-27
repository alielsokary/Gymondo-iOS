//
//  ViewModelSpy.swift
//  GymondoiOSTests
//
//  Created by Ali Elsokary on 27/08/2023.
//

import Foundation
import Combine
import Gymondo

class ViewModelSpy: ExerciseListViewModelLogic {

    @Published var _isLoading: Bool = false
    var isLoading: Published<Bool>.Publisher { $_isLoading }

    let item0 = ExerciseItemViewModel(id: 1, name: "Item", images: nil, mainImageURL: nil, variations: nil, exerciseBase: nil)

    var exercicesViewModel: [Gymondo.ExerciseItemViewModel] {
        [item0]
    }

    var exercisesSubject = PassthroughSubject<[Gymondo.ExerciseItemViewModel], Error>()

    var title: String {
        return "Gymondo"
    }

    var loadCallCount: Int = 0

    func start() {
        _isLoading = true
        loadCallCount += 1
    }

    func completeExerciseLoading() {
        _isLoading = false
        exercisesSubject.send(exercicesViewModel)
    }

    func completeExerciseLoadingWith(with items: [ExerciseItem]) {
        let exerciseViewModel = items.map { ExerciseItemViewModel(id: $0.id.unwrapped, name: $0.name.unwrapped, images: $0.images.unwrapped, mainImageURL: $0.images?.first?.image.unwrapped, variations: $0.variations.unwrapped, exerciseBase: $0.exerciseBase.unwrapped)}

        exercisesSubject.send(exerciseViewModel)
    }
}
