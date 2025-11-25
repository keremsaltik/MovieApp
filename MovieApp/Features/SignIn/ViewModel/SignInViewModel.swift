//
//  SignInViewModel.swift
//  MovieApp
//
//  Created by Kerem Saltık on 1.11.2025.
//

import Foundation
import Combine
import KeychainAccess

@MainActor
class SignInViewModel: ObservableObject{
    @Published var sessionId: String?
    @Published var errorMessage: String?
    @Published var accountID: Int?
    
    private let keyChain = Keychain(service: K.Keychain.service)
    
    private let networkService = NetworkService()
    
    private let sessionManager = SessionManager()
    
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
    
    
    func handleRedirect(url: URL) async{
        guard url.scheme == K.AppInfo.urlScheme,
              let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
              let approvedToken = components.queryItems?.first(where: { $0.name == "request_token" })?.value else{
            errorMessage = "Geçersiz yönlendirme"
            return
        }
        do{
            let finalSessionID = try await networkService.createSessionID(with: approvedToken)
            let accountDetails = try await networkService.getAccountDetails(sessionID: finalSessionID)
            
            
            
            self.sessionId = finalSessionID
            
            
            self.accountID = accountDetails.id
            
            try keyChain.set(finalSessionID, key: K.Keychain.sessionID)
            
            
            try keyChain.set(String(accountDetails.id), key: K.Keychain.accountID)
            
            sessionManager.loginSuccessful(details: accountDetails)
        }catch{
#if DEBUG
            errorMessage = "Oturum bilgileri alınamadı: \(error.localizedDescription)"
            print("❌ Hata oluştu, Keychain'e yazma işlemi başarısız olmuş olabilir: \(error)")
#endif
        }
    }
    
    
}
