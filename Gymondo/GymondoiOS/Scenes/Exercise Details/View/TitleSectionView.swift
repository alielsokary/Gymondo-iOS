//
//  TitleSectionView.swift
//  GymondoiOS
//
//  Created by Ali Elsokary on 27/08/2023.
//

import SwiftUI

struct TitleSectionView: View {
    @State var title: String!
    var body: some View {
        Spacer()
        Text(title)
            .padding(.horizontal, 8)
            .font(.system(size: 20, weight: .bold))
    }
}
