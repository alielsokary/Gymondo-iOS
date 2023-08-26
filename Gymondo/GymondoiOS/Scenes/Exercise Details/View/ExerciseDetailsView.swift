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
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                AsyncImage(url: viewModel.imageUrl, content: { image in
                    image
                        .resizable()
                        .aspectRatio(1.0, contentMode: .fit)
                }, placeholder: {
                    Image("logo")
                        .resizable()
                        .scaledToFit()
                })
                VStack(alignment: .leading, spacing: 16) {
                    ExerciseImagesSection(viewModel: viewModel)
                    ExerciseVariationsSection(coordinator: coordinator, viewModel: viewModel)
                }

            }.navigationBarTitle(viewModel.exerciseName.unwrapped)
            .onAppear {
                viewModel.getExerciseVariations()
            }.onDisappear {
                viewModel.resetData()
            }
        }
    }
}

struct ExerciseImagesSection: View {
    @StateObject var viewModel = ExerciseDetailsViewModel()
    var body: some View {
        if ((viewModel.exerciseItemViewModel?.images).unwrapped).isEmpty {
                SectionTitle(title: viewModel.exerciseImagesTitle)
                EmptySectionText(title: "No images Available")
        } else {
            VStack(alignment: .leading, spacing: 8) {
                SectionTitle(title: viewModel.exerciseImagesTitle)
                HStack {
                    ForEach((viewModel.exerciseItemViewModel?.images).unwrapped, id: \.self) { url in
                        AsyncImage(url: URL(string: (url.image).unwrapped), content: { image in
                            image
                                .resizable()
                                .aspectRatio(1.0, contentMode: .fit)
                        }, placeholder: {
                            Image("logo")
                                .resizable()
                                .scaledToFit()
                        })
                    }.padding(.horizontal, 8)
                }
            }
        }
    }
}

struct ExerciseVariationsSection: View {
    var coordinator: ExerciseDetailsCoordinator?
    @StateObject var viewModel = ExerciseDetailsViewModel()
    var body: some View {
        if !(viewModel.exerciseItemViewModel?.variations).unwrapped.isEmpty {
            VStack(alignment: .leading, spacing: 16) {
                SectionTitle(title: viewModel.variationsTitle)
                ForEach(viewModel.excerciseItemsList, id: \.self) { viewModel in
                    CardView(viewModel: viewModel)
                        .onTapGesture {
                        coordinator?.navigateToExerciseVariationDetails(with: viewModel)
                    }
                        .frame(width: UIScreen.main.bounds.width, height: 50)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(10)
                }
            }
        } else {
            SectionTitle(title: viewModel.variationsTitle)
            EmptySectionText(title: "No variations Available")
        }
    }
}

struct SectionTitle: View {
    @State var title: String!
    var body: some View {
        Spacer()
        Text(title)
            .padding(.horizontal, 8)
            .font(.system(size: 20, weight: .bold))
    }
}

struct ExerciseVariationItemView: View {
    var viewModel: ExerciseItemViewModel
    var body: some View {
        Text(viewModel.name)
            .padding(.horizontal, 8)
    }
}

struct EmptySectionText: View {
    @State var title: String!
    var body: some View {
        Text(title)
            .foregroundColor(Color.gray)
            .padding(.horizontal, 8)
    }
}

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
