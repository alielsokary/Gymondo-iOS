//
//  AsyncImageSectionView.swift
//  GymondoiOS
//
//  Created by Ali Elsokary on 27/08/2023.
//

import SwiftUI

struct AsyncImageSectionView: View {
    @State var urlString: String!
    var body: some View {
        AsyncImage(url: URL(string: urlString), content: { image in
            image
                .resizable()
                .aspectRatio(1.0, contentMode: .fit)
        }, placeholder: {
            Image("logo")
                .resizable()
                .scaledToFit()
        })
    }
}
