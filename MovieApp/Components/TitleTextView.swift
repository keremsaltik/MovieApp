//
//  TitleTextView.swift
//  MovieApp
//
//  Created by Kerem Saltık on 21.10.2025.
//

import SwiftUI

struct TitleTextView: View {
    let title: String
    let titleFont: Font
    var body: some View {
        Text(title)
            .font(titleFont)
            .foregroundStyle(Color.App.primaryTextColor)
            .fontWeight(.bold)
    }
}

#Preview {
    TitleTextView(title: "Home", titleFont: .title)
}
