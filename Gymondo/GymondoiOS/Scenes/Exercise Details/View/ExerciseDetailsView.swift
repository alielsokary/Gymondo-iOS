//
//  ExerciseDetailsView.swift
//  GymondoiOS
//
//  Created by Ali Elsokary on 25/08/2023.
//

import SwiftUI
import Gymondo

struct ExerciseDetailsView: View {
    var exerciseViewModel: ExerciseItemViewModel
    var body: some View {
        VStack(spacing: 8) {
            AsyncImage(url: URL(string: (exerciseViewModel.imageItem?.image).unwrapped), content: { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            }, placeholder: {
                Color.gray.opacity(0.3)
            })
            
            Text(exerciseViewModel.name)
        }
    }
}
