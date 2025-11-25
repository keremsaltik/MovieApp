//
//  AccountDetailResponse.swift
//  MovieApp
//
//  Created by Kerem Saltık on 3.11.2025.
//

import Foundation


struct Gravatar: Codable{
    let hash: String?
}

struct TMDBAvatar: Codable{
    let avatar_path: String?
}

struct Avatar: Codable{
    let gravatar: Gravatar
    let tmdb: TMDBAvatar
}

struct AccountDetailResponse: Codable{
    let id: Int
    let username: String
    let name: String?
    let avatar: Avatar
    
    // Computed Property
    var avatarURL: URL? {
        if let avatarPath = avatar.tmdb.avatar_path{
            return URL(string: "https://image.tmdb.org/t/p/w200\(avatarPath)")
        }
        
        if let gravatarHash = avatar.gravatar.hash{
            return URL(string: "https://www.gravatar.com/avatar/\(gravatarHash)")
        }
        
        return nil
    }
}
