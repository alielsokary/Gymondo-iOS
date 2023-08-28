//
//  ExerciseDetailsViewModel.swift
//  GymondoiOS
//
//  Created by Ali Elsokary on 25/08/2023.
//

import Foundation
import Combine

protocol ExerciseDetailsViewModelLogic {
    var exerciseName: String { get }
    var imageUrlString: String? { get }

    var variationsTitle: String { get }
    var exerciseImagesTitle: String { get }
    var emptyImagesTitle: String { get }
    var emptyVariationsTitle: String { get }

    var shouldDisplayImagesSection: Bool { get set }
    var shouldDisplayVariationsSection: Bool { get set }

    var exerciseItemViewModel: ExerciseItemViewModel { get }
    var excerciseItemsList: [ExerciseItemViewModel] { get set }
    var exerciseImages: [ExerciseImageItem] { get set }

    func getExerciseVariations()
    func resetData()
}

public class ExerciseDetailsViewModel: ObservableObject, ExerciseDetailsViewModelLogic {

    let exerciseItemViewModel: ExerciseItemViewModel

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

    private var cancellables = Set<AnyCancellable>()

    private let apiService: ExerciseService!
    public init(apiService: ExerciseService, exerciseItemViewModel: ExerciseItemViewModel) {
        self.apiService = apiService
        self.exerciseItemViewModel = exerciseItemViewModel

        exerciseName =  exerciseItemViewModel.name
        exerciseImages = (exerciseItemViewModel.images).unwrapped
        imageUrlString = (exerciseItemViewModel.images?.first?.image).unwrapped
        shouldDisplayImagesSection = ((exerciseItemViewModel.images).unwrapped).isEmpty
        shouldDisplayVariationsSection = !(exerciseItemViewModel.variations).unwrapped.isEmpty
    }

    public func getExerciseVariations() {
        let variations = (exerciseItemViewModel.variations).unwrapped
        guard !variations.isEmpty else { return }

        variations.forEach { [weak self] variation in
            guard let self = self else { return }
            self.apiService.dispatch(ExercisesRouter.GetExerciseinfo(variation: variation))
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
            }.store(in: &self.cancellables)
        }
    }

    public func resetData() {
        excerciseItemsList = []
    }
}
