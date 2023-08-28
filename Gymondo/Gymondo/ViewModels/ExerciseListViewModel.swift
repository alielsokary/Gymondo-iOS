//
//  ExerciseListViewModel.swift
//  Gymondo
//
//  Created by Ali Elsokary on 24/08/2023.
//

import Foundation
import Combine

public protocol ExerciseListViewModelLogic {
    typealias Result = Swift.Result<[ExerciseItem], Error>

    var title: String { get }

    var exercicesViewModel: [ExerciseItemViewModel] { get }
    var exercisesSubject: PassthroughSubject<[ExerciseItemViewModel], Error> { get }
    var isLoading: Published<Bool>.Publisher { get }

    func start()
}

public class ExerciseListViewModel: ExerciseListViewModelLogic {

    public var title: String {
        return "Gymondo"
    }

    @Published var _isLoading: Bool = false
    public var isLoading: Published<Bool>.Publisher { $_isLoading }

    var _exercicesViewModel: [ExerciseItemViewModel] = []
    public var exercicesViewModel: [ExerciseItemViewModel] {
        return _exercicesViewModel
    }

    public var exercisesSubject: PassthroughSubject = PassthroughSubject<[ExerciseItemViewModel], Error>()

    private var cancellables = Set<AnyCancellable>()

    private let apiService: ExerciseService!

    public init(apiService: ExerciseService) {
        self.apiService = apiService
    }

    public func start() {
        _isLoading = true
        apiService.dispatch(ExercisesRouter.GetExercises())
            .sink { [weak self] completion in
                switch completion {
                case .finished:
                    break
                case let .failure(error):
                    self?.exercisesSubject.send(completion: .failure(error))
                }
                self?._isLoading = false
            } receiveValue: { [weak self] value in

                if let exerciseViewModels = value.results?.compactMap({ ExerciseItemViewModel(id: $0.id.unwrapped, name: $0.name.unwrapped, images: $0.images.unwrapped, mainImageURL: $0.images?.first?.image.unwrapped, variations: $0.variations.unwrapped, exerciseBase: $0.exerciseBase.unwrapped) }) {
                    self?._exercicesViewModel = exerciseViewModels
                    self?.exercisesSubject.send(exerciseViewModels)
                }

            }.store(in: &cancellables)

    }
}
