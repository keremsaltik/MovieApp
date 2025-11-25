//
//  RequestTokenResponse.swift
//  MovieApp
//
//  Created by Kerem Saltık on 28.10.2025.
//

import Foundation

struct RequestTokenResponse: Codable{
    let success: Bool
    let expires_at: String
    let request_token: String
}
