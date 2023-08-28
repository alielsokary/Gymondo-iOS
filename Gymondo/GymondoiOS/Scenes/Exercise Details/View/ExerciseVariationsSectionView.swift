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
                    CardView(viewModel: viewModel)
                        .onTapGesture {
                            coordinator?.navigateToExerciseVariationDetails(with: viewModel)
                        }   .frame(width: UIScreen.main.bounds.width, height: 50)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(10)
                }
            }
        } else {
            TitleSectionView(title: viewModel.variationsTitle)
            EmptySectionView(title: viewModel.emptyVariationsTitle)
        }
    }
}