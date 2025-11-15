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
    
    private let keyChain = Keychain(service: "com.MovieApp.bundle.id")
    
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
        guard url.scheme == "movieapptmdb",
              let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
              let approvedToken = components.queryItems?.first(where: { $0.name == "request_token" })?.value else{
            errorMessage = "Geçersiz yönlendirme"
            return
        }
        do{
            let finalSessionID = try await networkService.createSessionID(with: approvedToken)
            let accountDetails = try await networkService.getAccountDetails(sessionID: finalSessionID)
            
            
            print("Giriş başarılı! Session ID: \(finalSessionID)")
            self.sessionId = finalSessionID
            
            print("Giriş başarılı! Session ID: \(accountDetails.id)")
            self.accountID = accountDetails.id
            
            try keyChain.set(finalSessionID, key: "session_id")
            print("Session id başarıyla kaydedildi")
            
            try keyChain.set(String(accountDetails.id), key: "account_id")
            print("Account id başarıyla kaydedildi")
            sessionManager.loginSuccessful(details: accountDetails)
        }catch{
            errorMessage = "Oturum bilgileri alınamadı: \(error.localizedDescription)"
            print("❌ Hata oluştu, Keychain'e yazma işlemi başarısız olmuş olabilir: \(error)")
        }
    }
    
    
}
