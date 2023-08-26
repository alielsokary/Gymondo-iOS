//
//  ExerciseItemViewModel.swift
//  Gymondo
//
//  Created by Ali Elsokary on 25/08/2023.
//

import Foundation

public class ExerciseItemViewModel: Identifiable {
    public let id: Int
    public let name: String
    public let mainImageURL: String?
    public var images: [ExerciseImageItem]?
    public let variations: [Int]?
    public let exerciseBase: Int?

    public init(id: Int, name: String, images: [ExerciseImageItem]?, mainImageURL: String?, variations: [Int]?, exerciseBase: Int?) {
        self.id = id
        self.name = name
        self.images = images
        self.mainImageURL = mainImageURL
        self.variations = variations
        self.exerciseBase = exerciseBase
    }
}
