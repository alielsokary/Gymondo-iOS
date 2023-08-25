//
//  ExerciseItemViewModel.swift
//  Gymondo
//
//  Created by Ali Elsokary on 25/08/2023.
//

import Foundation

public class ExerciseItemViewModel {
    public let name: String
    public var imageItem: ImageItem?
    public let variations: [Int]?
    public let exerciseBase: Int?

    public init(name: String, imageItem: ImageItem?, variations: [Int]?, exerciseBase: Int?) {
        self.name = name
        self.imageItem = imageItem
        self.variations = variations
        self.exerciseBase = exerciseBase
    }
}
