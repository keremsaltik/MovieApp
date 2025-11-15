//
//  MovieDetailViewModel.swift
//  MovieApp
//
//  Created by Kerem Saltık on 23.10.2025.
//

import Foundation
import Combine

@MainActor
class MovieDetailViewModel: ObservableObject{
    
    @Published var movieDetail: MovieDetailModel?
    private let networkService = NetworkService()
    
    init(movieId: Int) {
            // init'in kendisi async olamaz, bu yüzden bir Task başlatıyoruz.
            Task {
                await fetchMovieDetails(movieID: movieId)
            }
        }
    
    func fetchMovieDetails(movieID: Int) async {
        print("➡️ Adım 1: fetchMovieDetails çağrıldı. ID: \(movieID)")
            do {
                let fetchedMovie = try await networkService.getMovieById(movieId: movieID)
                
                self.movieDetail = fetchedMovie
                
            } catch {
                print(error)
                print("❌ HATA: Film detayları çekilemedi. ID: \(movieID), Hata: \(error)")
            }
        }
}
