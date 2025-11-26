//
//  Constants.swift
//  MovieApp
//
//  Created by Kerem Saltık on 20.11.2025.
//

import Foundation

struct K{
    struct API{
        static let apiKey = "YOUR_TMDB_API_KEY"
        
        static let baseURL = "https://api.themoviedb.org/3"
    }
    
    struct Keychain{
        static let service = "com.MovieApp.bundle.id"
        
        static let sessionID = "session_id"
        
        static let accountID = "account_id"
    }
    
    struct AppInfo{
        static let urlScheme = "movieapptmdb"
    }
}
