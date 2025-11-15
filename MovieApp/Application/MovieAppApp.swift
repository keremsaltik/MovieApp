//
//  MovieAppApp.swift
//  MovieApp
//
//  Created by Kerem Saltık on 13.10.2025.
//

import SwiftUI

@main
struct MovieAppApp: App {
    
    @StateObject private var sessionManager = SessionManager()
    
    var body: some Scene {
        WindowGroup {
            if sessionManager.isLoggedIn{
                HomeView()
            }else{
                SignInView()
            }
        
                
        }
        .environmentObject(sessionManager)
    }
}
