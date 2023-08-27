//
//  ExerciseDetailsViewModel.swift
//  GymondoiOS
//
//  Created by Ali Elsokary on 25/08/2023.
//

import Foundation

@MainActor public class ExerciseDetailsViewModel: ObservableObject {

    @Published public var exerciseName: String = ""
    @Published public var imageUrlString: String?

    @Published public var variationsTitle = "Variations"
    @Published public var exerciseImagesTitle = "Exercise Images"
    @Published public var emptyImagesTitle = "No images available"
    @Published public var emptyVariationsTitle =  "No variations available"

    @Published public var excerciseItemsList = [ExerciseItemViewModel]()
    @Published public var shouldDisplayImagesSection: Bool = false
    @Published public var shouldDisplayVariationsSection: Bool = false
    @Published public var exerciseImages: [ExerciseImageItem] = []

    public init() { }

    public var exerciseItemViewModel: ExerciseItemViewModel? {
        didSet {
            exerciseName =  (exerciseItemViewModel?.name).unwrapped
            exerciseImages = (exerciseItemViewModel?.images).unwrapped
            imageUrlString = (exerciseItemViewModel?.images?.first?.image).unwrapped
            shouldDisplayImagesSection = ((exerciseItemViewModel?.images).unwrapped).isEmpty
            shouldDisplayVariationsSection = !(exerciseItemViewModel?.variations).unwrapped.isEmpty
        }
    }

    var apiService: ExerciseService = ExerciseServiceImpl()

    public func getExerciseVariations() {
        let variations = (exerciseItemViewModel?.variations).unwrapped
        guard !variations.isEmpty else { return }

        variations.forEach { [weak self] variation in
            _ = self?.apiService.dispatch(ExercisesRouter.GetExerciseinfo(variation: variation))
                .sink { completion in
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

                let exerciseVM = ExerciseItemViewModel(id: exerciseID, name: exerciseName, images: images, mainImageURL: mainImageURL, variations: variations, exerciseBase: exerciseBase)
                self?.excerciseItemsList.append(exerciseVM)
            }
        }
    }

    public func resetData() {
        excerciseItemsList = []
    }
}
