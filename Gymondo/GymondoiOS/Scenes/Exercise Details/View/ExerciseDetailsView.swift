//
//  ExerciseDetailsView.swift
//  GymondoiOS
//
//  Created by Ali Elsokary on 25/08/2023.
//

import SwiftUI
import Gymondo

struct ExerciseDetailsView: View {
    private var coordinator: ExerciseDetailsCoordinator?
    @ObservedObject private var viewModel: ExerciseDetailsViewModel

    init(coordinator: ExerciseDetailsCoordinator?, viewModel: ExerciseDetailsViewModel) {
        self.coordinator = coordinator
        self.viewModel = viewModel
    }

    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 16) {
                AsyncImageSectionView(urlString: viewModel.imageUrlString.unwrapped)
                    .padding(.horizontal, 16)
                ImageListSectionView(viewModel: viewModel)
                ExerciseVariationsSectionView(coordinator: coordinator, viewModel: viewModel)

            }.navigationBarTitle(viewModel.exerciseName)
            .onAppear {
                viewModel.getExerciseVariations()
            }.onDisappear {
                viewModel.resetData()
            }
        }
    }
}
