//
//  ExerciseVariationsSectionView.swift
//  GymondoiOS
//
//  Created by Ali Elsokary on 27/08/2023.
//

import SwiftUI
import Gymondo

struct ExerciseVariationsSectionView: View {
    private var coordinator: ExerciseDetailsCoordinator?
    @ObservedObject private var viewModel: ExerciseDetailsViewModel

    init(coordinator: ExerciseDetailsCoordinator?, viewModel: ExerciseDetailsViewModel) {
        self.coordinator = coordinator
        self.viewModel = viewModel
    }

    var body: some View {
        if viewModel.shouldDisplayVariationsSection {
            LazyVStack(alignment: .leading, spacing: 16) {
                TitleSectionView(title: viewModel.variationsTitle)
                ForEach(viewModel.excerciseItemsList, id: \.self) { viewModel in
                    Button(viewModel.name) {
                        coordinator?.navigateToExerciseVariationDetails(with: viewModel)
                    }.font(.system(size: 16, weight: .bold, design: .default))
                        .padding(.horizontal, 16)
                }
            }
        } else {
            TitleSectionView(title: viewModel.variationsTitle)
            EmptySectionView(title: viewModel.emptyVariationsTitle)
        }
    }
}
