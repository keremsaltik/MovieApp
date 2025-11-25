//
//  HomeViewModel.swift
//  MovieApp
//
//  Created by Kerem Saltık on 16.10.2025.
//

import Foundation
import Combine

class HomeViewModel: ObservableObject{
    
    @Published  var topRatedMovies: [MovieModel] = []
    @Published  var dramaMovies: [MovieModel] = []
    @Published  var comedyMovies: [MovieModel] = []
    @Published var searchResults: [MovieModel] = []
    private let networkService = NetworkService()
    
    
    func clearSearchResults() {
        searchResults = []
    }
    
    func fetchTopRatedMovies() async{
        do{
            
            let fetchedMovies = (try await networkService.getTopRatedMovies())
            
            DispatchQueue.main.async {
                self.topRatedMovies = fetchedMovies.results
            }
            
        }
        catch{
#if DEBUG
            print("Hata oluştu \(error)")
#endif
        }
    }
    
    func fetchDramaMovies() async {
        do {
            
            let fetcehdMovies = try? await networkService.getMoviewsByCategory(byGenre: 18)
            
            DispatchQueue.main.async {
                self.dramaMovies = fetcehdMovies?.results ?? []
            }
        }
    }
    func fetchComedyMovies() async {
        do {
            
            let fetchedMovies = try? await networkService.getMoviewsByCategory(byGenre: 35)
            
            DispatchQueue.main.async {
                self.comedyMovies = fetchedMovies?.results ?? []
            }
            
            
        }
    }
    
    
    
}
