//
//  GenreViewModel.swift
//  MovieApp
//
//  Created by Kerem Saltık on 24.11.2025.
//

import Foundation
import Combine

@MainActor
class GenreViewModel: ObservableObject {
    
    @Published var movies: [MovieModel] = []
        @Published var isLoading: Bool = true
        @Published var isLoadingNextPage: Bool = false
        @Published var errorMessage: String?
        
        private let genreId: Int
        private var currentPage: Int = 1
        private var totalPages: Int = 1
        
        private let networkService = NetworkService()
        
        init(genreId: Int) {
            self.genreId = genreId
            Task { await fetchAndAppendMovies(page: 1) }
        }
        
        func loadNextPage() async {
            guard !isLoadingNextPage, currentPage < totalPages else { return }
            isLoadingNextPage = true
            await fetchAndAppendMovies(page: currentPage + 1)
            isLoadingNextPage = false
        }
        
        private func fetchAndAppendMovies(page: Int) async {
            if page == 1 { isLoading = true }
            
            do {
                let movieResponse = try await networkService.getMoviewsByCategory(byGenre: genreId, page: page)
                self.movies.append(contentsOf: movieResponse.results)
                self.currentPage = movieResponse.page
                self.totalPages = movieResponse.totalPages
            } catch {
                self.errorMessage = "Filmler yüklenirken bir hata oluştu."
            }
            
            if page == 1 { isLoading = false }
        }
}
