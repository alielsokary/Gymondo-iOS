//
//  ExerciseDetailsView.swift
//  GymondoiOS
//
//  Created by Ali Elsokary on 25/08/2023.
//

import SwiftUI
import Gymondo

struct ExerciseDetailsView: View {
    var coordinator: ExerciseDetailsCoordinator?
    @StateObject var viewModel = ExerciseDetailsViewModel()

    var body: some View {
            VStack(alignment: .leading, spacing: 8) {
                Spacer()
                Text(viewModel.exerciseName.unwrapped)
                    .padding(.horizontal, 8)
                    .font(.system(size: 20, weight: .bold))

                AsyncImage(url: viewModel.imageUrl, content: { image in
                    image
                        .resizable()
                        .aspectRatio(1.0, contentMode: .fit)
                }, placeholder: {
                    Image("logo")
                        .resizable()
                        .scaledToFit()
                })

            }
            .onAppear {
                viewModel.getExerciseVariations()
            }.onDisappear {
                viewModel.resetData()
            }

        VStack(alignment: .leading, spacing: 8) {
            Spacer()
            Spacer()
            Text(viewModel.variationsTitle)
                .padding(.horizontal, 8)
                .font(.system(size: 20, weight: .bold))
            List(viewModel.excerciseItemsList) { viewModel in
                ExerciseVariationItemView(viewModel: viewModel).onTapGesture {
                    coordinator?.navigateToExerciseDetails(with: viewModel)
                }
            }
        }
    }
}

struct ExerciseVariationItemView: View {
    var viewModel: ExerciseItemViewModel
    var body: some View {
        ZStack {
            Text(viewModel.name)
                .padding(.horizontal, 8)
        }

    }
}
