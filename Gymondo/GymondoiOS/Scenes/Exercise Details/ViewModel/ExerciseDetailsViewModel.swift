//
//  ExerciseDetailsViewModel.swift
//  GymondoiOS
//
//  Created by Ali Elsokary on 25/08/2023.
//

import Foundation
import Gymondo

@MainActor class ExerciseDetailsViewModel: ObservableObject {
    @Published private(set) var exerciseName: String?
    @Published private(set) var imageUrl: URL?

    var exerciseItemViewModel: ExerciseItemViewModel? {
        didSet {
            exerciseName =  exerciseItemViewModel?.name
            imageUrl = URL(string: (exerciseItemViewModel?.imageItem?.image).unwrapped)
        }
    }
}
