//
//  ExerciseItemViewModel.swift
//  Gymondo
//
//  Created by Ali Elsokary on 25/08/2023.
//

import Foundation

public class ExerciseItemViewModel: Identifiable, Hashable {

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

    public static func == (lhs: ExerciseItemViewModel, rhs: ExerciseItemViewModel) -> Bool {
        return lhs.id == rhs.id && lhs.name == rhs.name && lhs.images == rhs.images
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(name)
        hasher.combine(images)
    }
}
