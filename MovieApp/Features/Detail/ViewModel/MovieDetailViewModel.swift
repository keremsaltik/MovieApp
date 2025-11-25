//
//  MovieDetailViewModel.swift
//  MovieApp
//
//  Created by Kerem Saltık on 23.10.2025.
//

import Foundation
import Combine
import KeychainAccess

@MainActor
class MovieDetailViewModel: ObservableObject{
    
    @Published var movieDetail: MovieDetailModel?
    private let networkService = NetworkService()
    @Published var isInWatchList = false
    private let keychain = Keychain(service: K.Keychain.service)
    
    init(movieId: Int) {
        Task {
            await fetchMovieDetails(movieID: movieId)
            await fetchAccountStates(for: movieId)
            
        }
    }
    
    private func fetchAccountStates(for movieID: Int) async{
        guard let sessionID = try? keychain.get(K.Keychain.sessionID) else {
            
            return
        }
        
        do{
            let accountState = try await networkService.getAccountStates(for: movieID, sessionID: sessionID)
            
            self.isInWatchList = accountState.watchlist
            
        }catch{
#if DEBUG
            print(error)
#endif
        }
    }
    
    func toggleWatchListStatus() async{
        guard let movie = movieDetail,
              let sessionID = try? keychain.get(K.Keychain.sessionID),
              let accounIDString = try? keychain.get(K.Keychain.accountID),
              let accountID = Int(accounIDString) else {
            return
        }
        
        let shouldBeInWatchList = !isInWatchList
        
        let body = AddMovieToWatchListBody(media_type: "movie", media_id: movie.id, watchlist: shouldBeInWatchList)
        
        do{
            _ = try await networkService.addMovieToWatchlist(sessionId: sessionID, accountId: accountID, body: body)
            
            self.isInWatchList = shouldBeInWatchList
            
        }catch{
        }
    }
    
    func fetchMovieDetails(movieID: Int) async {
        do {
            let fetchedMovie = try await networkService.getMovieById(movieId: movieID)
            
            self.movieDetail = fetchedMovie
            
        } catch {
#if DEBUG
            print(error)
#endif
            
        }
    }
}
