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
    
    @Published var favoriteMovies: [Result] = []
    private var hasFetchedData = false
    private let networkService = NetworkService()
    
    private let keychain = Keychain(service: "com.MovieApp.bundle.id")
    
    func fetchFavoriteMovies() async{
        
        guard !hasFetchedData else { return }
        
        let sessionID = try? keychain.get("session_id")
            let accountIDString = try? keychain.get("account_id")
            
            print("Okunan Session ID: \(sessionID ?? "BULUNAMADI")")
            print("Okunan Account ID: \(accountIDString ?? "BULUNAMADI")")
        guard let sessionID = try? keychain.get("session_id"),
                let accountIDString = try? keychain.get("account_id"),
              let accountID = Int(accountIDString) else{
            print("Oturum bilgileri alınamadı")
            return
        }
        
        
        do{
            let fetchedFavoriteMovies = try await networkService.getFavoriteMoviesbyAccount(accountId: accountID, sessionID: sessionID)
            
            self.favoriteMovies = fetchedFavoriteMovies.results
            
            print("Favori filmler başarıyla çekildi: \(favoriteMovies.count)")
        }catch{
            print("Hata oluştu \(error)")
        }
    }
    
}
