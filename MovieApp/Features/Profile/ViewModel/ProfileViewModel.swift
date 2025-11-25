//
//  ProfileViewModel.swift
//  MovieApp
//
//  Created by Kerem Saltık on 9.11.2025.
//

import Foundation
import Combine
import KeychainAccess

@MainActor
class ProfileViewModel: ObservableObject {
    
    @Published var favoriteMovies: [MovieModel] = []
    @Published var isLoading = true
    private let networkService = NetworkService()
    
    private let keychain = Keychain(service: K.Keychain.service)
    
    init() {
            Task {
                await fetchFavoriteMovies()
            }
        }
    
    func fetchFavoriteMovies() async{
        
        
        
        let sessionID = try? keychain.get(K.Keychain.sessionID)
            let accountIDString = try? keychain.get(K.Keychain.accountID)
            
        guard let sessionID = try? keychain.get(K.Keychain.sessionID),
                let accountIDString = try? keychain.get(K.Keychain.accountID),
              let accountID = Int(accountIDString) else{
            return
        }
        
        
        do{
            let fetchedFavoriteMovies = try await networkService.getWatchListMoviesbyAccount(accountId: accountID, sessionID: sessionID)
            
            self.favoriteMovies = fetchedFavoriteMovies.results
           
        }catch{
            #if DEBUG
            print("Hata oluştu \(error)")
            #endif
        }
        self.isLoading = false
    }
    
}
