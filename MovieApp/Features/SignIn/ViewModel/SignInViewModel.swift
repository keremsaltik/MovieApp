//
//  SignInViewModel.swift
//  MovieApp
//
//  Created by Kerem Saltık on 1.11.2025.
//

import Foundation
import Combine

@MainActor
class SignInViewModel: ObservableObject{
    
    @Published var errorMessage: String?
    private let networkService = NetworkService()
    
    
    
    func loginButtonTapped() async{
        errorMessage = nil
        
        do{
            // Get token from NetworkService
            let token = try await networkService.getNewToken()
            
            // Direct to browser
            networkService.directToTMDB(with: token)
            
        }catch{
            // Error messsage
            errorMessage = "Login process couldn't start \(error.localizedDescription)"
        }
        
    }
    
    
}
