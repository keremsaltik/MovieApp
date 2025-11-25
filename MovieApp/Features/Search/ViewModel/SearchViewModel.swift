//
//  SearchViewModel.swift
//  MovieApp
//
//  Created by Kerem Saltık on 17.11.2025.
//

import Foundation
import Combine

@MainActor
class SearchViewModel: ObservableObject{
    
    @Published var searchResults: [MovieModel] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    // For pageing
    @Published var currentQuery = ""
    private var currentPage: Int = 1
    private var totalPages: Int = 1
    private var isLoadingNextPage: Bool = false
    
    private let networkService = NetworkService()
    
    
    init(query: String) {
        self.currentQuery = query
        Task {
            await performSearch()
        }
    }
    
    func performSearch() async{
        isLoading = true
        errorMessage = nil
        
        self.currentPage = 1
        self.totalPages = 1
        self.searchResults = []
        
        
        await fetchAndAppendMovies(for: currentQuery, page: currentPage)
        isLoading = false
        
        
    }
    
    func loadNextPage() async{
        guard !isLoadingNextPage, currentPage < totalPages else {
            return
        }
        
        isLoadingNextPage = true
        await fetchAndAppendMovies(for: currentQuery, page: currentPage + 1)
        isLoadingNextPage = false
    }
    
    /* private func fetchAndAppendMovies(for query: String, page: Int) async{
     do{
     let movieResponse = try await networkService.searchMovies(query: query, page: page)
     
     self.searchResults.append(contentsOf: movieResponse.results)
     self.currentPage = movieResponse.page
     self.totalPages = movieResponse.totalPages
     }catch{
     self.errorMessage = "Failed to fetch movies. \(error.localizedDescription)"
     }
     }*/
    
    private func fetchAndAppendMovies(for query: String, page: Int) async {
        
        do {
            let movieResponse = try await networkService.searchMovies(query: query, page: page)
            
            self.searchResults.append(contentsOf: movieResponse.results)
            self.currentPage = movieResponse.page
            self.totalPages = movieResponse.totalPages
            
            
        } catch {
#if DEBUG
            let errorText = "Arama sırasında bir hata oluştu."
            self.errorMessage = "\(errorText) \(error.localizedDescription)"
            
            print("--- HATA DETAYLARI BAŞLANGIÇ ---")
            dump(error)
            print("--- HATA DETAYLARI BİTİŞ ---")
#endif
        }
    }
}
