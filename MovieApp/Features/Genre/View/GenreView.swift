//
//  GenreView.swift
//  MovieApp
//
//  Created by Kerem Saltık on 24.11.2025.
//

import SwiftUI

struct GenreView: View {
    
    @ObservedObject var viewModel: GenreViewModel
    let genreName: String
    
    private let columns: [GridItem] = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    var body: some View {
        ZStack {
                   if viewModel.isLoading {
                       ProgressView()
                   } else if let errorMessage = viewModel.errorMessage {
                       Text(errorMessage).foregroundColor(.red)
                   } else {
                       ScrollView {
                           LazyVGrid(columns: columns, spacing: 20) {
                               ForEach(viewModel.movies) { movie in
                                   NavigationLink(value: Route.movie(movie)) {
                                       MovieCard(movie: movie, width: 172, height: 237)
                                   }
                                   .buttonStyle(.plain)
                                   .onAppear {
                                       let threshold = viewModel.movies.index(viewModel.movies.endIndex, offsetBy: -5)
                                       if let index = viewModel.movies.firstIndex(where: { $0.id == movie.id }),
                                          index == max(threshold, 0) {
                                           
                                           Task { await viewModel.loadNextPage() }
                                       }
                                   }
                               }
                           }
                           .padding()
                           
                           if viewModel.isLoadingNextPage {
                               ProgressView().padding()
                           }
                       }
                   }
               }
               .navigationTitle(genreName)
               .defaultBackground()
           }
}

#Preview {
    GenreView(viewModel: GenreViewModel(genreId: 18), genreName: "Drama")
}
