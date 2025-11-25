//
//  APIError.swift
//  MovieApp
//
//  Created by Kerem Saltık on 20.11.2025.
//

import Foundation

enum APIError: Error, LocalizedError{
    case invalidURL
    case requestFailed(description: String)
    case decodingFailed(description: String)
    
    var errorDescription: String? {
        switch self{
        case .invalidURL: return "Invalid URL"
        case .requestFailed(let description): return "Request Failed: \(description)"
        case .decodingFailed(let description): return "Decoding Failed: \(description)"
        }
    }
}
