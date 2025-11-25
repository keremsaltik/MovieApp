//
//  SessionManager.swift
//  MovieApp
//
//  Created by Kerem Saltık on 1.11.2025.
//

import Foundation
import KeychainAccess
import Combine

@MainActor
class SessionManager: ObservableObject{
    
    @Published var isLoadingAuthentication: Bool = true
    
    @Published var isLoggedIn = false
    
    @Published var accountDetails: AccountDetailResponse?
    
    private let networkService = NetworkService()
    private let keyChain = Keychain(service: K.Keychain.service)
    
    /*init() {
     // Check when app started.
     Task{
     await checkAuthentication()
     }    }*/
    
    
    func checkAuthentication() async{
        guard let sessionID =  try? keyChain.get(K.Keychain.sessionID) else {
            self.isLoggedIn = false
            self.accountDetails = nil
            self.isLoadingAuthentication = false
            return
        }
        
        do{
            let details = try await networkService.getAccountDetails(sessionID: sessionID)
            self.accountDetails = details
            self.isLoggedIn = true
        }catch{
#if DEBUG
            print("Oturum doğrulaması başarısız: \(error.localizedDescription)")
#endif
            await logout()
        }
        
        self.isLoadingAuthentication = false
    }
    
    func loginSuccessful(details: AccountDetailResponse){
        self.accountDetails = details
        self.isLoggedIn = true
    }
    
    func logout() async{
        
        guard let sessionID = try? keyChain.get(K.Keychain.sessionID) else {
            self.isLoggedIn = false
            self.accountDetails = nil
            return
            
        }
        
        do{
            let success = try await networkService.deleteSession(sessionId: sessionID)
            
            if success{
                try? keyChain.remove(K.Keychain.sessionID)
                try keyChain.remove(K.Keychain.accountID)
                self.isLoggedIn = false
                self.accountDetails = nil
                
            }
        }catch{
#if DEBUG
            print("Çıkış yapılamadı: \(error.localizedDescription)")
#endif
        }
    }
    
    
    /*func forceCleanKeychain() {
     do {
     try keyChain.remove(K.Keychain.sessionID)
     try keyChain.remove(K.Keychain.accountID)
     
     } catch {
     #if DEBUG
     print("\(error)")
     #endif
     }
     self.isLoggedIn = false
     self.accountDetails = nil
     }*/
}
