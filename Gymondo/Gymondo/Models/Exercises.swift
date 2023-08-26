//
//  Exercises.swift
//  Gymondo
//
//  Created by Ali Elsokary on 22/08/2023.
//

import Foundation

// MARK: - Exercises
public struct Exercises: Codable {
    let results: [ExerciseItem]?
}

// MARK: - ExerciseItem
public struct ExerciseItem: Codable, Equatable {
    public let id: Int?
    public let uuid, name: String?
    public let exerciseBase: Int?
    public let description: String?
    public let images: [ExerciseImageItem]?
    public let created: String?
    public let variations: [Int]?

    public init(id: Int?, uuid: String?, name: String?, exerciseBase: Int?, description: String?, images: [ExerciseImageItem]?, created: String?, variations: [Int]?) {
        self.id = id
        self.uuid = uuid
        self.name = name
        self.exerciseBase = exerciseBase
        self.description = description
        self.images = images
        self.created = created
        self.variations = variations
    }

    enum CodingKeys: String, CodingKey {
        case id, uuid, name
        case exerciseBase = "exercise_base"
        case description, images, created
        case variations
    }

    public static func == (lhs: ExerciseItem, rhs: ExerciseItem) -> Bool {
        return lhs.id == rhs.id && lhs.name == rhs.name
    }
}
