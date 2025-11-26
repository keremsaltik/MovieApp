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
    
    func handleRedirect(url: URL) async {
            
            // 1. Gelen URL'den onaylanmış token'ı al.
            guard url.scheme == K.AppInfo.urlScheme,
                  let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
                  let approvedToken = components.queryItems?.first(where: { $0.name == "request_token" })?.value else {
                return
            }
            do {
                let finalSessionID = try await networkService.createSessionID(with: approvedToken)
                let accountDetails = try await networkService.getAccountDetails(sessionID: finalSessionID)
                
                try keyChain.set(finalSessionID, key: K.Keychain.sessionID)
                try keyChain.set(String(accountDetails.id), key: K.Keychain.accountID)
                self.loginSuccessful(details: accountDetails)
                
            } catch {
                print("❌ SessionManager: Yönlendirme işlenirken hata oluştu: \(error)")
            }
        }
        
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
                    cleanLocalSession()
                    return
                }
                
                Task(priority: .background) {
                    do {
                        let success = try await networkService.deleteSession(sessionId: sessionID)
                        if success {
                            print("✅ TMDB oturumu sunucuda başarıyla sonlandırıldı.")
                        }
                    } catch {
                        print("⚠️ TMDB oturumu sunucuda sonlandırılamadı: \(error.localizedDescription)")
                    }
                }
                
                // EN ÖNEMLİ KISIM:
                // Ağ isteğinin bitmesini BEKLEMEDEN, yerel durumu ANINDA temizle.
                cleanLocalSession()
    }
    
    private func cleanLocalSession() {
           try? keyChain.remove(K.Keychain.sessionID)
           try? keyChain.remove(K.Keychain.accountID)
           self.isLoggedIn = false 
           print("✅ Yerel oturum temizlendi ve navigasyon tetiklendi.")
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
