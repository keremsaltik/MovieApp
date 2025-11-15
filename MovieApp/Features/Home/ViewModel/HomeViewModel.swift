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
    private let networkService = NetworkService()
    
    func fetchTopRatedMovies() async{
        do{
            
            let fetchedMovies = (try await networkService.getTopRatedMovies())
            //topRatedMovies = try await NetworkService.shared.getTopRatedMovies()
            
            DispatchQueue.main.async {
                self.topRatedMovies = fetchedMovies
            }
            
            print("Başarıyla popüler diziler çekildi: \(topRatedMovies.count)")
        }
        catch{
            print("Hata oluştu \(error)")
        }
    }
    
    func fetchDramaMovies() async {
        do {
            
            let fetcehdMovies = try? await networkService.getMoviewsByCategory(byGenre: 18)
            
            DispatchQueue.main.async {
                self.dramaMovies = fetcehdMovies ?? []
            }
            
            print("Başarıyla drama filmleri çekildi")
        }
    }
    // Komedi için de ayrı bir fonksiyon yapabiliriz
    func fetchComedyMovies() async {
        do {
            
            let fetchedMovies = try? await networkService.getMoviewsByCategory(byGenre: 35)
            
            DispatchQueue.main.async {
                self.comedyMovies = fetchedMovies ?? []
            }
            
            print("Başarıyla komedi filmleri çekildi")
        }
    }
    
}
