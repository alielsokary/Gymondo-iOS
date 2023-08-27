//
//  ImageListSectionView.swift
//  GymondoiOS
//
//  Created by Ali Elsokary on 27/08/2023.
//

import SwiftUI
import Gymondo

struct ImageListSectionView: View {
    @StateObject var viewModel = ExerciseDetailsViewModel()
    var body: some View {
        if viewModel.shouldDisplayImagesSection {
            TitleSectionView(title: viewModel.exerciseImagesTitle)
            EmptySectionView(title: viewModel.emptyImagesTitle)
        } else {
            VStack(alignment: .leading, spacing: 8) {
                TitleSectionView(title: viewModel.exerciseImagesTitle)
                HStack {
                    ForEach(viewModel.exerciseImages, id: \.self) { url in
                        AsyncImageSectionView(urlString: url.image.unwrapped)
                    }.padding(.horizontal, 8)
                }
            }
        }
    }
}
