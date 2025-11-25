//
//  SearchView.swift
//  MovieApp
//
//  Created by Kerem Saltık on 17.11.2025.
//

import SwiftUI

struct SearchView: View {
    
    @StateObject private var viewModel: SearchViewModel
    
    init(query: String) {
        _viewModel = StateObject(wrappedValue: SearchViewModel(query: query))
    }
    
    var body: some View {
        ZStack{
            Color.black.ignoresSafeArea()
            
            if viewModel.isLoading {
                ProgressView()
            }else if let errorMessage = viewModel.errorMessage {
                Text(errorMessage).foregroundStyle(.red)
            }else if viewModel.searchResults.isEmpty {
                ContentUnavailableView.search(text: viewModel.currentQuery)
            }else{
                List(viewModel.searchResults) {
                    movie in
                    NavigationLink(value: Route.movie(movie)){
                        HStack{
                            AsyncImage(url: movie.posterURL){
                                image in
                                image.resizable()
                            } placeholder: {
                                Color.gray.opacity(0.3)
                            }
                            .frame(width: 60, height: 90)
                            .clipShape(Circle())
                            VStack(alignment: .leading) {
                                TitleTextView(title: movie.title, titleFont: Font.App.title3)
                                TitleTextView(title: movie.overview, titleFont: Font.App.subtitle).lineLimit(2)
                            }
                        }
                    }
                    .onAppear {
                        if movie == viewModel.searchResults.last {
                            Task {
                                await viewModel.loadNextPage()
                            }
                        }
                    }
                    .listRowBackground(Color.clear)
                }
                
                .listStyle(.plain)

                
            }
        }
        .navigationTitle("Results for \(viewModel.currentQuery)")
        .defaultBackground()
    }
}

#Preview {
    SearchView(query: "Godfather")
}
