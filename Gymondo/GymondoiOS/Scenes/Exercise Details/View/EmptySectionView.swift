//
//  EmptySectionView.swift
//  GymondoiOS
//
//  Created by Ali Elsokary on 27/08/2023.
//

import SwiftUI

struct EmptySectionView: View {
    @State var title: String!
    var body: some View {
        Text(title)
            .foregroundColor(Color.gray)
            .padding(.horizontal, 8)
    }
}
