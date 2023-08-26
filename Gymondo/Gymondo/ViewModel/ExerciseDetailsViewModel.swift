//
//  ExerciseDetailsViewModel.swift
//  GymondoiOS
//
//  Created by Ali Elsokary on 25/08/2023.
//

import Foundation

 @MainActor public class ExerciseDetailsViewModel: ObservableObject {
    @Published public var exerciseName: String?
    @Published public var imageUrl: URL?

    @Published public var variationsTitle = "Variations"
    @Published public var exerciseImagesTitle = "Exercise Images"

    @Published public var excerciseItemsList = [ExerciseItemViewModel]()
    public init() { }

    public var exerciseItemViewModel: ExerciseItemViewModel? {
        didSet {
            exerciseName =  exerciseItemViewModel?.name
            imageUrl = URL(string: (exerciseItemViewModel?.images?.first?.image).unwrapped)
        }
    }

    var apiService: ExerciseService = ExerciseServiceImpl()

    public func getExerciseVariations() {
        let variations = (exerciseItemViewModel?.variations).unwrapped
        guard !variations.isEmpty else { return }

        variations.forEach { [weak self] variation in
            _ = self?.apiService.dispatch(ExercisesRouter.GetExerciseinfo(path: "/exercise/\(variation)", method: .get)).sink { completion in
                switch completion {
                case .finished: break
                case let .failure(error):
                    print(error)
                }
            } receiveValue: { [weak self] exerciseItem in
                let exerciseID = (exerciseItem.id).unwrapped
                let exerciseName = (exerciseItem.name).unwrapped
                let variations = (exerciseItem.variations).unwrapped
                let exerciseBase = (exerciseItem.exerciseBase).unwrapped
                let images = (exerciseItem.images)
                let mainImageURL = (exerciseItem.images?.first)?.image

                let exerciceVM = ExerciseItemViewModel(id: exerciseID, name: exerciseName, images: images, mainImageURL: mainImageURL, variations: variations, exerciseBase: exerciseBase)
                self?.excerciseItemsList.append(exerciceVM)
            }
        }
    }

     public func resetData() {
         excerciseItemsList = []
     }
}
