//
//  CardView.swift
//  GymondoiOS
//
//  Created by Ali Elsokary on 27/08/2023.
//

import SwiftUI
import Gymondo

struct CardView: View {
    var viewModel: ExerciseItemViewModel
    var body: some View {
        VStack(alignment: .leading) {
            Text(viewModel.name)
                .padding(EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 0))
                        .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}
