//
//  ExerciseImageItem.swift
//  Gymondo
//
//  Created by Ali Elsokary on 25/08/2023.
//

// MARK: - ExerciseImageItem
public struct ExerciseImageItem: Codable, Hashable {
    public let id: Int?
    public let uuid: String?
    public let exerciseBase: Int?
    public let exerciseBaseUUID: String?
    public let image: String?
    public let isMain: Bool?

    public init(id: Int?, uuid: String?, exerciseBase: Int?, exerciseBaseUUID: String?, image: String?, isMain: Bool?) {
        self.id = id
        self.uuid = uuid
        self.exerciseBase = exerciseBase
        self.exerciseBaseUUID = exerciseBaseUUID
        self.image = image
        self.isMain = isMain
    }

    enum CodingKeys: String, CodingKey {
        case id, uuid
        case exerciseBase = "exercise_base"
        case exerciseBaseUUID = "exercise_base_uuid"
        case image
        case isMain = "is_main"
    }
}
