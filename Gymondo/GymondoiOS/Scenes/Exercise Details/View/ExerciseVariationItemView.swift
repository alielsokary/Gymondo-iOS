//
//  ExerciseVariationItemView.swift
//  GymondoiOS
//
//  Created by Ali Elsokary on 27/08/2023.
//

import SwiftUI
import Gymondo

struct ExerciseVariationItemView: View {
    var viewModel: ExerciseItemViewModel
    var body: some View {
        Text(viewModel.name)
            .padding(.horizontal, 8)
    }
}
