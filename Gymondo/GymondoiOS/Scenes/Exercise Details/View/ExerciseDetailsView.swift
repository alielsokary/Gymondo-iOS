//
//  ExerciseDetailsView.swift
//  GymondoiOS
//
//  Created by Ali Elsokary on 25/08/2023.
//

import SwiftUI
import Gymondo

struct ExerciseDetailsView: View {

    @StateObject var viewModel = ExerciseDetailsViewModel()

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 8) {
                Spacer()
                Text(viewModel.exerciseName.unwrapped)
                    .padding(.horizontal, 8)
                    .font(.system(size: 20, weight: .bold))

                AsyncImage(url: viewModel.imageUrl, content: { image in
                    image
                        .resizable()
                        .scaledToFit()
                }, placeholder: {
                    Image("logo")
                        .resizable()
                        .scaledToFit()
                })
            }.background(Color.gray.opacity(0.2))
        }
    }
}
