//
//  SessionManager.swift
//  MovieApp
//
//  Created by Kerem Saltık on 1.11.2025.
//

import Foundation
import KeychainAccess
import Combine

class SessionManager: ObservableObject{
    @Published var isLoggedIn = false
    
    @Published var accountDetails: AccountDetailResponse?
    
    private let networkService = NetworkService()
    private let keyChain = Keychain(service: "com.MovieApp.bundle.id")
    
    init() {
        // Check when app started.
        Task{
            await checkAuthentication()
        }    }
    
    
    func checkAuthentication() async{
        guard let sessionID =  try? keyChain.get("session_id") else {
            self.isLoggedIn = false
            self.accountDetails = nil
            return
        }
        
        do{
            let details = try await networkService.getAccountDetails(sessionID: sessionID)
            self.accountDetails = details
            self.isLoggedIn = true
        }catch{
            print("Oturum doğrulaması başarısız: \(error.localizedDescription)")
            await logout()
        }
    }
    
    func loginSuccessful(details: AccountDetailResponse){
        self.accountDetails = details
        self.isLoggedIn = true
    }
    
    func logout() async{
        
        guard let sessionID = try? keyChain.get("session_id") else {
            self.isLoggedIn = false
            self.accountDetails = nil
            return
            
        }

        do{
            let success = try await networkService.deleteSession(sessionId: sessionID)
            
            if success{
                try? keyChain.remove("session_id")
                try keyChain.remove("account_id")
                self.isLoggedIn = false
                self.accountDetails = nil
                print("Başarıyla çıkış yapıldı.")
            }
        }catch{
            print("Çıkış yapılamadı: \(error.localizedDescription)")
        }
    }
    
    
    func forceCleanKeychain() {
            do {
                // Keychain'deki tüm oturum verilerini koşulsuz şartsız sil.
                try keyChain.remove("session_id")
                try keyChain.remove("account_id")
                print("✅✅✅ Keychain başarıyla temizlendi! ✅✅✅")
            } catch {
                print("❌ Keychain temizlenirken hata oluştu: \(error)")
            }
            
            // Durumu da sıfırla ki anında Login ekranına dönsün.
            self.isLoggedIn = false
            self.accountDetails = nil
        }
}
